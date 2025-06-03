import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/services/review_service.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showAddReviewDialog(
  BuildContext context, {
  required int id,
  required String title,
  required String imageUrl,
  bool isEdit = false,
  int? initialRating,
  String? initialReview,
}) {
  double rating = (isEdit && initialRating != null) ? initialRating.toDouble() : 0;
  final TextEditingController reviewController = TextEditingController(text: (isEdit && initialReview != null) ? initialReview : '');
  final ReviewService reviewService = ReviewService();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            backgroundColor: Color(0xFF202939),
            title: Text(
              isEdit ? 'Edit Rate & Review' : 'Rate & Review',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => setState(() => rating = starIndex.toDouble()),
                        child: Icon(
                          starIndex <= rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFF9D937),
                          size: 28.0,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (i) {
                    final starIndex = i + 6;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => setState(() => rating = starIndex.toDouble()),
                        child: Icon(
                          starIndex <= rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFF9D937),
                          size: 28.0,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                  controller: reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your review…',
                    hintStyle: TextStyle(
                      color: Color(0x7FFFFFFF),
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF2A2E3D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: const Color(0xFF1D4ED7),
                ),
                onPressed: () async {
                  isEdit ? reviewService.updateReview(
                    id: id,
                    title: title,
                    imageUrl: imageUrl,
                    rating: rating.toInt(),
                    review: reviewController.text.trim()
                  ) : reviewService.addReview(
                    id: id,
                    title: title,
                    imageUrl: imageUrl,
                    rating: rating.toInt(),
                    review: reviewController.text.trim(),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  isEdit ? 'Update' : 'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}