import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../home/presentation/widgets/movie_poster_card.dart';
import '../../../movies/data/datasources/movies_remote_data_source.dart';
import '../../../movies/data/repositories/movies_repository_impl.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../../movies/domain/usecases/get_movies_by_genre_use_case.dart';
import '../../../movies/presentation/views/movie_details_view.dart';
import '../bloc/browse_bloc.dart';
import '../bloc/browse_event.dart';
import '../bloc/browse_state.dart';

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  static BrowseBloc createBrowseBloc() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://yts.lt/api/v2/',
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    final apiService = ApiService(dio);
    final remoteDataSource =
        MoviesRemoteDataSourceImpl(apiService: apiService);
    final repository =
        MoviesRepositoryImpl(remoteDataSource: remoteDataSource);
    final getMoviesByGenreUseCase = GetMoviesByGenreUseCase(repository);

    return BrowseBloc(getMoviesByGenreUseCase: getMoviesByGenreUseCase)
      ..add(LoadGenresEvent());
  }

  static Widget create() {
    return BlocProvider<BrowseBloc>(
      create: (_) => createBrowseBloc(),
      child: const BrowseView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SafeArea(
        child: BlocBuilder<BrowseBloc, BrowseState>(
          builder: (context, state) {
            List<String> genres = kDefaultGenres;
            String selectedGenre = 'Action';

            if (state is BrowseLoading) {
              genres = state.genres.isNotEmpty ? state.genres : kDefaultGenres;
              selectedGenre = state.selectedGenre.isNotEmpty
                  ? state.selectedGenre
                  : 'Action';
            } else if (state is BrowseSuccess) {
              genres = state.genres;
              selectedGenre = state.selectedGenre;
            } else if (state is BrowseFailure) {
              genres = state.genres.isNotEmpty ? state.genres : kDefaultGenres;
              selectedGenre = state.selectedGenre.isNotEmpty
                  ? state.selectedGenre
                  : 'Action';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                // Genres Chips Bar
                _buildGenresBar(context, genres, selectedGenre),
                SizedBox(height: 12.h),
                // Content Body
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenresBar(
    BuildContext context,
    List<String> genres,
    String selectedGenre,
  ) {
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: genres.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = genre.toLowerCase() == selectedGenre.toLowerCase();

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                context.read<BrowseBloc>().add(ChangeGenreEvent(genre));
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  color: isSelected ? Colors.black : AppColors.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, BrowseState state) {
    if (state is BrowseLoading || state is BrowseInitial) {
      return _buildShimmerGrid();
    } else if (state is BrowseSuccess) {
      if (state.moviesByGenre.isEmpty) {
        return _buildEmptyState();
      }
      return _buildMoviesGrid(context, state.moviesByGenre);
    } else if (state is BrowseFailure) {
      return _buildErrorState(context, state.errorMessage, state.selectedGenre);
    }
    return _buildShimmerGrid();
  }

  Widget _buildMoviesGrid(BuildContext context, List<MovieEntity> movies) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 90.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MoviePosterCard(
          posterPath: movie.mediumCoverImage,
          rating: movie.rating,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailsView.create(movie.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 90.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF282A28),
          highlightColor: const Color(0xFF3A3D3A),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF282A28),
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.emptySearch,
            width: 220.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),
          Text(
            'No movies found in this genre',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, String genre) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 48.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                context.read<BrowseBloc>().add(ChangeGenreEvent(genre));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
