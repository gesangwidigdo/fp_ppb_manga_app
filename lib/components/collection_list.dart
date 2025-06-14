import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_or_edit_collection.dart';
import 'package:fp_ppb_manga_app/components/confirmation.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/components/show_more.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/pages/collection_detail.dart';
import 'package:fp_ppb_manga_app/pages/manga_detail.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionList extends StatelessWidget {
  final CollectionModel collection;
  final VoidCallback? updateState;

  const CollectionList({
    super.key,
    required this.collection,
    this.updateState,
  });

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width / 4.09;
    final itemHeight = itemWidth * 1.42;
    const int maxDisplayManga = 5;

    List<Widget> mangaWidgets = [];

    if (collection.mangas.isEmpty) {
      mangaWidgets.add(
        Container(
          width: itemWidth,
          height: itemHeight,
          margin: const EdgeInsets.symmetric(horizontal: 6.0),
          decoration: BoxDecoration(
            color: Color(0xFF181E2A),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'This collection is empty',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Color(0xFFD9D9D9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      int count = 0;
      for (var manga in collection.mangas) {
        if (count < maxDisplayManga) {
          mangaWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MangaDetail(id: manga.id), // Ensure MangaDetail takes mangaId
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        manga.imageUrl,
                        width: itemWidth,
                        height: itemHeight,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: itemWidth,
                            height: itemHeight,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(Icons.broken_image, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: itemHeight * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8.0)),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8.0,
                      left: 4.0,
                      right: 4.0,
                      child: Text(
                        manga.title,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        count++;
      }

      if (collection.mangas.length > maxDisplayManga) {
        mangaWidgets.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CollectionDetailPage(collection: collection),
                ),
              ).then((_) => updateState?.call()); // Call updateState if needed after returning
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              width: itemWidth,
              height: itemHeight,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward_ios, color: Color(0xFF181E2A), size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Show All (${collection.mangas.length})',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF181E2A),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  collection.name,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ShowMore(
                menuItems: [
                  PopupMenuItem(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CollectionDetailPage(
                          collection: collection,
                        ),
                      ));
                      updateState?.call();
                    },
                    child: Text(
                      'Show Details',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFFFFFFF),
                      ),
                    )
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      await showAddOrEditCollectionDialog(
                        context,
                        collectionId: collection.id,
                        currentName: collection.name,
                      ).then((value) {
                        value! ? updateState?.call() : null;  
                      });
                    },
                    child: Text(
                      'Edit',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFFFFFFF),
                      ),
                    )
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      await showConfirmationDialog(
                        context,
                        upperText: 'Delete Collection',
                        bottomText: 'Are you sure you want to delete "${collection.name}"?',
                        isDelete: true,
                        confirmText: 'Delete',
                      ).then((value) async {
                        if (value == true) {
                          await CollectionService().deleteCollection(collection.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              message: 'Collection deleted successfully!',
                              isSuccess: true,
                            ),
                          );
                          updateState?.call();
                        }
                      });
                    },
                    child: Text(
                      'Delete',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFFFFFFF),
                      ),
                    )
                  ),
                ],
              ),
            ]
          ),
        ),
        const SizedBox(height: 12.0),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: mangaWidgets
            ),
          ),
        ),
      ],
    );
  }
}