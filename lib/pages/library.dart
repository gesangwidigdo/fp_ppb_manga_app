import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/library_manga.dart';
import 'package:fp_ppb_manga_app/components/library_manga.dart';
import 'package:fp_ppb_manga_app/models/library_model.dart';
import 'package:fp_ppb_manga_app/services/library_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryPage extends StatefulWidget {
  final bool isOtherUser;
  final String? username;
  final String? userId;

  const LibraryPage({
    super.key,
    this.isOtherUser = false,
    this.username,
    this.userId,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<MangaLibraryModel>> _libraryData;
  final LibraryService _libraryService = LibraryService();

  @override
  void initState() {
    super.initState();
    final userId = widget.isOtherUser ? widget.userId : _libraryService.currentUserId;
    if (userId == null) {
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }
    _libraryData = _libraryService.fetchLibrary(userId);
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
          widget.isOtherUser ? '${widget.username}\'s Library' : 'Library',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xFF202939),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: FutureBuilder<List<MangaLibraryModel>>(
          future: _libraryData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: GoogleFonts.montserrat(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No manga in library',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              );
            }

            final mangas = snapshot.data!;
            return ListView.separated(
              itemCount: mangas.length,
              physics: const ClampingScrollPhysics(),
              separatorBuilder:
                  (context, index) => const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final manga = mangas[index];
                return LibraryManga(
                  manga: manga,
                  updateState:
                      () => setState(() {
                        _libraryData = _libraryService.fetchLibrary(
                          _libraryService.currentUserId!,
                        );
                      }),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
