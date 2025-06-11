import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_review.dart';
import 'package:fp_ppb_manga_app/models/library_model.dart';
import 'package:fp_ppb_manga_app/pages/add_to_collection.dart';
import 'package:fp_ppb_manga_app/pages/manga_detail.dart';
import 'package:fp_ppb_manga_app/services/library_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeManga extends StatelessWidget {
  final int id;
  final String title;
  final String? imageUrl;
  final int? chapters;
  final double? score;
  final VoidCallback? onDelete;

  const HomeManga({
    super.key,
    required this.id,
    required this.title,
    this.imageUrl,
    this.chapters,
    this.score,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * 0.5 - 24.0;
    final itemHeight = itemWidth * 1.42;

    return Container(
      margin: const EdgeInsets.all(8.0),
      width: itemWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => MangaDetail(
                  id: id
                ),
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl!,
                width: itemWidth,
                height: itemHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapters != null ? 'Chapters: $chapters' : 'No Chapters',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0x7FFFFFFF),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Color(0xFFF9D937), // Gold color for star
                  ),
                  const SizedBox(width: 2.0),
                  Text(
                    '${score ?? '-'}',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFFFF),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTapDown: (TapDownDetails details) async {
                  final overlay =
                      Overlay.of(context).context.findRenderObject()
                          as RenderBox;
                  await showMenu<String>(
                    color: Color(0xFF181E2A),
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: [
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
    
                          final manga = MangaLibraryModel(
                            mangaId: id,
                            title: title,
                            imageUrl: imageUrl,
                            score: score,
                          );
    
                          await libraryService.addMangaToLibrary(manga: manga);
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
                                    mangaId: id,
                                    mangaTitle: title,
                                    mangaImageUrl: imageUrl,
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
                        onTap: () {
                          showAddReviewDialog(
                            context,
                            id: id,
                            title: title,
                            imageUrl: imageUrl!,
                          );
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
