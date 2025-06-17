import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/components/add_review.dart';
import 'package:fp_ppb_manga_app/components/confirmation.dart';
import 'package:fp_ppb_manga_app/components/custom_snackbar.dart';
import 'package:fp_ppb_manga_app/components/show_more.dart';
import 'package:fp_ppb_manga_app/models/library_model.dart';
import 'package:fp_ppb_manga_app/pages/manga_detail.dart';
import 'package:fp_ppb_manga_app/services/library_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryManga extends StatelessWidget {
  final MangaLibraryModel manga;
  final bool isOtherUser;
  final VoidCallback? updateState;

  const LibraryManga({super.key, required this.manga, this.isOtherUser = false, this.updateState});

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width / 4.9;
    final itemHeight = itemWidth * 1.42;

    var currentStatus =
        manga.status.name[0].toUpperCase() + manga.status.name.substring(1);

    List<String> orderedStatuses = [currentStatus];
    for (ReadingStatus statusValue in ReadingStatus.values) {
      if (statusValue.name != currentStatus.toLowerCase()) {
        orderedStatuses.add(
          statusValue.name[0].toUpperCase() + statusValue.name.substring(1),
        );
      }
    }

    return SizedBox(
      height: itemHeight,
      child: Row(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MangaDetail(id: manga.id),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      manga.imageUrl,
                      width: itemWidth,
                      height: itemHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: itemWidth,
                          height: itemHeight,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        manga.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        alignment: Alignment.center,
                        height: 36,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color:
                              currentStatus == 'Unread'
                                  ? Color(0xFF1E88E5)
                                  : currentStatus == 'Ongoing'
                                  ? Color(0xFFFFC107)
                                  : Color(0xFF4CAF50), // Completed
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: isOtherUser ? Text(
                          currentStatus,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ) : DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentStatus,
                            isDense: true,
                            dropdownColor: Color(0xFF181E2A),
                            borderRadius: BorderRadius.circular(8.0),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            items:
                                orderedStatuses.map((String status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  );
                                }).toList(),
                            onChanged: (String? newSelectedStatus) async {
                              if (newSelectedStatus != null &&
                                  newSelectedStatus != currentStatus) {
                                try {
                                  final libraryService = LibraryService();
                                  await libraryService.updateMangaReadingStatus(
                                    mangaId: manga.id,
                                    status: ReadingStatus.values.firstWhere(
                                      (e) =>
                                          e.name ==
                                          newSelectedStatus.toLowerCase(),
                                      orElse: () => ReadingStatus.unread,
                                    ),
                                  );
                                  updateState
                                      ?.call(); // Call refresh if provided
                                } catch (e) {
                                  // Handle error, e.g., show a SnackBar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to update status: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isOtherUser ? const SizedBox.shrink() : ShowMore(
            menuItems: [
              PopupMenuItem(
                onTap: () async {
                  await showConfirmationDialog(
                    context,
                    upperText: 'Delete Manga',
                    bottomText:
                        'Are you sure you want to delete "${manga.title}"?',
                    isDelete: true,
                    confirmText: 'Delete',
                  ).then((value) async {
                    if (value == true) {
                      final libraryService = LibraryService();
                      await libraryService.removeMangaFromLibrary(
                        mangaId: manga.id,
                      );
                      updateState?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(
                          message: 'Manga deleted successfully!',
                          isSuccess: true,
                        ),
                      );
                    }
                  });
                },
                child: Text(
                  'Delete',
                  style: GoogleFonts.montserrat(color: Color(0xFFFFFFFF)),
                ),
              ),
              manga.status == ReadingStatus.completed
                  ? PopupMenuItem(
                    onTap: () async {
                      showAddReviewDialog(
                        context,
                        id: manga.id,
                        title: manga.title,
                        imageUrl: manga.imageUrl,
                      ).then((value) {
                        if (value == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              message: 'Review added successfully!',
                              isSuccess: true,
                            ),
                          );
                        }
                      });
                    },
                    child: Text(
                      'Review',
                      style: GoogleFonts.montserrat(color: Color(0xFFFFFFFF)),
                    ),
                  )
                  : PopupMenuItem(
                    enabled: false,
                    child: Text(
                      'Review',
                      style: GoogleFonts.montserrat(color: Colors.grey),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
