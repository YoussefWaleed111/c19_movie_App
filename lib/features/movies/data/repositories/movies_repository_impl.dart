// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
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
