import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie_details_entity.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/repositories/favorites_repository.dart';
import '../../../domain/usecases/get_movie_details_use_case.dart';
import '../../../domain/usecases/get_movie_suggestions_use_case.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;
  final GetMovieSuggestionsUseCase getMovieSuggestionsUseCase;
  final FavoritesRepository favoritesRepository;

  MovieDetailsBloc({
    required this.getMovieDetailsUseCase,
    required this.getMovieSuggestionsUseCase,
    required this.favoritesRepository,
  }) : super(MovieDetailsLoading()) {
    on<FetchMovieDetailsEvent>(_onFetchMovieDetails);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<AddToHistoryEvent>(_onAddToHistory);
  }

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

  Future<void> _onFetchMovieDetails(
    FetchMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());
    try {
      final results = await Future.wait([
        getMovieDetailsUseCase(event.movieId),
        getMovieSuggestionsUseCase(event.movieId),
        favoritesRepository.isFavorite(_currentUserId, event.movieId),
      ]);

      emit(
        MovieDetailsSuccess(
          movie: results[0] as MovieDetailsEntity,
          suggestions: results[1] as List<MovieEntity>,
          isFavorite: results[2] as bool,
        ),
      );
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(MovieDetailsFailure(message));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (state is MovieDetailsSuccess) {
      final currentState = state as MovieDetailsSuccess;
      final newStatus = !currentState.isFavorite;

      // Optimistically update UI
      emit(currentState.copyWith(isFavorite: newStatus));

      try {
        if (newStatus) {
          await favoritesRepository.addFavorite(_currentUserId, event.movie);
        } else {
          await favoritesRepository.removeFavorite(_currentUserId, event.movie.id);
        }
      } catch (e) {
        // Revert on error
        emit(currentState.copyWith(isFavorite: !newStatus));
      }
    }
  }

  Future<void> _onAddToHistory(
    AddToHistoryEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    try {
      await favoritesRepository.addToHistory(_currentUserId, event.movie);
    } catch (_) {}
  }
}
