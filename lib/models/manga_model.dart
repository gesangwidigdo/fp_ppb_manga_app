class TopMangaModel {
  final int id;
  final String title;
  final String? imageUrl;
  final int? chapters;
  final double? score;

  TopMangaModel({
    required this.id,
    required this.title,
    this.imageUrl,
    this.chapters,
    this.score,
  });

  factory TopMangaModel.fromJson(Map<String, dynamic> json) {
    return TopMangaModel(
      id: json['mal_id'] as int,
      title: (json['title_english'] as String?) ?? json['title'] as String,
      imageUrl: json['images']['jpg']['image_url'] as String?,
      chapters: json['chapters'] as int?,
      score: (json['score'] as num?)?.toDouble(),
    );
  }
}