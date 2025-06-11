class CollectionModel {
  final String id;
  final String name;
  final List<MangaInCollectionModel> mangas;

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
        .map((mangaData) => MangaInCollectionModel.fromMap(mangaData as Map<String, dynamic>))
        .toList();

    return CollectionModel(
      id: id,
      name: data['name'] as String,
      mangas: mangas,
    );
  }
}

class MangaInCollectionModel {
  final int id;
  final String title;
  final String imageUrl;
  final int? chapters;
  final double? score;

  MangaInCollectionModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.chapters,
    this.score,
  });

  factory MangaInCollectionModel.fromMap(Map<String, dynamic> map) {
    return MangaInCollectionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      chapters: map['chapters'] as int?,
      score: map['score'] != null ? (map['score'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'chapters': chapters,
      'score': score,
    };
  }
}