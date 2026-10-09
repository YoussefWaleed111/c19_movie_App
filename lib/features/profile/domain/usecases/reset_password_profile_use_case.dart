import '../repositories/profile_repository.dart';

class ResetPasswordProfileUseCase {
  final ProfileRepository repository;

  ResetPasswordProfileUseCase(this.repository);

  Future<void> call(String email) async {
    return await repository.resetPassword(email);
  }
}
