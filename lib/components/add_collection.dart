import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showAddCollectionDialog(
  BuildContext context, {
  MangaInCollectionModel? initialManga,
  String? mangaTitle,
  Function? onCollectionCreated,
}) {
  TextEditingController nameController = TextEditingController();
  final CollectionService _collectionService = CollectionService();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF202939),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'New Collection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        content: TextField(
          controller: nameController,
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
          decoration: InputDecoration(
            hintText: 'Collection name',
            hintStyle: TextStyle(
              color: Colors.white70,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
            filled: true,
            fillColor: const Color(0xFF2A2E3D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF1D4ED7), width: 2.0),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white70,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Collection name cannot be empty!',
                      style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await _collectionService.createCollection(
                  nameController.text.trim(),
                  initialManga: initialManga, // Menggunakan parameter baru
                );

                if (onCollectionCreated != null) {
                  onCollectionCreated();
                }

                // Pop dua kali jika dipanggil dari AddToCollectionPage
                if (initialManga != null) {
                    Navigator.pop(context);
                }
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      initialManga != null
                          ? 'Manga ${mangaTitle ?? 'selected'} added to new collection "${nameController.text.trim()}"!'
                          : 'Collection "${nameController.text.trim()}" created successfully!',
                      style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to create collection: $e',
                      style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED7),
            ),
            child: Text(
              'Create',
              style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
          ),
        ],
      );
    },
  );
}