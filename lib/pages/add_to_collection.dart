import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/collection_list.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:fp_ppb_manga_app/components/add_collection.dart';
import 'package:google_fonts/google_fonts.dart';

class AddToCollection extends StatefulWidget {
  final int mangaId;
  final String mangaTitle;
  final String? mangaImageUrl;

  const AddToCollection({
    Key? key,
    required this.mangaId,
    required this.mangaTitle,
    this.mangaImageUrl,
  }) : super(key: key);

  @override
  State<AddToCollection> createState() => _AddToCollectionState();
}

class _AddToCollectionState extends State<AddToCollection> {
  late Future<List<CollectionModel>> _collectionsFuture;
  final CollectionService _collectionService = CollectionService();

  @override
  void initState() {
    super.initState();
    _fetchCollections();
  }

  void _fetchCollections() {
    setState(() {
      _collectionsFuture = _collectionService.fetchCollections();
    });
  }

  Future<void> _handleNewCollection() async {
    await showAddCollectionDialog(
      context,
      initialManga: MangaInCollectionModel(
          id: widget.mangaId,
          title: widget.mangaTitle,
          imageUrl: widget.mangaImageUrl),
      mangaTitle: widget.mangaTitle,
      onCollectionCreated: _fetchCollections,
    );
  }

  Future<void> _addMangaToExistingCollection(
      String collectionId, String collectionName) async {
    try {
      final mangaToAdd = MangaInCollectionModel(
          id: widget.mangaId,
          title: widget.mangaTitle,
          imageUrl: widget.mangaImageUrl);
      await _collectionService.addMangaToCollection(collectionId, mangaToAdd);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Manga added to collection "$collectionName"!',
            style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add manga to collection: $e',
            style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202939),
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/left_arrow.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add to collection',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _handleNewCollection,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'New collection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CollectionModel>>(
              future: _collectionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final collections = snapshot.data ?? [];
                if (collections.isEmpty) {
                  return Center(
                    child: Text(
                      'No collections found. Create a new one!',
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    final bool mangaAlreadyInCollection =
                        collection.mangas.any((m) => m.id == widget.mangaId);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      leading:
                          CollectionList(imageUrls: collection.coverImageUrls),
                      title: Text(
                        collection.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                      ),
                      subtitle: Text(
                        '${collection.mangas.length} manga', // Updated
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                      ),
                      trailing: mangaAlreadyInCollection
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () => _addMangaToExistingCollection(
                                  collection.id, collection.name),
                            ),
                      onTap: () {
                        if (!mangaAlreadyInCollection) {
                          _addMangaToExistingCollection(
                              collection.id, collection.name);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Manga already in collection "${collection.name}"!',
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}