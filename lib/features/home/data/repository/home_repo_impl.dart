// ******************* FILE INFO *******************
// File Name: home_repo_impl.dart
// Description: Firebase implementation of HomeRepository.
//   • Firestore  → document: cms/home_page
//   • Storage    → bucket path: home_cms/...
// Created by: Amr Mesbah

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/base_repository/home_repo.dart';
import '../models/home_model.dart';


class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  static const String _collection = 'cms';
  static const String _document   = 'home_page';

  DocumentReference<Map<String, dynamic>> get _docRef =>
      _firestore.collection(_collection).doc(_document);

  // ── Fetch (cache-first) ──────────────────────────────────────────────────

  // ── Fetch (cache-first) ──────────────────────────────────────────────────

  @override
  Future<HomePageModel> fetchHomePage() async {
    try {
      final snapshot = await _docRef.get();
      if (!snapshot.exists || snapshot.data() == null) {
        return HomePageModel.defaultModel;
      }
      final data = _sanitize(snapshot.data()!);
      if ((data['sections'] as List?)?.isNotEmpty == true) {
        final s0 = (data['sections'] as List)[0] as Map<String, dynamic>;
      }
      final model = HomePageModel.fromMap(data);
      return model;
    } catch (e, st) {
      return HomePageModel.defaultModel;
    }
  }

// ── Fetch FRESH (server only, bypasses cache) ────────────────────────────

  @override
  Future<HomePageModel> fetchHomePageFresh() async {
    try {
      final snapshot = await _docRef.get(const GetOptions(source: Source.server));
      if (!snapshot.exists || snapshot.data() == null) {
        return HomePageModel.defaultModel;
      }
      final data = _sanitize(snapshot.data()!);
      if ((data['sections'] as List?)?.isNotEmpty == true) {
        final s0 = (data['sections'] as List)[0] as Map<String, dynamic>;
      }
      final model = HomePageModel.fromMap(data);
      return model;
    } catch (e, st) {
      return HomePageModel.defaultModel;
    }
  }

// ── Sanitize raw Firestore map ────────────────────────────────────────────

  Map<String, dynamic> _sanitize(Map<String, dynamic> data) {
    final copy = Map<String, dynamic>.from(data);
    // lastUpdatedAt comes back as a Firestore Timestamp object from Source.server
    // but fromMap() tries to cast it as String → crash. Just drop it.
    copy.remove('lastUpdatedAt');
    return copy;
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  @override
  Future<void> saveHomePage(HomePageModel model) async {
    if (model.sections.isNotEmpty) {
    }
    try {
      final map = {
        ...model.toMap(),
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      };
      await _docRef.set(map);
    } catch (e, st) {
      rethrow;
    }
  }

  // ── Upload ───────────────────────────────────────────────────────────────

  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String storagePath,
  }) async {
    try {
      final ref  = _storage.ref().child(storagePath);
      final mime = _detectMime(bytes);
      final task = await ref.putData(bytes, SettableMetadata(contentType: mime));
      final url  = await task.ref.getDownloadURL();
      return url;
    } catch (e, st) {
      rethrow;
    }
  }

  // ── Watch ────────────────────────────────────────────────────────────────

  @override
  Stream<HomePageModel> watchHomePage() {
    return _docRef.snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return HomePageModel.defaultModel;
      try {
        return HomePageModel.fromMap(snap.data()!);
      } catch (e) {
        return HomePageModel.defaultModel;
      }
    });
  }

  // ── MIME sniff ────────────────────────────────────────────────────────────

  String _detectMime(Uint8List b) {
    if (b.length < 4) return 'application/octet-stream';
    if (b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) return 'image/png';
    if (b[0] == 0xFF && b[1] == 0xD8)                                   return 'image/jpeg';
    if (b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x38) return 'image/gif';
    if (b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46 &&
        b.length >= 12 && b[8] == 0x57 && b[9] == 0x45 &&
        b[10] == 0x42 && b[11] == 0x50)                                  return 'image/webp';
    if (b[0] == 0x3C)                                                    return 'image/svg+xml';
    return 'image/jpeg';
  }
}