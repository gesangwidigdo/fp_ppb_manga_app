import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/home_manga.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/services/manga_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<TopMangaModel>> _topMangaFuture;

  @override
  void initState() {
    super.initState();
    _topMangaFuture = MangaService().fetchTopManga();
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * 0.5 - 24.0;
    final imageHeight = itemWidth * 1.42;
    final totalItemHeight = imageHeight + 2 + 16 + 4 + 17;

    return Scaffold(
      backgroundColor: Color(0xFF202939),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            bottom: 32.0,
            left: 8.0,
            right: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Top Manga',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              FutureBuilder<List<TopMangaModel>>(
                future: _topMangaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final mangas = snapshot.data ?? [];
                  if (mangas.isEmpty) {
                    return const Center(
                      child: Text(
                        'No manga found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  
                  return GridView.builder(
                    itemCount: mangas.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: itemWidth / totalItemHeight,
                    ),
                    itemBuilder: (context, index) {
                      final manga = mangas[index];
                      return HomeManga(
                        title: manga.title,
                        imageUrl: manga.imageUrl,
                        chapters: manga.chapters,
                        score: manga.score,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}