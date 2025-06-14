import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:fp_ppb_manga_app/components/add_or_edit_collection.dart';
import 'package:google_fonts/google_fonts.dart';

class AddToCollection extends StatefulWidget {
  final int mangaId;
  final String mangaTitle;
  final String mangaImageUrl;
  final int? mangaChapters;
  final double? mangaScore;

  const AddToCollection({
    super.key,
    required this.mangaId,
    required this.mangaTitle,
    required this.mangaImageUrl,
    this.mangaChapters,
    this.mangaScore,
  });

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
    await showAddOrEditCollectionDialog(
      context,
      initialManga: FullMangaModel(
          id: widget.mangaId,
          title: widget.mangaTitle,
          imageUrl: widget.mangaImageUrl,
          chapters: widget.mangaChapters,
          score: widget.mangaScore,
        ),
      mangaTitle: widget.mangaTitle,
    ).then((value) {
      if (value == true) {
        _fetchCollections();
      }
    });
  }

  Future<void> _addMangaToExistingCollection(
      String collectionId, String collectionName) async {
    try {
      final mangaToAdd = FullMangaModel(
          id: widget.mangaId,
          title: widget.mangaTitle,
          imageUrl: widget.mangaImageUrl,
          chapters: widget.mangaChapters,
          score: widget.mangaScore,
        );
      await _collectionService.addMangaToCollection(collectionId, mangaToAdd);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Manga added to collection "$collectionName" successfully!',
          isSuccess: true,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to add manga to collection: $e',
          isSuccess: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202939),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Image.asset(
              'assets/icons/left_arrow.png',
              width: 36,
              height: 36,
            ),
          ),
        ),
        title: Text(
          'Add to Collection',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                      style: GoogleFonts.montserrat(
                          color: Colors.white70,
                      )
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
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: collection.mangas.isNotEmpty ? Image.network(
                          collection.mangas[0].imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ) : Icon(
                          Icons.broken_image,
                          color: Colors.white70,
                          size: 56.0,
                        ),
                      ),
                      title: Text(
                        collection.name,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${collection.mangas.length} manga', // Updated
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      trailing: mangaAlreadyInCollection ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: const Icon(Icons.check_circle, color: Colors.green),
                      ) : IconButton(
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
                            CustomSnackBar(
                              message: 'Manga already in this collection!',
                              isSuccess: false,
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