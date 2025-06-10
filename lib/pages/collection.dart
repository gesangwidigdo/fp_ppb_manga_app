import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_or_edit_collection.dart';
import 'package:fp_ppb_manga_app/components/collection_list.dart';
import 'package:fp_ppb_manga_app/components/confirmation.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/pages/collection_detail.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'My Collections',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: () {
                showAddOrEditCollectionDialog(
                  context,
                  onConfirm: _fetchCollections,
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF202939),
      body: FutureBuilder<List<CollectionModel>>(
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
                'You have no collections yet. Create one!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: collections.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.white12,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final collection = collections[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: CollectionList(imageUrls: collection.coverImageUrls),
                title: Text(
                  collection.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                subtitle: Text(
                  '${collection.mangas.length} manga',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      showAddOrEditCollectionDialog(
                        context,
                        onConfirm: _fetchCollections,
                        collectionId: collection.id,
                        currentName: collection.name,
                      );
                    } else if (value == 'delete') {
                      showConfirmationDialog(
                        context,
                        upperText: 'Delete Collection',
                        bottomText: 'Are you sure you want to delete "${collection.name}"?',
                        isDelete: true,
                        confirmText: 'Delete',
                      ).then((confirmed) {
                        if (confirmed == true) {
                          _collectionService.deleteCollection(collection.id).then((_) {
                            _fetchCollections();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Collection "${collection.name}" deleted.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }).catchError((e) {
                             ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete collection: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        }
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit Name'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete Collection'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.white54),
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollectionDetailPage(collection: collection),
                    ),
                  );
                  _fetchCollections();
                },
              );
            },
          );
        },
      ),
    );
  }
}