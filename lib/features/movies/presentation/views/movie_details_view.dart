import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/movie_poster_card.dart';
import '../../data/datasources/favorites_remote_data_source.dart';
import '../../data/datasources/movies_remote_data_source.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/movies_repository_impl.dart';
import '../../domain/usecases/get_movie_details_use_case.dart';
import '../../domain/usecases/get_movie_suggestions_use_case.dart';
import '../bloc/movie_details/movie_details_bloc.dart';
import '../bloc/movie_details/movie_details_event.dart';
import '../bloc/movie_details/movie_details_state.dart';

class MovieDetailsView extends StatelessWidget {
  final int movieId;

  const MovieDetailsView({super.key, required this.movieId});

  static Widget create(int movieId) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://yts.lt/api/v2/',
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: {'Accept': 'application/json'},
      ),
    );
    final apiService = ApiService(dio);
    final moviesRemoteDataSource =
        MoviesRemoteDataSourceImpl(apiService: apiService);
    final moviesRepository =
        MoviesRepositoryImpl(remoteDataSource: moviesRemoteDataSource);
    final favoritesRemoteDataSource = FavoritesRemoteDataSourceImpl();
    final favoritesRepository =
        FavoritesRepositoryImpl(remoteDataSource: favoritesRemoteDataSource);

    return BlocProvider<MovieDetailsBloc>(
      create: (_) => MovieDetailsBloc(
        getMovieDetailsUseCase: GetMovieDetailsUseCase(moviesRepository),
        getMovieSuggestionsUseCase:
            GetMovieSuggestionsUseCase(moviesRepository),
        favoritesRepository: favoritesRepository,
      )..add(FetchMovieDetailsEvent(movieId)),
      child: MovieDetailsView(movieId: movieId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return _buildLoadingShimmer();
          }

          if (state is MovieDetailsFailure) {
            return _buildErrorView(context, state.error);
          }

          if (state is MovieDetailsSuccess) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetailsSuccess state) {
    final movie = state.movie;
    final isFavorite = state.isFavorite;
    final suggestions = state.suggestions;

    final heroImage = movie.backgroundImageOriginal.isNotEmpty
        ? movie.backgroundImageOriginal
        : (movie.largeScreenshot1.isNotEmpty
            ? movie.largeScreenshot1
            : movie.mediumCoverImage);

    final screenshots = [
      movie.largeScreenshot1,
      movie.largeScreenshot2,
      movie.largeScreenshot3,
    ].where((s) => s.isNotEmpty).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero / Header Section
          Stack(
            children: [
              SizedBox(
                height: 480.h,
                width: double.infinity,
                child: heroImage.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: heroImage,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFF282A28),
                        ),
                      )
                    : Image.asset(
                        heroImage,
                        fit: BoxFit.cover,
                      ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.3),
                        const Color(0xFF121312),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Top action buttons (Back & Bookmark)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCircleButton(
                          icon: Icons.arrow_back_ios_new,
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                        _buildCircleButton(
                          icon: isFavorite
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isFavorite ? AppColors.primary : Colors.white,
                          onPressed: () {
                            context
                                .read<MovieDetailsBloc>()
                                .add(ToggleFavoriteEvent(movie));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Big Center Play Icon
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 66.r,
                    height: 66.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.6),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 42.sp,
                    ),
                  ),
                ),
              ),

              // Movie Title & Year at bottom of hero
              Positioned(
                bottom: 12.h,
                left: 16.w,
                right: 16.w,
                child: Column(
                  children: [
                    Text(
                      movie.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (movie.year > 0) ...[
                      SizedBox(height: 6.h),
                      Text(
                        '${movie.year}',
                        style: TextStyle(
                          color: const Color(0xFFB0B0B0),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // 2. Watch Button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<MovieDetailsBloc>().add(AddToHistoryEvent(movie));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${movie.title} added to watch history!'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.play_arrow_rounded, size: 28.sp),
                    label: Text(
                      'Watch',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // 3. Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.favorite_rounded,
                        iconColor: Colors.redAccent,
                        value: '${movie.likeCount}',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.access_time_rounded,
                        iconColor: AppColors.primary,
                        value: '${movie.runtime} min',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.primary,
                        value: movie.rating.toStringAsFixed(1),
                      ),
                    ),
                  ],
                ),

                // 4. Screenshots Section
                if (screenshots.isNotEmpty) ...[
                  SizedBox(height: 28.h),
                  _buildSectionTitle('Screen Shots'),
                  SizedBox(height: 12.h),
                  Column(
                    children: screenshots.map((url) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            height: 180.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              height: 180.h,
                              color: const Color(0xFF282A28),
                            ),
                            errorWidget: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // 5. Similar Movies Section
                if (suggestions.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _buildSectionTitle('Similar'),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 200.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final item = suggestions[index];
                        final poster = item.mediumCoverImage.isNotEmpty
                            ? item.mediumCoverImage
                            : item.largeCoverImage;

                        return MoviePosterCard(
                          posterPath: poster,
                          rating: item.rating,
                          width: 130.w,
                          height: 195.h,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MovieDetailsView.create(item.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],

                // 6. Summary Section
                if (movie.descriptionFull.isNotEmpty) ...[
                  SizedBox(height: 28.h),
                  _buildSectionTitle('Summary'),
                  SizedBox(height: 10.h),
                  Text(
                    movie.descriptionFull,
                    style: TextStyle(
                      color: const Color(0xFFD0D0D0),
                      fontSize: 14.sp,
                      height: 1.6,
                    ),
                  ),
                ],

                // 7. Cast Section
                if (movie.cast.isNotEmpty) ...[
                  SizedBox(height: 28.h),
                  _buildSectionTitle('Cast'),
                  SizedBox(height: 14.h),
                  SizedBox(
                    height: 125.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: movie.cast.length,
                      separatorBuilder: (_, __) => SizedBox(width: 16.w),
                      itemBuilder: (context, index) {
                        final actor = movie.cast[index];
                        return SizedBox(
                          width: 80.w,
                          child: Column(
                            children: [
                              ClipOval(
                                child: actor.urlSmallImage.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: actor.urlSmallImage,
                                        width: 58.r,
                                        height: 58.r,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => Container(
                                          width: 58.r,
                                          height: 58.r,
                                          color: const Color(0xFF282A28),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 58.r,
                                        height: 58.r,
                                        color: const Color(0xFF282A28),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white54,
                                        ),
                                      ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                actor.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (actor.characterName.isNotEmpty) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  actor.characterName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF9E9E9E),
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // 8. Genres Section
                if (movie.genres.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  _buildSectionTitle('Genres'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: movie.genres.map((genre) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF282A28),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          genre,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.6),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20.sp),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFF282A28),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20.sp),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF282A28),
      highlightColor: const Color(0xFF383A38),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 460.h,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Container(
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                color: Colors.redAccent, size: 54.sp),
            SizedBox(height: 16.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<MovieDetailsBloc>()
                    .add(FetchMovieDetailsEvent(movieId));
              },
              icon: const Icon(Icons.refresh_rounded, color: Colors.black),
              label: const Text('Retry',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
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
