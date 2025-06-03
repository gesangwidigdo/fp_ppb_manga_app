import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/services/manga_service.dart';

class CollectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MangaService _mangaService = MangaService();

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

      const int batchSize = 4;
      for (var collection in collections) {
        if (collection.mangaIds.isNotEmpty) {
          final List<String> imageUrls = [];
          final List<Future<MangaModel>> fetchFutures = [];

          final mangaIdsToFetch = collection.mangaIds.take(batchSize).cast<int>().toList();

          for (var mangaId in mangaIdsToFetch) {
            fetchFutures.add(_mangaService.fetchMangaById(mangaId));
          }

          final results = await Future.wait(fetchFutures.map((future) async {
            try {
              return await future;
            } catch (e) {
              print('Error fetching image for manga ID: $e');
              return null;
            }
          }));

          for (var manga in results) {
            if (manga?.imageUrl != null) {
              imageUrls.add(manga!.imageUrl!);
            }
          }
          collection.coverImageUrls = imageUrls;

          await Future.delayed(const Duration(milliseconds: 200));
        }
      }

      return collections;
    } catch (e) {
      print('Error fetching collections for user $userId: $e');
      throw Exception('Failed to load collections');
    }
  }

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
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return CollectionModel(id: docRef.id, name: name, mangaIds: mangaIds, userId: userId);
    } catch (e) {
      print('Error creating collection: $e');
      throw Exception('Failed to create collection');
    }
  }

  Future<void> addMangaToCollection(String collectionId, int mangaId) async {
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