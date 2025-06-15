import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/confirmation.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/components/full_manga.dart';
import 'package:fp_ppb_manga_app/models/collection_model.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/services/collection_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionDetailPage extends StatefulWidget {
  final CollectionModel collection;

  const CollectionDetailPage({super.key, required this.collection});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  final CollectionService _collectionService = CollectionService();
  late List<FullMangaModel> _mangaList;

  @override
  void initState() {
    super.initState();
    _mangaList = List.from(widget.collection.mangas);
  }

  void _removeMangaFromCollection(int mangaId) {
    showConfirmationDialog(
      context,
      upperText: 'Remove Manga',
      bottomText: 'Are you sure you want to remove this manga from the collection?',
      isDelete: true,
      confirmText: 'Remove',
    ).then((confirmed) {
      if (confirmed == true) {
        _collectionService
            .removeMangaFromCollection(widget.collection.id, mangaId)
            .then((_) {
          setState(() {
            _mangaList.removeWhere((manga) => manga.id == mangaId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: 'Manga removed from collection successfully.',
              isSuccess: true,
            ),
          );
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: 'Failed to remove manga from collection: $e',
              isSuccess: false,
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * 0.5 - 24.0;
    final imageHeight = itemWidth * 1.42;
    final totalItemHeight = imageHeight * (MediaQuery.of(context).size.height / 690.9);

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
          widget.collection.name,
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 32.0),
          child: _mangaList.isEmpty
              ? Center(
                  child: Text(
                    'This collection is empty.',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mangaList.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: itemWidth / totalItemHeight,
                  ),
                  itemBuilder: (context, index) {
                    final manga = _mangaList[index];
                    return FullManga(
                      manga: manga,   
                      onDelete: () => _removeMangaFromCollection(manga.id),
                    );
                  },
                ),
        ),
      ),
    );
  }
}