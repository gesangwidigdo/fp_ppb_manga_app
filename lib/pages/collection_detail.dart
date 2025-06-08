import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/home_manga.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionDetailPage extends StatelessWidget {
  final CollectionModel collection;

  const CollectionDetailPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * 0.5 - 24.0;
    final imageHeight = itemWidth * 1.42;
    final totalItemHeight = imageHeight * 1.2;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Image.asset('assets/icons/left_arrow.png', width: 36, height: 36),
          ),
        ),
        title: Text(
          collection.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF202939),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            bottom: 32.0,
            left: 8.0,
            right: 8.0,
          ),
          child: collection.mangas.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      'This collection is empty.\nAdd manga to this collection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: collection.mangas.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: itemWidth / totalItemHeight,
                  ),
                  itemBuilder: (context, index) {
                    final manga = collection.mangas[index];
                    return HomeManga(
                      id: manga.id,
                      title: manga.title,
                      imageUrl: manga.imageUrl,
                      chapters: null,
                      score: null,
                    );
                  },
                ),
        ),
      ),
    );
  }
}