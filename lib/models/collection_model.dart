import 'package:fp_ppb_manga_app/models/manga_model.dart';

class CollectionModel {
  final String id;
  final String name;
  final List<FullMangaModel> mangas;

  List<String> get coverImageUrls {
    return mangas
        .map((m) => m.imageUrl)
        .where((url) => url.isNotEmpty)
        .take(4)
        .toList();
  }

  CollectionModel({
    required this.id,
    required this.name,
    this.mangas = const [],
  });

  factory CollectionModel.fromFirestore(Map<String, dynamic> data, String id) {
    final mangasData = data['mangas'] as List<dynamic>? ?? [];
    final mangas = mangasData
        .map((mangaData) => FullMangaModel.fromMapCollection(mangaData as Map<String, dynamic>))
        .toList();

    return CollectionModel(
      id: id,
      name: data['name'] as String,
      mangas: mangas,
    );
  }
}