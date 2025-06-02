import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/profile_menu.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          Image.network(
                            'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                            fit: BoxFit.cover,
                          ).image,
                      radius: 35,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 2, // same as thickness to remove extra padding
            color: Color(0xFF354157),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 0),
            child: Column(
              children: [
                ProfileMenu(
                  icon: Icons.bookmark,
                  title: 'Collection',
                  description: 'Make your own personal manga collection',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CollectionPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ProfileMenu(
                  icon: Icons.local_library,
                  title: 'Library',
                  description: 'Keep track of your reading progress',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LibraryPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ProfileMenu(
                  title: 'Review',
                  description: 'Rate and review your finished manga',
                  icon: Icons.star,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReviewPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ProfileMenu(
                  title: 'Log out',
                  description: 'Log out of your current profile',
                  icon: Icons.logout,
                  onTap: () {
                    debugPrint('Log out tapped');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
