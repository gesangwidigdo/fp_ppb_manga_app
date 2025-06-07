import 'package:fp_ppb_manga_app/models/manga_model.dart';

class CollectionModel {
  final String id;
  final String name;
  final List<MangaInCollectionModel> mangas;
  final String userId;

  List<String> get coverImageUrls {
    return mangas
        .map((m) => m.imageUrl ?? '')
        .where((url) => url.isNotEmpty)
        .take(4)
        .toList();
  }

  CollectionModel({
    required this.id,
    required this.name,
    this.mangas = const [],
    required this.userId,
  });

  factory CollectionModel.fromFirestore(Map<String, dynamic> data, String id) {
    final mangasData = data['mangas'] as List<dynamic>? ?? [];
    final mangas = mangasData
        .map((mangaData) => MangaInCollectionModel.fromMap(mangaData as Map<String, dynamic>))
        .toList();

    return CollectionModel(
      id: id,
      name: data['name'] as String,
      mangas: mangas,
      userId: data['userId'] as String,
    );
  }
}

class MangaInCollectionModel {
  final int id;
  final String title;
  final String? imageUrl;

  MangaInCollectionModel({
    required this.id,
    required this.title,
    this.imageUrl,
  });

  factory MangaInCollectionModel.fromMap(Map<String, dynamic> map) {
    return MangaInCollectionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}