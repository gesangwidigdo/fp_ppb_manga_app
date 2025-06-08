enum ReadingStatus { unread, ongoing, completed }

class MangaLibraryModel {
  final int mangaId;
  final String title;
  final String? imageUrl;
  final double? score;
  final ReadingStatus status;

  MangaLibraryModel({
    required this.mangaId,
    required this.title,
    this.score,
    this.imageUrl,
    this.status = ReadingStatus.unread,
  });

  factory MangaLibraryModel.fromMap(Map<String, dynamic> maps) {
    return MangaLibraryModel(
      mangaId: maps['mangaId'] as int,
      title: maps['title'] as String,
      imageUrl: maps['imageUrl'] as String?,
      score: maps['score'] != null ? (maps['score'] as num).toDouble() : null,
      status: ReadingStatus.values.firstWhere(
        (e) => e.toString() == 'ReadingStatus.${maps['status']}',
        orElse: () => ReadingStatus.unread,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mangaId': mangaId,
      'title': title,
      'imageUrl': imageUrl,
      'score': score,
      'status': status.toString().split('.').last,
    };
  }

  MangaLibraryModel copyWith({
    int? mangaId,
    String? title,
    String? imageUrl,
    double? score,
    ReadingStatus? status,
  }) {
    return MangaLibraryModel(
      mangaId: mangaId ?? this.mangaId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      score: score ?? this.score,
      status: status ?? this.status,
    );
  }
}
