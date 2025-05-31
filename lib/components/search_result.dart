import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResult extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const SearchResult({
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
        ),
      ),
    );
  }
}