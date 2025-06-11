class MangaModel {
  final int id;
  final String title;
  final String? imageUrl;

  MangaModel({
    required this.id,
    required this.title,
    this.imageUrl,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      id: json['mal_id'] as int,
      title: (json['title_english'] as String?) ?? json['title'] as String,
      imageUrl: json['images']['jpg']['image_url'] as String?,
    );
  }
}

class TopMangaModel extends MangaModel {
  final int? chapters;
  final double? score;

  TopMangaModel({
    required super.id,
    required super.title,
    super.imageUrl,
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

class ReviewedMangaModel extends MangaModel {
  final int rating;
  final String review;

  ReviewedMangaModel({
    required super.id,
    required super.title,
    super.imageUrl,
    required this.rating,
    required this.review,
  });

  factory ReviewedMangaModel.fromJson(Map<String, dynamic> json) {
    return ReviewedMangaModel(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      rating: json['rating'] as int,
      review: json['review'] as String,
    );
  }
}

class FullMangaModel extends MangaModel {
  final String titleJap;
  final String type;
  final int year;
  final String status;
  final int rank;
  final double score;
  final String synopsis;
  final String authors;
  final String genres;
  final String themes;
  final String demographics;

  FullMangaModel({
    required super.id,
    required super.title,
    super.imageUrl,
    required this.titleJap,
    required this.type,
    required this.year,
    required this.status,
    required this.rank,
    required this.score,
    required this.synopsis,
    required this.authors,
    required this.genres,
    required this.themes,
    required this.demographics,
  });

  factory FullMangaModel.fromJson(Map<String, dynamic> json) {
    List<String> getNames(List<dynamic>? list) {
      if (list == null || list.isEmpty) {
        return [];
      }
      return list.map((item) => item['name'] as String).toList();
    }

    List<String> authorNames = getNames(json['authors'] as List<dynamic>?);
    List<String> genreNames = getNames(json['genres'] as List<dynamic>?);
    List<String> themeNames = getNames(json['themes'] as List<dynamic>?);
    List<String> demographicNames = getNames(json['demographics'] as List<dynamic>?);

    return FullMangaModel(
      id: json['mal_id'] as int,
      title: (json['title_english'] as String?) ?? json['title'] as String,
      imageUrl: json['images']['jpg']['image_url'] as String?,
      titleJap: json['title_japanese'] as String,
      type: json['type'] as String,
      year: json['published']['prop']['from']['year'] as int,
      status: json['status'] as String,
      rank: json['rank'] as int? ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      synopsis: json['synopsis'] as String,
      authors: authorNames.join(' • '),
      genres: genreNames.join(', '),
      themes: themeNames.join(', '),
      demographics: demographicNames.join(', '),
    );
  }
}