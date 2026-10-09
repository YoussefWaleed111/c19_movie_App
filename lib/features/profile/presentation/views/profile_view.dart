import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../home/presentation/widgets/movie_poster_card.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../../movies/presentation/views/movie_details_view.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/delete_account_use_case.dart';
import '../../domain/usecases/get_history_use_case.dart';
import '../../domain/usecases/get_user_profile_use_case.dart';
import '../../domain/usecases/get_wishlist_use_case.dart';
import '../../domain/usecases/reset_password_profile_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../../domain/usecases/stream_history_use_case.dart';
import '../../domain/usecases/stream_wishlist_use_case.dart';
import '../../domain/usecases/update_user_data_use_case.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../utils/avatar_helper.dart';
import 'update_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  static ProfileBloc createProfileBloc() {
    final remoteDataSource = ProfileRemoteDataSourceImpl();
    final repository =
        ProfileRepositoryImpl(remoteDataSource: remoteDataSource);

    return ProfileBloc(
      getUserProfileUseCase: GetUserProfileUseCase(repository),
      getWishlistUseCase: GetWishlistUseCase(repository),
      getHistoryUseCase: GetHistoryUseCase(repository),
      streamWishlistUseCase: StreamWishlistUseCase(repository),
      streamHistoryUseCase: StreamHistoryUseCase(repository),
      updateUserDataUseCase: UpdateUserDataUseCase(repository),
      deleteAccountUseCase: DeleteAccountUseCase(repository),
      signOutUseCase: SignOutUseCase(repository),
      resetPasswordProfileUseCase: ResetPasswordProfileUseCase(repository),
    )..add(LoadUserProfileEvent());
  }

  static Widget create() {
    return BlocProvider<ProfileBloc>(
      create: (_) => createProfileBloc(),
      child: const ProfileView(),
    );
  }

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSignOutPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF282A28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Exit App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE82626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<ProfileBloc>().add(SignOutEvent());
            },
            child: Text('Exit', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF121312),
          body: SafeArea(
            child: state is ProfileLoading || state is ProfileInitial
                ? _buildLoadingState()
                : state is ProfileLoaded
                    ? _buildLoadedState(context, state)
                    : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Shimmer.fromColors(
            baseColor: const Color(0xFF282A28),
            highlightColor: const Color(0xFF3A3D3A),
            child: Row(
              children: [
                CircleAvatar(radius: 36.r, backgroundColor: Colors.white),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 16.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 80.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          _buildShimmerGrid(),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, ProfileLoaded state) {
    final user = state.user;
    final wishList = state.wishList;
    final history = state.history;

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  // Header: Avatar, Name, and Counters
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 38.r,
                        backgroundColor: const Color(0xFF282A28),
                        backgroundImage: AssetImage(
                          AvatarHelper.getAvatarPath(user.avatarId),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Name & Email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name.isNotEmpty ? user.name : 'Movie Fan',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Counters
                      Row(
                        children: [
                          _buildCounter(
                            count: wishList.length,
                            label: 'Wish List',
                          ),
                          SizedBox(width: 16.w),
                          _buildCounter(
                            count: history.length,
                            label: 'History',
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Action Buttons: Edit Profile & Exit
                  Row(
                    children: [
                      // Edit Profile Button
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 44.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              final profileBloc = context.read<ProfileBloc>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: profileBloc,
                                    child: UpdateProfileView(user: user),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Exit Button
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 44.h,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE82626),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => _onSignOutPressed(context),
                            icon: Icon(
                              Icons.exit_to_app_rounded,
                              size: 18.sp,
                            ),
                            label: Text(
                              'Exit',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          // Custom TabBar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3.h,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.bookmark_rounded),
                    text: 'Watch List',
                  ),
                  Tab(
                    icon: Icon(Icons.folder_open_rounded),
                    text: 'History',
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMoviesTab(context, wishList),
          _buildMoviesTab(context, history),
        ],
      ),
    );
  }

  Widget _buildCounter({required int count, required String label}) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMoviesTab(BuildContext context, List<MovieEntity> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.emptySearch,
              width: 180.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 12.h),
            Text(
              'No movies added yet',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 14.h,
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 14.h,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF282A28),
          highlightColor: const Color(0xFF3A3D3A),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF282A28),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color(0xFF121312),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
