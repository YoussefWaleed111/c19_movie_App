import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/domain/usecases/get_movies_by_genre_use_case.dart';
import 'browse_event.dart';
import 'browse_state.dart';

const List<String> kDefaultGenres = [
  'Action',
  'Adventure',
  'Animation',
  'Biography',
  'Comedy',
  'Crime',
  'Documentary',
  'Drama',
  'Family',
  'Fantasy',
  'History',
  'Horror',
  'Music',
  'Musical',
  'Mystery',
  'Romance',
  'Sci-Fi',
  'Sport',
  'Thriller',
  'War',
  'Western',
];

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final GetMoviesByGenreUseCase getMoviesByGenreUseCase;
  List<String> _genres = kDefaultGenres;
  String _selectedGenre = 'Action';

  BrowseBloc({required this.getMoviesByGenreUseCase}) : super(BrowseInitial()) {
    on<LoadGenresEvent>(_onLoadGenres);
    on<ChangeGenreEvent>(_onChangeGenre);
  }

  Future<void> _onLoadGenres(
    LoadGenresEvent event,
    Emitter<BrowseState> emit,
  ) async {
    _genres = kDefaultGenres;
    _selectedGenre = _genres.isNotEmpty ? _genres.first : 'Action';
    emit(BrowseLoading(genres: _genres, selectedGenre: _selectedGenre));
    try {
      final movies = await getMoviesByGenreUseCase(_selectedGenre);
      emit(BrowseSuccess(
        genres: _genres,
        moviesByGenre: movies,
        selectedGenre: _selectedGenre,
      ));
    } catch (e) {
      emit(BrowseFailure(
        e.toString().replaceAll('Exception: ', ''),
        genres: _genres,
        selectedGenre: _selectedGenre,
      ));
    }
  }

  Future<void> _onChangeGenre(
    ChangeGenreEvent event,
    Emitter<BrowseState> emit,
  ) async {
    _selectedGenre = event.selectedGenre;
    emit(BrowseLoading(genres: _genres, selectedGenre: _selectedGenre));
    try {
      final movies = await getMoviesByGenreUseCase(_selectedGenre);
      emit(BrowseSuccess(
        genres: _genres,
        moviesByGenre: movies,
        selectedGenre: _selectedGenre,
      ));
    } catch (e) {
      emit(BrowseFailure(
        e.toString().replaceAll('Exception: ', ''),
        genres: _genres,
        selectedGenre: _selectedGenre,
      ));
    }
  }
}
