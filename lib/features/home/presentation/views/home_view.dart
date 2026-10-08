import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_assets.dart';
import '../../data/models/mock_movies_data.dart';
import '../widgets/movie_poster_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentFeaturedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final featuredMovies = MockMoviesData.featuredMovies;
    final actionMovies = MockMoviesData.actionMovies;
    final currentMovie = featuredMovies[_currentFeaturedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // 1. Dynamic Top Backdrop with Dark Gradient Overlay
            SizedBox(
              height: 520.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      currentMovie.posterPath,
                      key: ValueKey<String>(currentMovie.id),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.65),
                          const Color(0xFF121312),
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Foreground Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.h),

                  // Available Now Image
                  Image.asset(
                    AppAssets.availableNowText,
                    height: 65.h,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: 14.h),

                  // Featured Movies Carousel (CarouselSlider with enlargeCenterPage)
                  CarouselSlider.builder(
                    itemCount: featuredMovies.length,
                    options: CarouselOptions(
                      height: 330.h,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.22,
                      viewportFraction: 0.62,
                      enableInfiniteScroll: true,
                      initialPage: 0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentFeaturedIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final movie = featuredMovies[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.55),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: MoviePosterCard(
                          posterPath: movie.posterPath,
                          rating: movie.rating,
                          width: double.infinity,
                          height: double.infinity,
                          onTap: () {
                            // Future: Movie Details
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12.h),

                  // Watch Now Image
                  Image.asset(
                    AppAssets.watchNowText,
                    height: 75.h,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: 20.h),

                  // Action Section Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Action',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Future: See More Action Movies
                          },
                          child: Row(
                            children: [
                              Text(
                                'See More',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.primary,
                                size: 12.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // Horizontal Action Movies List
                  SizedBox(
                    height: 200.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: actionMovies.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final movie = actionMovies[index];
                        return MoviePosterCard(
                          posterPath: movie.posterPath,
                          rating: movie.rating,
                          width: 130.w,
                          height: 195.h,
                          onTap: () {
                            // Future: Movie Details
                          },
                        );
                      },
                    ),
                  ),

                  // Bottom padding to clear floating nav bar
                  SizedBox(height: 110.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
