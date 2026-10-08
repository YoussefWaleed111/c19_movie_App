import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../../movies/presentation/bloc/home_movies_bloc.dart';
import '../../../movies/presentation/bloc/home_movies_event.dart';
import '../../../movies/presentation/bloc/home_movies_state.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: BlocBuilder<HomeMoviesBloc, HomeMoviesState>(
        builder: (context, state) {
          if (state is HomeMoviesLoading || state is HomeMoviesInitial) {
            return SafeArea(child: _buildHomeShimmer());
          }

          if (state is HomeMoviesFailure) {
            return SafeArea(
              child: _buildErrorView(state.errorMessage, context),
            );
          }

          if (state is HomeMoviesSuccess) {
            final featured = state.featuredMovies;
            final action = state.actionMovies;
            if (featured.isEmpty && action.isEmpty) {
              return SafeArea(
                child: _buildErrorView('No movies found at the moment.', context),
              );
            }

            final currentMovie = featured.isNotEmpty
                ? featured[
                    _currentFeaturedIndex.clamp(0, featured.length - 1)]
                : null;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Stack(
                children: [
                  // 1. Dynamic Backdrop with Gradient Overlay
                  if (currentMovie != null)
                    SizedBox(
                      height: 520.h,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _buildBackdropImage(currentMovie),
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

                        // Featured Movies Carousel
                        if (featured.isNotEmpty)
                          CarouselSlider.builder(
                            itemCount: featured.length,
                            options: CarouselOptions(
                              height: 330.h,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.22,
                              viewportFraction: 0.62,
                              enableInfiniteScroll: featured.length > 1,
                              initialPage: 0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentFeaturedIndex = index;
                                });
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              final movie = featured[index];
                              final poster = movie.largeCoverImage.isNotEmpty
                                  ? movie.largeCoverImage
                                  : movie.mediumCoverImage;

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 6.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.55),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: MoviePosterCard(
                                  posterPath: poster,
                                  rating: movie.rating,
                                  width: double.infinity,
                                  height: double.infinity,
                                  onTap: () {},
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
                                onTap: () {},
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

                        // Action Movies Horizontal List
                        if (action.isNotEmpty)
                          SizedBox(
                            height: 200.h,
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: action.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) {
                                final movie = action[index];
                                final poster = movie.mediumCoverImage.isNotEmpty
                                    ? movie.mediumCoverImage
                                    : movie.largeCoverImage;

                                return MoviePosterCard(
                                  posterPath: poster,
                                  rating: movie.rating,
                                  width: 130.w,
                                  height: 195.h,
                                  onTap: () {},
                                );
                              },
                            ),
                          ),

                        SizedBox(height: 110.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBackdropImage(MovieEntity movie) {
    final imagePath = movie.backgroundImage.isNotEmpty
        ? movie.backgroundImage
        : (movie.largeCoverImage.isNotEmpty
            ? movie.largeCoverImage
            : movie.mediumCoverImage);

    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        key: ValueKey<String>('backdrop_${movie.id}'),
        imageUrl: imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorWidget: (_, __, ___) => Container(color: const Color(0xFF121312)),
      );
    }

    return Image.asset(
      imagePath,
      key: ValueKey<String>('backdrop_${movie.id}'),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildHomeShimmer() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF282A28),
        highlightColor: const Color(0xFF383A38),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            children: [
              Container(
                width: 180.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                height: 320.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      height: 260.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      width: 210.w,
                      height: 310.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Container(
                      width: 40.w,
                      height: 260.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: 160.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    Container(
                      width: 60.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                height: 200.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (_, __) => Container(
                    width: 130.w,
                    height: 195.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String message, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 54.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeMoviesBloc>().add(FetchHomeMoviesEvent());
              },
              icon: const Icon(Icons.refresh_rounded, color: Colors.black),
              label: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
