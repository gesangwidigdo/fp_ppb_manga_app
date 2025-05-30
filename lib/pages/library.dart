import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Image.asset(
              'assets/icons/left_arrow.png',
              width: 36,
              height: 36,
            ),
          ),
        ),
        title: Text(
          'Library',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
      ),
      backgroundColor: Color(0xFF202939),
      body: Center(
        child: Text(
          'Library Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
      ),
    );
  }
}