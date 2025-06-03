import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/profile_menu.dart';
import 'package:fp_ppb_manga_app/pages/collection.dart';
import 'package:fp_ppb_manga_app/pages/library.dart';
import 'package:fp_ppb_manga_app/pages/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    return doc.data();
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, 'login');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202939),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final userData = snapshot.data;
                      final username = userData?['username'] ?? 'Unknown User';
                      final profilePicture = userData?['profilePicture'];
                      final profilePictureUrl =
                          profilePicture != null &&
                                  profilePicture.toString().trim().isNotEmpty
                              ? profilePicture
                              : 'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                Image.network(
                                  profilePictureUrl,
                                  fit: BoxFit.cover,
                                ).image,
                            radius: 35,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            username,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 2, // same as thickness to remove extra padding
              color: Color(0xFF354157),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 48.0,
                vertical: 0,
              ),
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
                    onTap: _signOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
