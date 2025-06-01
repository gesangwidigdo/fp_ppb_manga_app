import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/reviewed_manga.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/services/manga_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<ReviewedMangaModel>> _reviewedMangaFuture;

  @override
  void initState() {
    super.initState();
    _reviewedMangaFuture = MangaService().fetchReviewedManga();
  }

  Widget _buildReviewList(BuildContext context, AsyncSnapshot<List<ReviewedMangaModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Error: ${snapshot.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    final reviews = snapshot.data ?? [];
    if (reviews.isEmpty) {
      return const Center(
        child: Text(
          'No reviews yet',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final r = reviews[index];
        return ReviewedManga(
          title: r.title,
          imageUrl: r.imageUrl ?? '',
          rating: r.rating.toDouble(),
          review: r.review,
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.white24,
        height: 1.0,
      ),
    );
  }

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
      body: FutureBuilder<List<ReviewedMangaModel>>(
        future: _reviewedMangaFuture,
        builder: _buildReviewList,
      ),
    );
  }
}