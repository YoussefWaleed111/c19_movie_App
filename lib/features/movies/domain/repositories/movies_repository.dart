import '../entities/movie_entity.dart';

abstract class MoviesRepository {
  Future<List<MovieEntity>> getFeaturedMovies();
  Future<List<MovieEntity>> getMoviesByGenre(String genre);
}
