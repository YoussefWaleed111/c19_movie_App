// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_data_source.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;

  MoviesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MovieEntity>> getFeaturedMovies() async {
    try {
      final models = await remoteDataSource.getFeaturedMovies();
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      print('🔴 [MoviesRepository] DioException in getFeaturedMovies:');
      print('   ➜ URI: ${e.requestOptions.uri}');
      print('   ➜ Type: ${e.type}');
      print('   ➜ Status Code: ${e.response?.statusCode}');
      print('   ➜ Response Body: ${e.response?.data}');
      print('   ➜ Error: ${e.error}');
      print('   ➜ Message: ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🔴 [MoviesRepository] Unexpected error in getFeaturedMovies: $e');
      print('   ➜ StackTrace: $stackTrace');
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<MovieEntity>> getMoviesByGenre(String genre) async {
    try {
      final models = await remoteDataSource.getMoviesByGenre(genre);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      print('🔴 [MoviesRepository] DioException in getMoviesByGenre($genre):');
      print('   ➜ URI: ${e.requestOptions.uri}');
      print('   ➜ Type: ${e.type}');
      print('   ➜ Status Code: ${e.response?.statusCode}');
      print('   ➜ Response Body: ${e.response?.data}');
      print('   ➜ Error: ${e.error}');
      print('   ➜ Message: ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🔴 [MoviesRepository] Unexpected error in getMoviesByGenre($genre): $e');
      print('   ➜ StackTrace: $stackTrace');
      throw Exception(e.toString());
    }
  }

  @override
  Future<MovieDetailsEntity> getMovieDetails(int movieId) async {
    try {
      final model = await remoteDataSource.getMovieDetails(movieId);
      return model.toEntity();
    } on DioException catch (e) {
      print('🔴 [MoviesRepository] DioException in getMovieDetails($movieId):');
      print('   ➜ URI: ${e.requestOptions.uri}');
      print('   ➜ Type: ${e.type}');
      print('   ➜ Status Code: ${e.response?.statusCode}');
      print('   ➜ Response Body: ${e.response?.data}');
      print('   ➜ Error: ${e.error}');
      print('   ➜ Message: ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🔴 [MoviesRepository] Unexpected error in getMovieDetails($movieId): $e');
      print('   ➜ StackTrace: $stackTrace');
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<MovieEntity>> getMovieSuggestions(int movieId) async {
    try {
      final models = await remoteDataSource.getMovieSuggestions(movieId);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      print('🔴 [MoviesRepository] DioException in getMovieSuggestions($movieId):');
      print('   ➜ URI: ${e.requestOptions.uri}');
      print('   ➜ Type: ${e.type}');
      print('   ➜ Status Code: ${e.response?.statusCode}');
      print('   ➜ Response Body: ${e.response?.data}');
      print('   ➜ Error: ${e.error}');
      print('   ➜ Message: ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🔴 [MoviesRepository] Unexpected error in getMovieSuggestions($movieId): $e');
      print('   ➜ StackTrace: $stackTrace');
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    try {
      final models = await remoteDataSource.searchMovies(query);
      return models.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      print('🔴 [MoviesRepository] DioException in searchMovies("$query"):');
      print('   ➜ URI: ${e.requestOptions.uri}');
      print('   ➜ Type: ${e.type}');
      print('   ➜ Status Code: ${e.response?.statusCode}');
      print('   ➜ Response Body: ${e.response?.data}');
      print('   ➜ Error: ${e.error}');
      print('   ➜ Message: ${e.message}');
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      print('🔴 [MoviesRepository] Unexpected error in searchMovies("$query"): $e');
      print('   ➜ StackTrace: $stackTrace');
      throw Exception(e.toString());
    }
  }

  String _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timed out. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection detected or server is unreachable.';
    } else if (e.type == DioExceptionType.badResponse) {
      return 'Server error (${e.response?.statusCode}): ${e.response?.statusMessage ?? ''}';
    }
    return e.message ?? 'An unexpected network error occurred.';
  }
}
