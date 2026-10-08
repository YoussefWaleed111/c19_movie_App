import '../../../movies/domain/entities/movie_entity.dart';
import '../../../movies/domain/repositories/movies_repository.dart';

class SearchMoviesUseCase {
  final MoviesRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call(String query) async {
    return await repository.searchMovies(query);
  }
}
