import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/show_more.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/pages/manga_detail.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResult extends StatelessWidget {
  final int currentIndex;
  final FullMangaModel manga;

  const SearchResult({
    super.key,
    required this.currentIndex,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => MangaDetail(
                  id: manga.id
                ),
              ));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.network(
                    manga.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    manga.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            )
          ),
        ),
        ShowMore(
          manga: manga,
        )
      ]
      ),
    );
  }
}