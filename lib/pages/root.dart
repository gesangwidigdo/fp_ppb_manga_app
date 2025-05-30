import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/pages/home.dart';
import 'package:fp_ppb_manga_app/pages/profile.dart';
import 'package:google_fonts/google_fonts.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  final _pages = const [
    HomePage(),
    HomePage(), // Placeholder for Search User page
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: _currentIndex == 2 ? InkWell(
          onTap: () {
            setState(() {
              _currentIndex = 0;
            });
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
        ) : null,
        title: Text(
          'OtakuLib',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
        ),
        actions: _currentIndex != 2 ? [
          InkWell(
            onTap: () {
              debugPrint('Search icon tapped');
            },
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Image.asset(
                'assets/icons/search.png',
                width: 36,
                height: 36,
              ),
            ),
          ) 
        ] : [],
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