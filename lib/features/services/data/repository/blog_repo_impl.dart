// ******************* FILE INFO *******************
// File Name: blog_repo_impl.dart
// Created by: Amr Mesbah

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/base_repository/blog_repo.dart';
import '../models/blog_model.dart';


class BlogRepositoryImpl implements BlogRepository {
  BlogRepositoryImpl({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage   = storage   ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage   _storage;

  static const String _collection = 'blog_posts';

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(_collection);

  // ── Fetch all ─────────────────────────────────────────────────────────────
  @override
  Future<List<BlogPostModel>> fetchAllPosts() async {
    try {
      final snap = await _col.orderBy('createdAt', descending: true).get();
      final posts = snap.docs
          .map((d) => BlogPostModel.fromMap(d.id, _sanitize(d.data())))
          .toList();
      return posts;
    } catch (e) {
      return [];
    }
  }

  // ── Fetch single ──────────────────────────────────────────────────────────
  @override
  Future<BlogPostModel> fetchPost(String id) async {
    try {
      final snap = await _col.doc(id).get();
      if (!snap.exists || snap.data() == null) return BlogPostModel.empty();
      return BlogPostModel.fromMap(snap.id, _sanitize(snap.data()!));
    } catch (e) {
      return BlogPostModel.empty();
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────
  @override
  Future<String> createPost(BlogPostModel post) async {
    try {
      final ref = await _col.add({
        ...post.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return ref.id;
    } catch (e) {
      rethrow;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────
  @override
  Future<void> updatePost(BlogPostModel post) async {
    try {
      await _col.doc(post.id).set({
        ...post.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  @override
  Future<void> deletePost(String id) async {
    try {
      await _col.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // ── Upload image ──────────────────────────────────────────────────────────
  @override
  Future<String> uploadImage({required Uint8List bytes, required String storagePath}) async {
    try {
      final ref  = _storage.ref().child(storagePath);
      final mime = _detectMime(bytes);
      final task = await ref.putData(bytes, SettableMetadata(contentType: mime));
      final url  = await task.ref.getDownloadURL();
      return url;
    } catch (e) {
      rethrow;
    }
  }

  // ── Watch ─────────────────────────────────────────────────────────────────
  @override
  Stream<List<BlogPostModel>> watchAllPosts() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((snap) =>
        snap.docs.map((d) => BlogPostModel.fromMap(d.id, _sanitize(d.data()))).toList());
  }

  Map<String, dynamic> _sanitize(Map<String, dynamic> d) {
    final copy = Map<String, dynamic>.from(d);
    // keep createdAt for display but remove updatedAt timestamp
    copy.remove('updatedAt');
    return copy;
  }

  String _detectMime(Uint8List b) {
    if (b.length < 4) return 'application/octet-stream';
    if (b[0] == 0x89 && b[1] == 0x50) return 'image/png';
    if (b[0] == 0xFF && b[1] == 0xD8) return 'image/jpeg';
    if (b[0] == 0x47 && b[1] == 0x49) return 'image/gif';
    if (b[0] == 0x52 && b[1] == 0x49 && b.length >= 12 &&
        b[8] == 0x57 && b[9] == 0x45) return 'image/webp';
    if (b[0] == 0x3C) return 'image/svg+xml';
    return 'image/jpeg';
  }
}