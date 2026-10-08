import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/usecases/search_movies_use_case.dart';
import 'search_event.dart';
import 'search_state.dart';

EventTransformer<Event> _debounceRestartable<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  SearchBloc({required this.searchMoviesUseCase}) : super(SearchInitial()) {
    on<SearchQueryChangedEvent>(
      _onSearchQueryChanged,
      transformer: _debounceRestartable(const Duration(milliseconds: 500)),
    );

    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final movies = await searchMoviesUseCase(query);
      emit(SearchSuccess(movies));
    } catch (e) {
      emit(SearchFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}
