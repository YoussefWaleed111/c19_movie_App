import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import 'home_view.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    HomeView(),
    _PlaceholderView(title: 'Search'),
    _PlaceholderView(title: 'Browse'),
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
