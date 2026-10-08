import '../../../../core/utils/app_assets.dart';

class MovieModel {
  final String id;
  final String title;
  final String posterPath;
  final double rating;
  final String category;

  const MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.category,
  });
}

abstract class MockMoviesData {
  static const List<MovieModel> featuredMovies = [
    MovieModel(
      id: '1',
      title: 'Oppenheimer',
      posterPath: AppAssets.onboarding3,
      rating: 8.9,
      category: 'Biography',
    ),
    MovieModel(
      id: '2',
      title: 'Doctor Strange',
      posterPath: AppAssets.onboarding5,
      rating: 7.3,
      category: 'Action',
    ),
    MovieModel(
      id: '3',
      title: 'Bad Boys: Ride or Die',
      posterPath: AppAssets.onboarding4,
      rating: 6.7,
      category: 'Action',
    ),
    MovieModel(
      id: '4',
      title: '1917',
      posterPath: AppAssets.onboarding6,
      rating: 8.2,
      category: 'War',
    ),
    MovieModel(
      id: '5',
      title: 'Avengers: Endgame',
      posterPath: AppAssets.onboarding2,
      rating: 8.4,
      category: 'Action',
    ),
  ];

  static const List<MovieModel> actionMovies = [
    MovieModel(
      id: 'a1',
      title: 'Bad Boys: Ride or Die',
      posterPath: AppAssets.onboarding4,
      rating: 6.7,
      category: 'Action',
    ),
    MovieModel(
      id: 'a2',
      title: 'Doctor Strange',
      posterPath: AppAssets.onboarding5,
      rating: 7.3,
      category: 'Action',
    ),
    MovieModel(
      id: 'a3',
      title: 'Avengers: Endgame',
      posterPath: AppAssets.onboarding2,
      rating: 8.4,
      category: 'Action',
    ),
    MovieModel(
      id: 'a4',
      title: '1917',
      posterPath: AppAssets.onboarding6,
      rating: 8.2,
      category: 'Action',
    ),
    MovieModel(
      id: 'a5',
      title: 'Oppenheimer',
      posterPath: AppAssets.onboarding3,
      rating: 8.9,
      category: 'Action',
    ),
  ];
}
