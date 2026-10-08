// ******************* FILE INFO *******************
// File Name: job_repository_impl.dart
// Created by: Amr Mesbah
// Purpose: Firebase Firestore implementation of JobListingRepo

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/flat_codec.dart';
import '../../domain/base_repository/job_repo.dart';
import '../models/job_model.dart';


class JobListingRepoImpl implements JobListingRepo {
  final FirebaseFirestore _firestore;

  JobListingRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// ── Collection reference ──────────────────────────────────────────────────
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('jobListings');

  // ══════════════════════════════════════════════════════════════════════════
  //  FETCH ALL
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<List<JobPostModel>> fetchAllJobs() async {
    // BUG-13: the public Careers / Jobs pages showed NO jobs. Two reasons:
    //  • a single document that failed to parse (blank number, Timestamp
    //    date…) threw and emptied the whole list — now each document is
    //    parsed on its own and a bad one is skipped;
    //  • orderBy('Last_Updated_At') silently drops every document that lacks
    //    that field — the list is now sorted in memory instead.
    //
    // BUG-01 / BUG-99: the rules now only let visitors read published jobs
    // (scalar `Public_Listed == true`, written by the admin app). A query must
    // ask for exactly that, otherwise Firestore refuses the whole query.
    final query = _collection.where('Public_Listed', isEqualTo: true);
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await query.get(const GetOptions(source: Source.server));
    } catch (_) {
      snapshot = await query.get(const GetOptions(source: Source.cache));
    }

    final entries = <({JobPostModel job, DateTime stamp})>[];
    for (final doc in snapshot.docs) {
      try {
        final job = JobPostModel.fromMap(
          doc.id,
          FlatCodec.decode(doc.data(), JobPostModel.flatTemplate),
        );
        entries.add((job: job, stamp: _stamp(doc.data()['Last_Updated_At'])));
      } catch (_) {
        // skip a malformed job instead of hiding every job
      }
    }
    entries.sort((a, b) => b.stamp.compareTo(a.stamp));
    return entries.map((e) => e.job).toList();
  }

  static DateTime _stamp(dynamic v) {
    try {
      if (v != null) return (v as dynamic).toDate() as DateTime;
    } catch (_) {}
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  FETCH BY ID
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<JobPostModel?> fetchJobById(String id) async {
    final DocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = await _collection.doc(id).get(const GetOptions(source: Source.server));
    } on FirebaseException catch (e) {
      // BUG-99: a removed / draft job is no longer readable by visitors.
      if (e.code == 'permission-denied') return null;
      rethrow;
    }
    if (!doc.exists || doc.data() == null) return null;
    return JobPostModel.fromMap(
      doc.id,
      FlatCodec.decode(doc.data()!, JobPostModel.flatTemplate),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  CREATE
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<JobPostModel> createJob(JobPostModel job) async {
    try {
      final docRef = await _collection.add(job.toMap());
      final created = job.copyWith(id: docRef.id);
      return created;
    } catch (e) {
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> updateJob(JobPostModel job) async {
    try {
      await _collection.doc(job.id).update(job.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  DELETE (hard)
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> deleteJob(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  REMOVE (soft — sets status to Removed)
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> removeJob(String id) async {
    try {
      await _collection.doc(id).update({
        'status': JobStatus.removed.label,
        'endedDate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  UPDATE STATUS
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> updateJobStatus(String id, JobStatus status) async {
    try {
      final Map<String, dynamic> data = {'status': status.label};
      if (status == JobStatus.ended || status == JobStatus.removed || status == JobStatus.inactive) {
        data['endedDate'] = DateTime.now().toIso8601String();
      }
      if (status == JobStatus.active) {
        data['postedDate'] = DateTime.now().toIso8601String();
      }
      await _collection.doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  STREAM ALL (real-time)
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Stream<List<JobPostModel>> streamAllJobs() {
    return _collection
        .orderBy('Last_Updated_At', descending: true)
        .snapshots()
        .map((snapshot) {
      final jobs = snapshot.docs.map((doc) {
        return JobPostModel.fromMap(
          doc.id,
          FlatCodec.decode(doc.data(), JobPostModel.flatTemplate),
        );
      }).toList();
      return jobs;
    });
  }
}