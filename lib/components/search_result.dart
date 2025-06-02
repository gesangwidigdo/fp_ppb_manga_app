import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_review.dart';
import 'package:fp_ppb_manga_app/pages/add_to_collection.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResult extends StatelessWidget {
  final int currentIndex;
  final int? id;
  final String name;
  final String? imageUrl;

  const SearchResult({
    required this.currentIndex,
    this.id,
    super.key,
    required this.name,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListTile(
        leading: ClipRRect(
          child: Image.network(
            imageUrl ?? 'https://placehold.co/48x48.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: InkWell(
          onTapDown: (TapDownDetails details) async {
            final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
            await showMenu<String>(
              color: Color(0xFF181E2A),
              context: context,
              position: RelativeRect.fromRect(
                details.globalPosition & const Size(40, 40),
                Offset.zero & overlay.size,
              ),
              items: currentIndex == 0 ? [
                PopupMenuItem(
                  onTap: () {
                    debugPrint('User adds manga $name to library');
                  },
                  child: Text(
                    'Add to Library',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  )
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AddToCollection(
                        mangaId: id!,
                        mangaTitle: name,
                        mangaImageUrl: imageUrl,
                      ),
                    ));
                  },
                  child: Text(
                    'Add to Collection',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  )
                ),
                PopupMenuItem(
                  onTap: () {
                    showAddReviewDialog(
                      context,
                      id: id!,
                      title: name,
                      imageUrl: imageUrl!,
                    );
                  },
                  child: Text(
                    'Review',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  )
                ),
              ] : [],
            );
          },
          child: Icon(
            Icons.more_vert,
            size: 24,
            color: Colors.white, // Light gray color for arrow
          ),
        ),
      ),
    );
  }
}