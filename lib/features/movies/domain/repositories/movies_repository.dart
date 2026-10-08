import '../entities/movie_details_entity.dart';
import '../entities/movie_entity.dart';

abstract class MoviesRepository {
  Future<List<MovieEntity>> getFeaturedMovies();
  Future<List<MovieEntity>> getMoviesByGenre(String genre);
  Future<MovieDetailsEntity> getMovieDetails(int movieId);
  Future<List<MovieEntity>> getMovieSuggestions(int movieId);
  Future<List<MovieEntity>> searchMovies(String query);
}
