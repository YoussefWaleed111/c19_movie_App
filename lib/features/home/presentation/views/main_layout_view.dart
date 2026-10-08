import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../movies/data/datasources/movies_remote_data_source.dart';
import '../../../movies/data/repositories/movies_repository_impl.dart';
import '../../../movies/domain/usecases/get_featured_movies_use_case.dart';
import '../../../movies/domain/usecases/get_movies_by_genre_use_case.dart';
import '../../../browse/presentation/bloc/browse_bloc.dart';
import '../../../browse/presentation/views/browse_view.dart';
import '../../../movies/presentation/bloc/home_movies_bloc.dart';
import '../../../movies/presentation/bloc/home_movies_event.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../search/presentation/views/search_view.dart';
import 'home_view.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  static HomeMoviesBloc createHomeMoviesBloc() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://yts.lt/api/v2/',
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: {
          'Accept': 'application/json',
        },
      ),
    )..interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
        ),
      );
    final apiService = ApiService(dio);
    final remoteDataSource =
        MoviesRemoteDataSourceImpl(apiService: apiService);
    final repository =
        MoviesRepositoryImpl(remoteDataSource: remoteDataSource);

    return HomeMoviesBloc(
      getFeaturedMoviesUseCase: GetFeaturedMoviesUseCase(repository),
      getMoviesByGenreUseCase: GetMoviesByGenreUseCase(repository),
    )..add(FetchHomeMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeMoviesBloc>(
          create: (_) => createHomeMoviesBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchView.createSearchBloc(),
        ),
        BlocProvider<BrowseBloc>(
          create: (_) => BrowseView.createBrowseBloc(),
        ),
      ],
      child: const _MainLayoutScaffold(),
    );
  }
}

class _MainLayoutScaffold extends StatefulWidget {
  const _MainLayoutScaffold();

  @override
  State<_MainLayoutScaffold> createState() => _MainLayoutScaffoldState();
}

class _MainLayoutScaffoldState extends State<_MainLayoutScaffold> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    HomeView(),
    SearchView(),
    BrowseView(),
    _PlaceholderView(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF282A28),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                unselectedIcon: Icons.home_outlined,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.search_rounded,
                unselectedIcon: Icons.search_outlined,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.explore_rounded,
                unselectedIcon: Icons.explore_outlined,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_rounded,
                unselectedIcon: Icons.person_outline_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData unselectedIcon,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          isSelected ? icon : unselectedIcon,
          color: isSelected ? AppColors.primary : Colors.white,
          size: 26.sp,
        ),
      ),
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  final String title;

  const _PlaceholderView({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121312),
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(
          '$title Screen Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
