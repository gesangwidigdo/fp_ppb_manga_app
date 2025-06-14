import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_review.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/models/library_model.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/pages/add_to_collection.dart';
import 'package:fp_ppb_manga_app/services/library_service.dart';
import 'package:fp_ppb_manga_app/services/manga_service.dart';
import 'package:google_fonts/google_fonts.dart';

class MangaDetail extends StatefulWidget {
  final int id;

  const MangaDetail({
    super.key,
    required this.id,
  });

  @override
  State<MangaDetail> createState() => _MangaDetailState();
}

class _MangaDetailState extends State<MangaDetail> {
  late Future<MangaDetailModel> _mangaDetailFuture;

  @override
  void initState() {
    super.initState();
    _mangaDetailFuture = MangaService().fetchFullManga(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * 0.5 - 24.0;
    final itemHeight = itemWidth * 1.42;

    return Scaffold(
       appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
          'OtakuLib',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xFF202939),
      body: FutureBuilder<MangaDetailModel>(
        future: _mangaDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final manga = snapshot.data!;
            double starRatingValue = manga.score.floor() / 2;
      
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manga.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            manga.imageUrl, // Use fetched image URL
                            width: itemWidth,
                            height: itemHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: itemWidth,
                              height: itemHeight,
                              color: Colors.grey[800],
                              child: Icon(Icons.broken_image, color: Colors.grey)
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: SizedBox(
                            height: itemHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      manga.titleJap,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0x7FFFFFFF),
                                        height: 20 / 14
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Divider(
                                      color: Color(0xFF354157),
                                      thickness: 1,
                                      height: 28,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Type: ',
                                            style: TextStyle(
                                              color: Color(0x7FFFFFFF),
                                            ),
                                          ),
                                          TextSpan(
                                            text: manga.type,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Published: ',
                                            style: TextStyle(
                                              color: Color(0x7FFFFFFF),
                                            ),
                                          ),
                                          TextSpan(
                                            text: manga.year.toString(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Status: ',
                                            style: TextStyle(
                                              color: Color(0x7FFFFFFF),
                                            ),
                                          ),
                                          TextSpan(
                                            text: manga.status,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Ranked: ',
                                            style: TextStyle(
                                              color: Color(0x7FFFFFFF),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '#${manga.rank}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ...List.generate(5, (index) {
                                          if (starRatingValue >= index + 1) {
                                            return Icon(
                                              Icons.star,
                                              size: 18,
                                              color: Color(0xFFF9D937),
                                            );
                                          } else if (starRatingValue > index) {
                                            return Icon(
                                              Icons.star_half,
                                              size: 18,
                                              color: Color(0xFFF9D937),
                                            );
                                          } else {
                                            return Icon(
                                              Icons.star_border,
                                              size: 18,
                                              color: Color(0xFFF9D937),
                                            );
                                          }
                                        }),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          // Display the original score
                                          manga.score.toString(),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomIconButton(
                                      itemWidth: itemWidth,
                                      icon: Icons.star,
                                      onPressed: () async{
                                        await showAddReviewDialog(
                                          context,
                                          id: manga.id,
                                          title: manga.title,
                                          imageUrl: manga.imageUrl,
                                        ).then((value) {
                                          if (value == true) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              CustomSnackBar(
                                                message: 'Review added successfully!',
                                                isSuccess: true,
                                              )
                                            );
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8.0),
                                    CustomIconButton(
                                      itemWidth: itemWidth,
                                      icon: Icons.local_library,
                                      onPressed: () async {
                                        final libraryService = LibraryService();
                                        final currentUserId = libraryService.currentUserId;
                                        
                                        if (currentUserId == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'You must be logged in to add to library.',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        
                                        final mangaLib = MangaLibraryModel(
                                          id: manga.id,
                                          title: manga.title,
                                          imageUrl: manga.imageUrl,
                                          score: manga.score,
                                        );
                                        
                                        await libraryService.addMangaToLibrary(manga: mangaLib);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          CustomSnackBar(
                                            message: 'Manga added to library successfully!',
                                            isSuccess: true,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8.0),
                                    CustomIconButton(
                                      itemWidth: itemWidth,
                                      icon: Icons.bookmark,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddToCollection(
                                              mangaId: manga.id,
                                              mangaTitle: manga.title,
                                              mangaImageUrl: manga.imageUrl,
                                              mangaChapters: manga.chapters,
                                              mangaScore: manga.score,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Synopsis',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          manga.synopsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ]
                    ),
                    const SizedBox(height: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'More Info',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        CustomInfoDetails(
                          title: 'Authors',
                          value: manga.authors.isNotEmpty ? manga.authors : 'N/A',
                        ),
                        const SizedBox(height: 4.0),
                        CustomInfoDetails(
                          title: 'Genres',
                          value: manga.genres.isNotEmpty ? manga.genres : 'N/A',
                        ),
                        const SizedBox(height: 4.0),
                        CustomInfoDetails(
                          title: 'Themes',
                          value: manga.themes.isNotEmpty ? manga.themes : 'N/A',
                        ),
                        const SizedBox(height: 4.0),
                        CustomInfoDetails(
                          title: 'Demographics',
                          value: manga.demographics.isNotEmpty ? manga.demographics : 'N/A',
                        ),
                      ]
                    ),
                  ],
                )
              ),
            );
          } else {
            return const Center(child: Text('No manga data found.', style: TextStyle(color: Colors.white)));
          }
        }
      )
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final double itemWidth;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.itemWidth,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4.0,
        color: Color(0xFF354157),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, color: Color(0xFF181E2A), size: itemWidth * 0.135 + 4),
        ),
      ),
    );
  }
}

class CustomInfoDetails extends StatelessWidget {
  final String title;
  final String value;

  const CustomInfoDetails({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Text(
            '$title:',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0x7FFFFFFF),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
  
}