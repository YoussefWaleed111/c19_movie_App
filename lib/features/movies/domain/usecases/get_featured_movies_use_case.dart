import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

class GetFeaturedMoviesUseCase {
  final MoviesRepository repository;

  GetFeaturedMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call() {
    return repository.getFeaturedMovies();
  }
}
