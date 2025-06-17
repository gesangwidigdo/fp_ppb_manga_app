import 'package:fp_ppb_manga_app/models/manga_model.dart';

class ReviewedMangaModel extends MangaModel {
  final int rating;
  final String review;

  ReviewedMangaModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required this.rating,
    required this.review,
  });

  factory ReviewedMangaModel.fromJson(Map<String, dynamic> json) {
    return ReviewedMangaModel(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: json['rating'] as int,
      review: json['review'] as String,
    );
  }
}