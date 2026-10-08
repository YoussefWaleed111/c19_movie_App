abstract class AuthRepository {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatarId,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> resetPassword({
    required String email,
  });

  Future<void> loginWithGoogle();
}
