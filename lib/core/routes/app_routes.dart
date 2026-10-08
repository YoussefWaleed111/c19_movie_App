import 'package:flutter/material.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/onboarding/presentation/views/splash_view.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashView(),
        );
      case onboarding:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingView(),
        );
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginView(),
        );
      case register:
        return _buildPlaceholderRoute('Register Screen', settings);
      case home:
        return _buildPlaceholderRoute('Home Screen', settings);
      default:
        return _buildPlaceholderRoute(
          'No route defined for ${settings.name}',
          settings,
        );
    }
  }

  static MaterialPageRoute _buildPlaceholderRoute(
    String title,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
