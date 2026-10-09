import '../repositories/profile_repository.dart';

class UpdateUserDataUseCase {
  final ProfileRepository repository;

  UpdateUserDataUseCase(this.repository);

  Future<void> call({
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    return await repository.updateUserData(
      name: name,
      phone: phone,
      avatarId: avatarId,
    );
  }
}
