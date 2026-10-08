abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String avatarId;

  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.avatarId,
  });
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent({required this.email});
}

class GoogleLoginEvent extends AuthEvent {}
