import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/pages/collection.dart';
import 'package:fp_ppb_manga_app/pages/library.dart';
import 'package:fp_ppb_manga_app/pages/review.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202939),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Profile Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CollectionPage(),
                  ),
                );
              },
              child: Text(
                'Collection',
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LibraryPage(),
                  ),
                );
              },
              child: Text(
                'Library',
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReviewPage(),
                  ),
                );
              },
              child: Text(
                'Review',
              ),
            ),
            OutlinedButton(
              onPressed: () {
                debugPrint('Log out button tapped');
              },
              child: Text(
                'Log out',
              ),
            ),
          ],
        ),
      ),
    );
  }
}