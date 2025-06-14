import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    required bool isSuccess,
    Icon? icon,
  }) : super(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isSuccess
            ? const Icon(Icons.check_circle_outline, color: Colors.white, size: 24)
            : const Icon(Icons.error_outline, color: Colors.white, size: 24),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: isSuccess ? Color(0xFF1D4ED7) : Color(0xFFE82F2F),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );
}