import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';

class CollectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<List<CollectionModel>> fetchCollections() async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in.');
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('collection')
          .orderBy('createdAt', descending: true)
          .get();

      final List<CollectionModel> collections = snapshot.docs
          .map((doc) => CollectionModel.fromFirestore(doc.data(), doc.id))
          .toList();

      return collections;
    } catch (e) {
      print('Error fetching collections for user $userId: $e');
      throw Exception('Failed to load collections');
    }
  }

  Future<CollectionModel> createCollection(String name, {MangaInCollectionModel? initialManga}) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in.');
    }

    try {
      List<Map<String, dynamic>> mangas = [];
      if (initialManga != null) {
        mangas.add(initialManga.toMap());
      }

      final docRef = await _firestore.collection('users').doc(userId).collection('collection').add({
        'name': name,
        'mangas': mangas,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return CollectionModel(
        id: docRef.id,
        name: name,
        mangas: initialManga != null ? [initialManga] : [],
      );
    } catch (e) {
      print('Error creating collection: $e');
      throw Exception('Failed to create collection');
    }
  }

  Future<void> addMangaToCollection(String collectionId, MangaInCollectionModel manga) async {
    final userId = currentUserId;
    try {
      final collectionRef = _firestore.collection('users').doc(userId).collection('collection').doc(collectionId);
      await collectionRef.update({
        'mangas': FieldValue.arrayUnion([manga.toMap()]),
      });
    } catch (e) {
      print('Error adding manga to collection: $e');
      throw Exception('Failed to add manga to collection');
    }
  }

  Future<void> removeMangaFromCollection(String collectionId, int mangaId) async {
    final userId = currentUserId;
    try {
      final collectionRef = _firestore.collection('users').doc(userId).collection('collection').doc(collectionId);
      final doc = await collectionRef.get();
      if (doc.exists) {
        final List<dynamic> mangas = doc.data()?['mangas'] ?? [];
        final updatedMangas = mangas.where((m) => m['id'] != mangaId).toList();
        await collectionRef.update({'mangas': updatedMangas});
      }
    } catch (e) {
      print('Error removing manga from collection: $e');
      throw Exception('Failed to remove manga from collection');
    }
  }

  Future<void> updateCollectionName(String collectionId, String newName) async {
    final userId = currentUserId;
    try {
      final collectionRef = _firestore.collection('users').doc(userId).collection('collection').doc(collectionId);
      await collectionRef.update({'name': newName});
    } catch (e) {
      print('Error updating collection name: $e');
      throw Exception('Failed to update collection name');
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    final userId = currentUserId;
    try {
      final collectionRef = _firestore.collection('users').doc(userId).collection('collection').doc(collectionId);
      await collectionRef.delete();
    } catch (e) {
      print('Error deleting collection: $e');
      throw Exception('Failed to delete collection');
    }
  }
}