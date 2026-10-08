import '../../../domain/entities/movie_details_entity.dart';
import '../../../domain/entities/movie_entity.dart';

abstract class MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetailsEntity movie;
  final List<MovieEntity> suggestions;
  final bool isFavorite;

  MovieDetailsSuccess({
    required this.movie,
    required this.suggestions,
    required this.isFavorite,
  });

  MovieDetailsSuccess copyWith({
    MovieDetailsEntity? movie,
    List<MovieEntity>? suggestions,
    bool? isFavorite,
  }) {
    return MovieDetailsSuccess(
      movie: movie ?? this.movie,
      suggestions: suggestions ?? this.suggestions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsFailure extends MovieDetailsState {
  final String error;

  MovieDetailsFailure(this.error);
}
