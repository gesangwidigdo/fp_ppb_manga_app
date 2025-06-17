import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/profile_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_ppb_manga_app/pages/collection.dart';
import 'package:fp_ppb_manga_app/pages/library.dart';
import 'package:fp_ppb_manga_app/pages/review.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailPage extends StatefulWidget {
  final String id;

  const UserDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late String username;

  Future<Map<String, dynamic>?> _getUserData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.id)
            .get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(  
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<Map<String, dynamic>?>(
                  future: _getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final userData = snapshot.data;
                    username = userData?['username'] ?? 'Unknown User';
                    final profilePicture = userData?['profilePicture'];
                    final profilePictureUrl = profilePicture != null && profilePicture.toString().trim().isNotEmpty ?
                      profilePicture : 'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';
                    return Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              Image.network(
                                profilePictureUrl,
                                fit: BoxFit.cover,
                              ).image,
                          radius: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          username,
                          style: GoogleFonts.montserrat(
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
            Divider(
              color: Color(0xFF354157),
              thickness: 2,
              height: 48,
            ),
            Column(
              children: [
                ProfileMenu(
                  icon: Icons.bookmark,
                  title: 'Collection',
                  titleFontSize: 20,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionPage(
                          isOtherUser: true,
                          userId: widget.id,
                          username: username,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ProfileMenu(
                  icon: Icons.local_library,
                  title: 'Library',
                  titleFontSize: 20,
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LibraryPage(
                          isOtherUser: true,
                          userId: widget.id,
                          username: username,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ProfileMenu(
                  title: 'Review',
                  icon: Icons.star,
                  titleFontSize: 20,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPage(
                          isOtherUser: true,
                          userId: widget.id,
                          username: username,
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
    );
  }
}
