// ignore_for_file: avoid_print
import '../../../../core/api/api_service.dart';
import '../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getFeaturedMovies();
  Future<List<MovieModel>> getMoviesByGenre(String genre);
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
}
