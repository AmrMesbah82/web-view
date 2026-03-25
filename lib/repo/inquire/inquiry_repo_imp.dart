// ═══════════════════════════════════════════════════════════════════
// FILE 3: inquiry_repo_imp.dart
// Path: lib/repo/inquiry/inquiry_repo_imp.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:website_app/model/inquiry_model.dart';
import 'package:website_app/repo/inquire/inquiry_repo.dart';

class InquiryRepoImp implements InquiryRepo {
  final FirebaseFirestore _firestore;

  InquiryRepoImp({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('inquiries');

  @override
  Future<List<InquiryModel>> fetchAllInquiries() async {
    try {
      print('🟡 [InquiryRepoImp] fetchAllInquiries()');
      final snapshot = await _collection
          .orderBy('submissionDate', descending: true)
          .get(const GetOptions(source: Source.server));

      final list = snapshot.docs
          .map((doc) => InquiryModel.fromMap(doc.id, doc.data()))
          .toList();

      print('🟢 [InquiryRepoImp] fetchAllInquiries() — got ${list.length}');
      return list;
    } catch (e) {
      print('🔴 [InquiryRepoImp] fetchAllInquiries() ERROR: $e');
      try {
        final snapshot = await _collection
            .orderBy('submissionDate', descending: true)
            .get(const GetOptions(source: Source.cache));
        return snapshot.docs
            .map((doc) => InquiryModel.fromMap(doc.id, doc.data()))
            .toList();
      } catch (_) {
        rethrow;
      }
    }
  }

  @override
  Future<InquiryModel?> fetchInquiryById(String id) async {
    try {
      print('🟡 [InquiryRepoImp] fetchInquiryById($id)');
      final doc = await _collection.doc(id).get(const GetOptions(source: Source.server));
      if (!doc.exists || doc.data() == null) return null;
      return InquiryModel.fromMap(doc.id, doc.data()!);
    } catch (e) {
      print('🔴 [InquiryRepoImp] fetchInquiryById() ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateInquiry(InquiryModel inquiry) async {
    try {
      print('🟡 [InquiryRepoImp] updateInquiry(${inquiry.id})');
      await _collection.doc(inquiry.id).update(inquiry.toMap());
      print('🟢 [InquiryRepoImp] updateInquiry() — done');
    } catch (e) {
      print('🔴 [InquiryRepoImp] updateInquiry() ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateStatus(String id, InquiryStatus status) async {
    try {
      print('🟡 [InquiryRepoImp] updateStatus($id → ${status.label})');
      await _collection.doc(id).update({'status': status.label});
      print('🟢 [InquiryRepoImp] updateStatus() — done');
    } catch (e) {
      print('🔴 [InquiryRepoImp] updateStatus() ERROR: $e');
      rethrow;
    }
  }
}