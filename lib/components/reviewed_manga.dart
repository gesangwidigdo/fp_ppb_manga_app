import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_review.dart';
import 'package:fp_ppb_manga_app/components/confirmation.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/components/show_more.dart';
import 'package:fp_ppb_manga_app/services/review_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewedManga extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final double rating;
  final String review;
  final bool isOtherUser;
  final VoidCallback? updateState;

  const ReviewedManga({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.review,
    this.isOtherUser = false,
    this.updateState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: const Color(0xFFF9D937),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${rating.toInt().toString()} / 10',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ]
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  review,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Color(0x7FFFFFFF),
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8.0),
              isOtherUser ? const SizedBox.shrink() : ShowMore(
                menuItems: [
                  PopupMenuItem(
                    onTap: () async {
                      await showAddReviewDialog(
                        context,
                        id: id,
                        title: title,
                        imageUrl: imageUrl,
                        isEdit: true,
                        initialRating: rating.toInt(),
                        initialReview: review,
                      ).then((value) {
                        if (value == true) {
                          updateState?.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              message: 'Review updated successfully!',
                              isSuccess: true,
                            ),
                          );
                        }
                      });
                    },
                    child: Text(
                      'Edit',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFFFFFFF),
                      ),
                    )
                  ),
                  PopupMenuItem(
                    onTap: () {
                      final result = showConfirmationDialog(
                        context,
                        upperText: 'Delete Review',
                        bottomText: 'Are you sure you want to delete this review?',
                        isDelete: true,
                        confirmText: 'Delete',
                      );
                      result.then((value) async {
                        if (value == true) {
                          await ReviewService().deleteReview(id);
                          updateState?.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              message: 'Review deleted successfully!',
                              isSuccess: true,
                            )
                          );
                        }
                      });
                    },
                    child: Text(
                      'Delete',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFFFFFFF),
                      ),
                    )
                  ),
                ],
              )
            ],
          ),
        ]
      ),
    );
  }
}