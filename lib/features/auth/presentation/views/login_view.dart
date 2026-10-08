import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_assets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isEnglish = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Logo
              SizedBox(height: 12.h),
              Image.asset(
                AppAssets.logo,
                height: 120.h,
                fit: BoxFit.contain,
              ),

              // 2. Vertical space 32.h
              SizedBox(height: 32.h),

              // 3. Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF282A28),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: const Color(0xFFB0B0B0),
                    fontSize: 14.sp,
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),

              // 4. Vertical space 16.h
              SizedBox(height: 16.h),

              // 5. Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF282A28),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: const Color(0xFFB0B0B0),
                    fontSize: 14.sp,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),

              // 6. Vertical space 12.h
              SizedBox(height: 12.h),

              // 7. Forget Password Link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Forget Password
                  },
                  child: Text(
                    'Forget Password ?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // 8. Vertical space 24.h
              SizedBox(height: 24.h),

              // 9. Login Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Trigger Login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 10. Vertical space 16.h
              SizedBox(height: 16.h),

              // 11. Create Account Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t Have Account ? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text(
                      'Create One',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // 12. Vertical space 20.h
              SizedBox(height: 20.h),

              // 13. Divider with 'OR'
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: AppColors.primary,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: AppColors.primary,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              // 14. Vertical space 20.h
              SizedBox(height: 20.h),

              // 15. Login With Google Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Trigger Google Login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'G',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Login With Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 16. Vertical space 24.h
              SizedBox(height: 24.h),

              // 17. Language Switch Capsule
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEnglish = !_isEnglish;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _isEnglish
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '🇺🇸',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: !_isEnglish
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '🇪🇬',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
