import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'rating_badge.dart';

class MoviePosterCard extends StatelessWidget {
  final String posterPath;
  final double rating;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const MoviePosterCard({
    super.key,
    required this.posterPath,
    required this.rating,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = posterPath.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster Image
              isNetworkImage
                  ? CachedNetworkImage(
                      imageUrl: posterPath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF282A28),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF282A28),
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Image.asset(
                      posterPath,
                      fit: BoxFit.cover,
                    ),

              // Rating Badge in top-left
              Positioned(
                top: 8.h,
                left: 8.w,
                child: RatingBadge(rating: rating),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
