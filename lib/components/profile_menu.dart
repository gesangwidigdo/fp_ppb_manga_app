import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenu extends StatelessWidget {
  final String title;
  final int? titleFontSize;
  final String? description;
  final IconData icon;
  final VoidCallback onTap;
  
  const ProfileMenu({
    super.key,
    required this.title,
    this.titleFontSize = 16,
    this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFF354157),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(icon, color: Color(0xFF181E2A), size: 36),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: titleFontSize!.toDouble(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                description != null ? Text(
                  description!,
                  style: GoogleFonts.montserrat(
                    color: Color(0x7FFFFFFF),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
