import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatarId,
  }) {
    return repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      avatarId: avatarId,
    );
  }
}
