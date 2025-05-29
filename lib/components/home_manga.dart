import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeManga extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final int? chapters;
  final double? score;

  const HomeManga({
    super.key,
    required this.title,
    this.imageUrl,
    this.chapters,
    this.score,
  });


  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * 0.5 - 24.0;
    final itemHeight = itemWidth * 1.42;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: itemWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl!,
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
                chapters != null ? 'Chapters: $chapters' : 'No Chapters',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0x7FFFFFFF),
                  fontFamily: GoogleFonts.montserrat().fontFamily,
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
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFFFF),
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}