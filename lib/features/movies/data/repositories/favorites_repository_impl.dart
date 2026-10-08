import '../../domain/entities/movie_details_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addFavorite(String userId, MovieDetailsEntity movie) {
    return remoteDataSource.addFavorite(userId, movie);
  }

  @override
  Future<void> removeFavorite(String userId, int movieId) {
    return remoteDataSource.removeFavorite(userId, movieId);
  }

  @override
  Future<bool> isFavorite(String userId, int movieId) {
    return remoteDataSource.isFavorite(userId, movieId);
  }
}
