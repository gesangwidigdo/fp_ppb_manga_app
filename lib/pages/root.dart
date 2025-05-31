import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/pages/home.dart';
import 'package:fp_ppb_manga_app/pages/profile.dart';
import 'package:fp_ppb_manga_app/pages/search.dart';
import 'package:google_fonts/google_fonts.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late FocusNode _searchFocusNode;

  int _currentIndex = 0;
  final _pages = const [
    HomePage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _isSearching) {
        setState(() {
          _isSearching = false;
          _searchController.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: _isSearching ? null : (_currentIndex == 2 ? InkWell(
          onTap: () => setState(() => _currentIndex = 0),
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
        ) : null),
        title: _isSearching ? SizedBox(
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
          ),
        ) : Text(
          'OtakuLib',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        actions: _isSearching ? [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: TextButton(
              onPressed: () => setState(() {
                _isSearching = false;
                _searchController.clear();
              }),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                )
              ),
            ),
          ),
        ] : (_currentIndex != 2  ? [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => SearchPage(currentIndex: _currentIndex,),
              ));
            },
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            child: Padding(
              padding: EdgeInsets.only(right: 24),
              child: Image.asset(
                'assets/icons/search.png',
                width: 36,
                height: 36,
              ),
            ),
          ),
        ]
      : []),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory
        ),
        child: BottomNavigationBar(
          selectedFontSize: 12,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/home.png',
                width: 24.0,
                height: 24.0,
              ),
              activeIcon: Image.asset(
                'assets/icons/home_filled.png',
                width: 24.0,
                height: 24.0,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/search_user.png',
                width: 24.0,
                height: 24.0,
              ),
              activeIcon: Image.asset(
                'assets/icons/search_user_filled.png',
                width: 24.0,
                height: 24.0,
              ),
              label: 'Search User',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/user.png',
                width: 24.0,
                height: 24.0,
              ),
              activeIcon: Image.asset(
                'assets/icons/user_filled.png',
                width: 24.0,
                height: 24.0,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}