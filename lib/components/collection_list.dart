import 'package:flutter/material.dart';

class CollectionList extends StatelessWidget {
  final List<String>? imageUrls;

  const CollectionList({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrls == null || imageUrls!.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2E3D),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Icon(Icons.photo_library_outlined, color: Colors.white70, size: 30),
      );
    } else if (imageUrls!.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          imageUrls![0],
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 60,
            height: 60,
            color: const Color(0xFF2A2E3D),
            child: const Icon(Icons.broken_image, color: Colors.white70),
          ),
        ),
      );
    } else if (imageUrls!.length > 1 && imageUrls!.length <= 4) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: imageUrls!.length > 1 && imageUrls!.length <= 2 ? 1 : 2,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemCount: imageUrls!.length,
          itemBuilder: (context, index) {
            return Image.network(
              imageUrls![index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF2A2E3D),
                child: const Icon(Icons.broken_image, color: Colors.white70, size: 16),
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemCount: 4, 
          itemBuilder: (context, index) {
            return Image.network(
              imageUrls![index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF2A2E3D),
                child: const Icon(Icons.broken_image, color: Colors.white70, size: 16),
              ),
            );
          },
        ),
      );
    }
  }
}