import '../../domain/entities/movie_entity.dart';

abstract class HomeMoviesState {}

class HomeMoviesInitial extends HomeMoviesState {}

class HomeMoviesLoading extends HomeMoviesState {}

class HomeMoviesSuccess extends HomeMoviesState {
  final List<MovieEntity> featuredMovies;
  final List<MovieEntity> actionMovies;

  HomeMoviesSuccess({
    required this.featuredMovies,
    required this.actionMovies,
  });
}

class HomeMoviesFailure extends HomeMoviesState {
  final String errorMessage;

  HomeMoviesFailure(this.errorMessage);
}
