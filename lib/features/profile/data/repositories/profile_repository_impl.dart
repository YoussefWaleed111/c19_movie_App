import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/domain/entities/movie_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> getUserProfile() async {
    return await remoteDataSource.getUserProfile();
  }

  @override
  Future<List<MovieEntity>> getWishlist() async {
    return await remoteDataSource.getWishlist();
  }

  @override
  Future<List<MovieEntity>> getHistory() async {
    return await remoteDataSource.getHistory();
  }

  @override
  Stream<List<MovieEntity>> streamWishlist(String userId) {
    return remoteDataSource.streamWishlist(userId);
  }

  @override
  Stream<List<MovieEntity>> streamHistory(String userId) {
    return remoteDataSource.streamHistory(userId);
  }

  @override
  Future<void> updateUserData({
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    await remoteDataSource.updateUserData(
      name: name,
      phone: phone,
      avatarId: avatarId,
    );
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await remoteDataSource.resetPassword(email: email);
  }
}
