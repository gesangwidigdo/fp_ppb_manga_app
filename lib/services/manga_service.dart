import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:http/http.dart' as http;

class MangaService {
  final baseUri = 'https://api.jikan.moe/v4/';
  final _firestore = FirebaseFirestore.instance;

  Future<List<TopMangaModel>> fetchTopManga() async {
    final uri = Uri.parse('${baseUri}top/manga?limit=24');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final Map<String, dynamic> mangaList = data;
      final List<dynamic> mangaData = mangaList['data'];
      return mangaData.map((manga) => TopMangaModel.fromJson(manga)).toList();
    } else {
      throw Exception('Failed to load top manga');
    }
  }

  Future<List<MangaModel>> searchManga(String query) async {
    final uri = Uri.parse('${baseUri}manga?q=$query&limit=20');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final Map<String, dynamic> mangaList = data;
      final List<dynamic> mangaData = mangaList['data'];
      return mangaData.map((manga) => MangaModel.fromJson(manga)).toList();
    } else {
      throw Exception('Failed to search manga');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllReviews() async {
    final snapshot = await _firestore.collection('review').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': int.parse(doc.id),
        'rating': data['rating'] as int,
        'review': data['review'] as String,
      };
    }).toList();
  }

  Future<List<ReviewedMangaModel>> fetchReviewedManga() async {
    final reviews = await fetchAllReviews();
    final List<ReviewedMangaModel> allResults = [];

    Future<ReviewedMangaModel> fetchOne(Map<String, dynamic> r) async {
      final int id = r['id'] as int;
      final uri = Uri.parse('${baseUri}manga/$id');
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Failed to load manga details for id $id');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final mangaData = json['data'] as Map<String, dynamic>;
      final title = (mangaData['title_english'] as String?) 
                    ?? (mangaData['title'] as String);
      final imageUrl = (mangaData['images']['jpg']['image_url'] as String?);
      return ReviewedMangaModel(
        id: id,
        title: title,
        imageUrl: imageUrl,
        rating: r['rating'] as int,
        review: r['review'] as String,
      );
    }

    const int batchSize = 3;
    for (var i = 0; i < reviews.length; i += batchSize) {
      final end = (i + batchSize < reviews.length) ? i + batchSize : reviews.length;
      final batch = reviews.sublist(i, end);
      final batchResults = await Future.wait(batch.map(fetchOne));
      allResults.addAll(batchResults);

      if (end < reviews.length) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return allResults;
  }
  
  Future<void> addReview({
    required int id,
    required int rating,
    required String review,
  }) async {
    final docRef = _firestore.collection('review').doc(id.toString());
    await docRef.set({
      'rating': rating,
      'review': review,
    });
  }
}