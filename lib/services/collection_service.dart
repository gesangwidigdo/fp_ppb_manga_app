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
          .collection('collections')
          .where('userId', isEqualTo: userId)
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

      final docRef = await _firestore.collection('collections').add({
        'name': name,
        'mangas': mangas, // Field 'mangas'
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return CollectionModel(
          id: docRef.id,
          name: name,
          mangas: initialManga != null ? [initialManga] : [],
          userId: userId);
    } catch (e) {
      print('Error creating collection: $e');
      throw Exception('Failed to create collection');
    }
  }

  Future<void> addMangaToCollection(String collectionId, MangaInCollectionModel manga) async {
    try {
      final collectionRef = _firestore.collection('collections').doc(collectionId);
      await collectionRef.update({
        'mangas': FieldValue.arrayUnion([manga.toMap()]),
      });
    } catch (e) {
      print('Error adding manga to collection: $e');
      throw Exception('Failed to add manga to collection');
    }
  }

  Future<void> removeMangaFromCollection(String collectionId, int mangaId) async {
    try {
      final collectionRef = _firestore.collection('collections').doc(collectionId);
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
}