import '../entities/movie_details_entity.dart';
import '../repositories/movies_repository.dart';

class GetMovieDetailsUseCase {
  final MoviesRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<MovieDetailsEntity> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}
