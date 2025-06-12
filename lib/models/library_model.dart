import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';

enum ReadingStatus { unread, ongoing, completed }

class MangaLibraryModel extends MangaModel{
  final double? score;
  final ReadingStatus status;

  MangaLibraryModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    this.score,
    this.status = ReadingStatus.unread,
  });

  factory MangaLibraryModel.fromMap(Map<String, dynamic> maps) {
    return MangaLibraryModel(
      id: maps['mangaId'] as int,
      title: maps['title'] as String,
      imageUrl: maps['imageUrl'] as String,
      score: maps['score'] != null ? (maps['score'] as num).toDouble() : null,
      status: ReadingStatus.values.firstWhere(
        (e) => e.toString() == 'ReadingStatus.${maps['status']}',
        orElse: () => ReadingStatus.unread,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mangaId': id,
      'title': title,
      'imageUrl': imageUrl,
      'score': score,
      'status': status.toString().split('.').last,
      'createdAt': FieldValue.serverTimestamp(),
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
      id: mangaId ?? id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      score: score ?? this.score,
      status: status ?? this.status,
    );
  }
}
