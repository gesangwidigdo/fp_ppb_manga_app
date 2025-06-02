class CollectionModel {
  final String id; // Firestore document ID
  final String name;
  final List<dynamic> mangaIds; // List of manga IDs in this collection
  final String userId; // Add userId

  CollectionModel({
    required this.id,
    required this.name,
    this.mangaIds = const [],
    required this.userId, // Make userId required
  });

  factory CollectionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CollectionModel(
      id: id,
      name: data['name'] as String,
      mangaIds: data['mangaIds'] as List<dynamic>? ?? [],
      userId: data['userId'] as String, // Get userId from Firestore data
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'mangaIds': mangaIds,
      'userId': userId, // Include userId in data to be saved
    };
  }
}