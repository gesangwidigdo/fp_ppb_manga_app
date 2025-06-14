import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showAddOrEditCollectionDialog(
  BuildContext context, {
  String? collectionId,
  String? currentName,
  FullMangaModel? initialManga,
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
          style: GoogleFonts.montserrat(
            color: Colors.white
          ),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            style: GoogleFonts.montserrat(
              color: Colors.white
            ),
            decoration: InputDecoration(
              hintText: 'Collection name',
              hintStyle: GoogleFonts.montserrat(
                color: Colors.white70
              ),
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
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                color: Colors.white
              )
            ),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: const Color(0xFF1D4ED7)
                ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final String newName = nameController.text.trim();
                try {
                  if (isEditMode) {
                    await collectionService.updateCollectionName(
                        collectionId, newName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                        message: 'Collection name updated to "$newName"',
                        isSuccess: true,
                      ),
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
                      CustomSnackBar(
                        message: 'Collection "$newName" created successfully',
                        isSuccess: true,
                      ),
                    );
                  }
                  Navigator.pop(context);
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
            style: GoogleFonts.montserrat(
                color: Colors.white,
              )
            ),
          ),
        ],
      );
    },
  );
}