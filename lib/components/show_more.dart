import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_review.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/models/library_model.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/pages/add_to_collection.dart';
import 'package:fp_ppb_manga_app/services/library_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowMore extends StatelessWidget {
  final List<PopupMenuEntry<String>>? menuItems;
  final FullMangaModel? manga;
  final VoidCallback? onDelete;

  const ShowMore({
    super.key,
    this.menuItems,
    this.manga,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final GlobalKey menuKey = GlobalKey();

        return GestureDetector(
          key: menuKey,
          onTap: () async {
            final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
            final RenderBox? button = menuKey.currentContext?.findRenderObject() as RenderBox?;

            if (button == null) return;

            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(
                  Offset.zero,
                  ancestor: overlay
                ),
                button.localToGlobal(
                  button.size.bottomRight(Offset.zero),
                  ancestor: overlay
                ),
              ),
              Offset.zero & overlay.size,
            );

            await showMenu<String>(
              color: Color(0xFF181E2A),
              context: context,
              position: position,
              items: menuItems ?? [
                PopupMenuItem(
                  onTap: () async {
                    final libraryService = LibraryService();
                    final currentUserId = libraryService.currentUserId;
                    
                    if (currentUserId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You must be logged in to add to library.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    
                    final mangaLib = MangaLibraryModel(
                      id: manga!.id,
                      title: manga!.title,
                      imageUrl: manga!.imageUrl,
                      score: manga!.score,
                    );
                    
                    await libraryService.addMangaToLibrary(manga: mangaLib);
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                        message: 'Manga added to library successfully!',
                        isSuccess: true,
                      ),
                    );
                  },
                  child: Text(
                    'Add to Library',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AddToCollection(
                              mangaId: manga!.id,
                              mangaTitle: manga!.title,
                              mangaImageUrl: manga!.imageUrl,
                              mangaChapters: manga!.chapters,
                              mangaScore: manga!.score,
                            ),
                      ),
                    );
                  },
                  child: Text(
                    'Add to Collection',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    await showAddReviewDialog(
                      context,
                      id: manga!.id,
                      title: manga!.title,
                      imageUrl: manga!.imageUrl,
                    ).then((value) {
                      if (value == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            message: 'Review added successfully!',
                            isSuccess: true,
                          )
                        );
                      }
                    });
                  },
                  child: Text(
                    'Review',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                if (onDelete != null)
                  const PopupMenuDivider(),
                if (onDelete != null)
                  PopupMenuItem(
                    onTap: onDelete,
                    child: Text(
                      'Remove from Collection',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
              ],
            );
          },
          child: Icon(
            Icons.more_vert,
            size: 20,
            color: Color(0xFFB0B0B0), // Light gray color for arrow
          ),
        );
      }
    );
  }
}