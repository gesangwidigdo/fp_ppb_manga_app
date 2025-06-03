class CollectionModel {
  final String id;
  final String name;
  final List<dynamic> mangaIds; 
  final String userId; 
  List<String>? coverImageUrls;

  CollectionModel({
    required this.id,
    required this.name,
    this.mangaIds = const [],
    required this.userId, 
    this.coverImageUrls,
  });

  factory CollectionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CollectionModel(
      id: id,
      name: data['name'] as String,
      mangaIds: data['mangaIds'] as List<dynamic>? ?? [],
      userId: data['userId'] as String, 
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'mangaIds': mangaIds,
      'userId': userId, 
    };
  }
}