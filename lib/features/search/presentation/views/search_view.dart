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
import '../../../movies/presentation/views/movie_details_view.dart';
import '../../domain/usecases/search_movies_use_case.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static SearchBloc createSearchBloc() {
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
    final searchMoviesUseCase = SearchMoviesUseCase(repository);

    return SearchBloc(searchMoviesUseCase: searchMoviesUseCase);
  }

  static Widget create() {
    return BlocProvider<SearchBloc>(
      create: (_) => createSearchBloc(),
      child: const SearchView(),
    );
  }

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF282A28),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  cursorColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {});
                    context.read<SearchBloc>().add(SearchQueryChangedEvent(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                              context.read<SearchBloc>().add(ClearSearchEvent());
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Content
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return _buildLoadingGrid();
                  } else if (state is SearchSuccess) {
                    if (state.movies.isEmpty) {
                      return _buildEmptyState(message: 'No movies found');
                    }
                    return _buildResultsGrid(state.movies);
                  } else if (state is SearchFailure) {
                    return _buildErrorState(state.errorMessage);
                  }
                  // SearchInitial
                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({String? message}) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.emptySearch,
              width: 220.w,
              fit: BoxFit.contain,
            ),
            if (message != null) ...[
              SizedBox(height: 16.h),
              Text(
                message,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 90.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
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

  Widget _buildResultsGrid(List<dynamic> movies) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 90.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
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

  Widget _buildErrorState(String error) {
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
          ],
        ),
      ),
    );
  }
}
