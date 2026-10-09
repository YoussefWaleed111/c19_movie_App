import '../../../domain/entities/movie_details_entity.dart';

abstract class MovieDetailsEvent {}

class FetchMovieDetailsEvent extends MovieDetailsEvent {
  final int movieId;

  FetchMovieDetailsEvent(this.movieId);
}

class ToggleFavoriteEvent extends MovieDetailsEvent {
  final MovieDetailsEntity movie;

  ToggleFavoriteEvent(this.movie);
}

class AddToHistoryEvent extends MovieDetailsEvent {
  final MovieDetailsEntity movie;

  AddToHistoryEvent(this.movie);
}
