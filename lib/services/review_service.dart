import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';

class ReviewService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<ReviewedMangaModel>> fetchAllReviews() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await _firestore.collection('users').doc(uid).collection('review').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ReviewedMangaModel(
        id: data['id'] as int,
        title: data['title'] as String,
        imageUrl: data['imageUrl'] as String?,
        rating: data['rating'] as int,
        review: data['review'] as String,
      );
    }).toList();
  }
  
  Future<void> addReview({
    required int id,
    required String title,
    required String imageUrl,
    required int rating,
    required String review,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = _firestore.collection('users').doc(uid).collection('review').doc(id.toString());
    await docRef.set({
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'rating': rating,
      'review': review,
    });
  }

  Future<void> deleteReview(int id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('users').doc(uid).collection('review').doc(id.toString()).delete();
  }

  Future<void> updateReview({
    required int id,
    required String title,
    required String imageUrl,
    required int rating,
    required String review,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = _firestore.collection('users').doc(uid).collection('review').doc(id.toString());
    await docRef.update({
      'title': title,
      'imageUrl': imageUrl,
      'rating': rating,
      'review': review,
    });
  }
}