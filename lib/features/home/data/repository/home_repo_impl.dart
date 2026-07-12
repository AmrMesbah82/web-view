// ******************* FILE INFO *******************
// File Name: home_repo_impl.dart
// Description: Firebase implementation of HomeRepository.
//   • Firestore  → document: homePage/home_page (FLAT VERSIONED — admin format)
//   • Storage    → bucket path: home_cms/...
// UPDATED: Path + format synced with web_app_admin (was cms/home_page, nested).
//          Admin writes with FlatCodec.writeVersioned → we decode with
//          FlatCodec.decode + HomePageModel.flatTemplate.
// Created by: Amr Mesbah

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/utils/flat_codec.dart';
import '../../domain/base_repository/home_repo.dart';
import '../models/home_model.dart';


class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    String collection   = 'homePage',
    String publishedDoc = 'home_page',
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _collection = collection,
        _document = publishedDoc;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  // Same paths the admin app writes to:
  //   Home → homePage/home_page      Main → mainPage/main
  final String _collection;
  final String _document;

  DocumentReference<Map<String, dynamic>> get _docRef =>
      _firestore.collection(_collection).doc(_document);

  // ── Fetch (cache-first) ──────────────────────────────────────────────────

  @override
  Future<HomePageModel> fetchHomePage() async {
    try {
      final snapshot = await _docRef.get();
      if (!snapshot.exists || snapshot.data() == null) {
        return HomePageModel.defaultModel;
      }
      final model = HomePageModel.fromMap(
        FlatCodec.decode(_sanitize(snapshot.data()!), HomePageModel.flatTemplate),
      );
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
      final model = HomePageModel.fromMap(
        FlatCodec.decode(_sanitize(snapshot.data()!), HomePageModel.flatTemplate),
      );
      return model;
    } catch (e, st) {
      return HomePageModel.defaultModel;
    }
  }

// ── Sanitize raw Firestore map ────────────────────────────────────────────

  Map<String, dynamic> _sanitize(Map<String, dynamic> data) {
    return Map<String, dynamic>.from(data);
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  @override
  Future<void> saveHomePage(HomePageModel model) async {
    try {
      final nested = {
        ...model.toMap(),
        'scheduledPublishDate': model.scheduledPublishDate?.toIso8601String(),
      };
      await FlatCodec.writeVersioned(_docRef, nested);
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
        return HomePageModel.fromMap(
          FlatCodec.decode(_sanitize(snap.data()!), HomePageModel.flatTemplate),
        );
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