import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/movie_details_entity.dart';

abstract class FavoritesRemoteDataSource {
  Future<void> addFavorite(String userId, MovieDetailsEntity movie);
  Future<void> removeFavorite(String userId, int movieId);
  Future<bool> isFavorite(String userId, int movieId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore;

  FavoritesRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addFavorite(String userId, MovieDetailsEntity movie) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(movie.id.toString())
        .set({
      'id': movie.id,
      'title': movie.title,
      'year': movie.year,
      'rating': movie.rating,
      'mediumCoverImage': movie.mediumCoverImage,
      'backgroundImage': movie.backgroundImageOriginal,
      'genres': movie.genres,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite(String userId, int movieId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(movieId.toString())
        .delete();
  }

  @override
  Future<bool> isFavorite(String userId, int movieId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(movieId.toString())
        .get();
    return doc.exists;
  }
}
