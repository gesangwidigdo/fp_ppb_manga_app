import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/show_more.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/pages/manga_detail.dart';
import 'package:google_fonts/google_fonts.dart';

class FullManga extends StatelessWidget {
  final FullMangaModel manga;
  final VoidCallback? onDelete;

  const FullManga({
    super.key,
    required this.manga,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * 0.5 - 24.0;
    final itemHeight = itemWidth * 1.42;

    return Container(
      margin: const EdgeInsets.all(8.0),
      width: itemWidth,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MangaDetail(
              id: manga.id
            ),
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                manga.imageUrl,
                width: itemWidth,
                height: itemHeight,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manga.chapters != null ? 'Chapters: ${manga.chapters}' : 'No Chapters',
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
                      '${manga.score ?? '-'}',
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
                    manga.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFFFFFF),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ShowMore(
                  manga: manga,
                  onDelete: onDelete,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
