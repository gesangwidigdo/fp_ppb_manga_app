import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_ppb_manga_app/models/user_model.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchAllUsers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await _firestore.collection('users').where(FieldPath.documentId, isNotEqualTo: uid).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return UserModel(
        id: doc.id,
        name: data['username'] as String,
        imageUrl: data['profilePicture'] as String? ?? '',
      );
    }).toList();
  }
}