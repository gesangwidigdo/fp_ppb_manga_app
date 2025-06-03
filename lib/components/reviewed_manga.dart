import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_review.dart';
import 'package:fp_ppb_manga_app/components/delete_confirmation.dart';
import 'package:fp_ppb_manga_app/services/review_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewedManga extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final double rating;
  final String review;
  final VoidCallback? updateState;

  const ReviewedManga({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.review,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                ]
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0x7FFFFFFF),
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8.0),
              InkWell(
                onTapDown: (TapDownDetails details) async {
                  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                  await showMenu<String>(
                    color: Color(0xFF181E2A),
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: [
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
                          );
                          updateState?.call();
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        )
                      ),
                      PopupMenuItem(
                        onTap: () {
                          final result = showDeleteDialog(
                            context,
                            upperText: 'Delete Review',
                            bottomText: 'Are you sure you want to delete this review?',
                          );
                          result.then((value) async {
                            if (value == true) {
                              await ReviewService().deleteReview(id);
                              updateState?.call();
                            }
                          });
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        )
                      ),
                    ],
                  );
                },
                child: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Color(0xFFB0B0B0), // Light gray color for arrow
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}