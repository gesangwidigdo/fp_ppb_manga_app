import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/search_result.dart';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:fp_ppb_manga_app/services/manga_service.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final int currentIndex;

  const SearchPage({
    super.key,
    required this.currentIndex,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late FocusNode _searchFocusNode;
  Future<List<MangaModel>>? _searchFuture;
  final MangaService _mangaService = MangaService();

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _searchFuture != null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<MangaModel>>(
      future: _searchFuture,
      builder: (context, snapshot) {
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
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return const Center(
            child: Text(
              'No results found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8.0),
          itemBuilder: (context, i) {
            final res = results[i];
            return widget.currentIndex == 0 ? SearchResult(
              currentIndex: widget.currentIndex,
              id: res.id,
              name: res.title,
              imageUrl: res.imageUrl,
            ) : null ;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
                filled: true,
                fillColor: const Color(0xFF2A2E3D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  setState(() => _searchFuture = _mangaService.searchManga(query));
                }
              },
            ),
          ),
        ),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                )
              ),
            ),
          ),
        ]
      ),
      body: Container(
        color: const Color(0xFF202939),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: _searchFuture == null ? const Center(
          child: Text(
            'Enter a search term',
            style: TextStyle(color: Colors.white70),
          ),
        ) : (widget.currentIndex == 0 ? _buildSearchResults() : Center(
          child: Text(
            'Search results will appear here',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ),
          ),
        ))
      ),
    );
  }
}