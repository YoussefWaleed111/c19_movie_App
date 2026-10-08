import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

class GetMoviesByGenreUseCase {
  final MoviesRepository repository;

  GetMoviesByGenreUseCase(this.repository);

  Future<List<MovieEntity>> call(String genre) {
    return repository.getMoviesByGenre(genre);
  }
}
