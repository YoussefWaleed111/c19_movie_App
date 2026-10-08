// ignore_for_file: avoid_print
import '../../../../core/api/api_service.dart';
import '../models/movie_details_model.dart';
import '../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getFeaturedMovies();
  Future<List<MovieModel>> getMoviesByGenre(String genre);
  Future<MovieDetailsModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> getMovieSuggestions(int movieId);
  Future<List<MovieModel>> searchMovies(String query);
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final ApiService apiService;

  MoviesRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<MovieModel>> getFeaturedMovies() async {
    try {
      final response = await apiService.getFeaturedMovies('rating', 10);
      return response.data?.movies ?? [];
    } catch (e) {
      print('❌ [MoviesRemoteDataSource] getFeaturedMovies error: $e');
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre(String genre) async {
    try {
      final response = await apiService.getMoviesByGenre(genre, 15);
      return response.data?.movies ?? [];
    } catch (e) {
      print('❌ [MoviesRemoteDataSource] getMoviesByGenre($genre) error: $e');
      rethrow;
    }
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    try {
      final response = await apiService.getMovieDetails(movieId, true, true);
      final movie = response.data?.movie;
      if (movie == null) {
        throw Exception('Movie details not found for ID $movieId');
      }
      return movie;
    } catch (e) {
      print('❌ [MoviesRemoteDataSource] getMovieDetails($movieId) error: $e');
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    try {
      final response = await apiService.getMovieSuggestions(movieId);
      return response.data?.movies ?? [];
    } catch (e) {
      print('❌ [MoviesRemoteDataSource] getMovieSuggestions($movieId) error: $e');
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await apiService.searchMovies(query);
      return response.data?.movies ?? [];
    } catch (e) {
      print('❌ [MoviesRemoteDataSource] searchMovies("$query") error: $e');
      rethrow;
    }
  }
}
