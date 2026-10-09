import '../entities/movie_details_entity.dart';

abstract class FavoritesRepository {
  Future<void> addFavorite(String userId, MovieDetailsEntity movie);
  Future<void> removeFavorite(String userId, int movieId);
  Future<bool> isFavorite(String userId, int movieId);
  Future<void> addToHistory(String userId, MovieDetailsEntity movie);
}
