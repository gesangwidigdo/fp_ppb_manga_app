import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewedManga extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  final String review;

  const ReviewedManga({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: const Color(0xFFF9D937),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${rating.toInt().toString()} / 10',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                ]
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  review,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0x7FFFFFFF),
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}