import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getUserProfile();
  Future<List<MovieEntity>> getWishlist();
  Future<List<MovieEntity>> getHistory();
  Stream<List<MovieEntity>> streamWishlist(String userId);
  Stream<List<MovieEntity>> streamHistory(String userId);
  Future<void> updateUserData({
    required String name,
    required String phone,
    required int avatarId,
  });
  Future<void> deleteAccount();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}
