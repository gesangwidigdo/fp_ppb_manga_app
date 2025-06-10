import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/models/library_model.dart';
import 'package:fp_ppb_manga_app/services/library_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<MangaLibraryModel>> _libraryData;
  final LibraryService _libraryService = LibraryService();

  @override
  void initState() {
    super.initState();
    final userId = _libraryService.currentUserId;
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
          'Library',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xFF202939),
      body: FutureBuilder<List<MangaLibraryModel>>(
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
                style: GoogleFonts.montserrat(
                  color: Colors.red,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No manga in library',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                ),
              ),
            );
          }

          final mangas = snapshot.data!;
          return ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      mangas[index].imageUrl ?? '',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mangas[index].title,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFF9D937), // Gold color for star
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${mangas[index].score ?? '-'}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<ReadingStatus>(
                      value: mangas[index].status,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      dropdownColor: Color(0xFF202939),
                      underline: Container(),
                      onChanged: (ReadingStatus? newValue) {
                        if (newValue != null) {
                          setState(() {
                            mangas[index] = mangas[index].copyWith(
                              status: newValue,
                            );
                            _libraryService.updateMangaReadingStatus(
                              mangaId: mangas[index].mangaId,
                              status: newValue,
                            );
                          });
                        }
                      },
                      items:
                          ReadingStatus.values.map((ReadingStatus status) {
                            return DropdownMenuItem<ReadingStatus>(
                              value: status,
                              child: Text(
                                status.toString().split('.').last,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        final mangaToRemove = mangas[index].mangaId;
                        setState(() {
                          mangas.removeAt(index);
                        });
                        _libraryService.removeMangaFromLibrary(
                          mangaId: mangaToRemove,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1, color: Color(0xFF444B5A));
            },
            itemCount: mangas.length,
          );
        },
      ),
    );
  }
}
