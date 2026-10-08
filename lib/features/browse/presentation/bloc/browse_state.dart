import '../../../movies/domain/entities/movie_entity.dart';

abstract class BrowseState {}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {
  final List<String> genres;
  final String selectedGenre;

  BrowseLoading({
    this.genres = const [],
    this.selectedGenre = '',
  });
}

class BrowseSuccess extends BrowseState {
  final List<String> genres;
  final List<MovieEntity> moviesByGenre;
  final String selectedGenre;

  BrowseSuccess({
    required this.genres,
    required this.moviesByGenre,
    required this.selectedGenre,
  });
}

class BrowseFailure extends BrowseState {
  final String errorMessage;
  final List<String> genres;
  final String selectedGenre;

  BrowseFailure(
    this.errorMessage, {
    this.genres = const [],
    this.selectedGenre = '',
  });
}
