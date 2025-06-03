import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import firebase_auth
import 'package:fp_ppb_manga_app/models/collection_model.dart';

class CollectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  String? get currentUserId => _auth.currentUser?.uid; // Helper to get current user ID

  // Fetch all collections for the current user
  Future<List<CollectionModel>> fetchCollections() async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in.');
    }

    try {
      final snapshot = await _firestore
          .collection('collections')
          .where('userId', isEqualTo: userId) // Filter by userId
          .get();
      return snapshot.docs
          .map((doc) => CollectionModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching collections for user $userId: $e');
      throw Exception('Failed to load collections');
    }
  }

  // Create a new collection
  Future<CollectionModel> createCollection(String name, {int? initialMangaId}) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in.');
    }

    try {
      List<int> mangaIds = [];
      if (initialMangaId != null) {
        mangaIds.add(initialMangaId);
      }

      final docRef = await _firestore.collection('collections').add({
        'name': name,
        'mangaIds': mangaIds,
        'userId': userId, // Save userId with the collection
        'createdAt': FieldValue.serverTimestamp(),
      });
      return CollectionModel(id: docRef.id, name: name, mangaIds: mangaIds, userId: userId);
    } catch (e) {
      print('Error creating collection: $e');
      throw Exception('Failed to create collection');
    }
  }

  // Add a manga to an existing collection
  Future<void> addMangaToCollection(String collectionId, int mangaId) async {
    // This method implicitly relies on the collection being user-specific
    // because fetchCollections already filters by user.
    try {
      final collectionRef = _firestore.collection('collections').doc(collectionId);
      await collectionRef.update({
        'mangaIds': FieldValue.arrayUnion([mangaId]),
      });
    } catch (e) {
      print('Error adding manga to collection: $e');
      throw Exception('Failed to add manga to collection');
    }
  }

  // Remove a manga from an existing collection (optional, but good to have)
  Future<void> removeMangaFromCollection(String collectionId, int mangaId) async {
    try {
      final collectionRef = _firestore.collection('collections').doc(collectionId);
      await collectionRef.update({
        'mangaIds': FieldValue.arrayRemove([mangaId]),
      });
    } catch (e) {
      print('Error removing manga from collection: $e');
      throw Exception('Failed to remove manga from collection');
    }
  }
}