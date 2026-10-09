import '../../../movies/domain/entities/movie_entity.dart';

abstract class ProfileEvent {}

class LoadUserProfileEvent extends ProfileEvent {}

class UpdateUserDataEvent extends ProfileEvent {
  final String name;
  final String phone;
  final int avatarId;

  UpdateUserDataEvent({
    required this.name,
    required this.phone,
    required this.avatarId,
  });
}

class DeleteAccountEvent extends ProfileEvent {}

class SignOutEvent extends ProfileEvent {}

class ResetPasswordProfileEvent extends ProfileEvent {
  final String email;

  ResetPasswordProfileEvent(this.email);
}

class WishlistUpdatedEvent extends ProfileEvent {
  final List<MovieEntity> wishList;

  WishlistUpdatedEvent(this.wishList);
}

class HistoryUpdatedEvent extends ProfileEvent {
  final List<MovieEntity> history;

  HistoryUpdatedEvent(this.history);
}
