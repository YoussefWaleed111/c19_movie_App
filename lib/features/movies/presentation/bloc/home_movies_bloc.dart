import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_featured_movies_use_case.dart';
import '../../domain/usecases/get_movies_by_genre_use_case.dart';
import 'home_movies_event.dart';
import 'home_movies_state.dart';

class HomeMoviesBloc extends Bloc<HomeMoviesEvent, HomeMoviesState> {
  final GetFeaturedMoviesUseCase getFeaturedMoviesUseCase;
  final GetMoviesByGenreUseCase getMoviesByGenreUseCase;

  HomeMoviesBloc({
    required this.getFeaturedMoviesUseCase,
    required this.getMoviesByGenreUseCase,
  }) : super(HomeMoviesInitial()) {
    on<FetchHomeMoviesEvent>(_onFetchHomeMovies);
  }

  Future<void> _onFetchHomeMovies(
    FetchHomeMoviesEvent event,
    Emitter<HomeMoviesState> emit,
  ) async {
    emit(HomeMoviesLoading());
    try {
      final results = await Future.wait([
        getFeaturedMoviesUseCase(),
        getMoviesByGenreUseCase('action'),
      ]);

      emit(
        HomeMoviesSuccess(
          featuredMovies: results[0],
          actionMovies: results[1],
        ),
      );
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(HomeMoviesFailure(message));
    }
  }
}
