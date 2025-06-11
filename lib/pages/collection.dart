import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_or_edit_collection.dart';
import 'package:fp_ppb_manga_app/components/collection_list.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
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
          'Collection',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: () async {
                await showAddOrEditCollectionDialog(
                  context,
                );
                _fetchCollections();
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
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            itemCount: collections.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24.0),
            itemBuilder: (context, index) {
              return CollectionList(
                collection: collections[index],
                updateState: _fetchCollections,
              );
            },
          );
        },
      ),
    );
  }
}