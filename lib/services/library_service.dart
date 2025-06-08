import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb_manga_app/models/library_model.dart';

class LibraryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> addMangaToLibrary({required MangaLibraryModel manga}) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw Exception('User not logged in.');
      }
      final docRef = _firestore
          .collection('library')
          .doc(userId)
          .collection('mangas')
          .doc(manga.mangaId.toString());

      await docRef.set(manga.toMap());
    } catch (e) {
      print('Error adding manga to library: $e');
    }
  }

  Future<List<MangaLibraryModel>> fetchLibrary(String userId) async {
    final snapshot =
        await _firestore
            .collection('library')
            .doc(userId)
            .collection('mangas')
            .get();

    return snapshot.docs
        .map((doc) => MangaLibraryModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateMangaReadingStatus({
    required int mangaId,
    required ReadingStatus status,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw Exception('User not logged in.');
      }
      final docRef = _firestore
          .collection('library')
          .doc(userId)
          .collection('mangas')
          .doc(mangaId.toString());

      await docRef.update({'status': status.toString().split('.').last});
    } catch (e) {
      print('Error updating manga reading status: $e');
    }
  }

  Future<void> removeMangaFromLibrary({required int mangaId}) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw Exception('User not logged in.');
      }
      final docRef = _firestore
          .collection('library')
          .doc(userId)
          .collection('mangas')
          .doc(mangaId.toString());

      await docRef.delete();
    } catch (e) {
      print('Error removing manga from library: $e');
    }
  }
}
