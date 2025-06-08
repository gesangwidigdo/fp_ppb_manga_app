import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showAddOrEditCollectionDialog(
  BuildContext context, {
  required Function onConfirm,
  String? collectionId,
  String? currentName,
  MangaInCollectionModel? initialManga,
  String? mangaTitle,
}) {
  final bool isEditMode = collectionId != null;
  final TextEditingController nameController =
      TextEditingController(text: currentName ?? '');
  final CollectionService collectionService = CollectionService();
  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF202939),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text(
          isEditMode ? 'Edit Collection Name' : 'New Collection',
          style: TextStyle(
              color: Colors.white, fontFamily: GoogleFonts.montserrat().fontFamily),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            style: TextStyle(
                color: Colors.white, fontFamily: GoogleFonts.montserrat().fontFamily),
            decoration: InputDecoration(
              hintText: 'Collection name',
              hintStyle: TextStyle(
                  color: Colors.white70,
                  fontFamily: GoogleFonts.montserrat().fontFamily),
              filled: true,
              fillColor: const Color(0xFF2A2E3D),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Collection name cannot be empty';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(
                    color: Colors.white70,
                    fontFamily: GoogleFonts.montserrat().fontFamily)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED7)),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final String newName = nameController.text.trim();
                try {
                  if (isEditMode) {
                    await collectionService.updateCollectionName(
                        collectionId!, newName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Collection name updated!'),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    await collectionService.createCollection(
                      newName,
                      initialManga: initialManga,
                    );
                    if (initialManga != null) {
                      Navigator.pop(context);
                    }
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Collection "$newName" created!'),
                          backgroundColor: Colors.green),
                    );
                  }
                  Navigator.pop(context);
                  onConfirm();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Operation failed: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: Text(isEditMode ? 'Save' : 'Create',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat().fontFamily)),
          ),
        ],
      );
    },
  );
}