import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
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
          'Review',
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
          'Review Page',
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