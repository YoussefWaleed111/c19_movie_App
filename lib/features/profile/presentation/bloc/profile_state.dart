import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final List<MovieEntity> wishList;
  final List<MovieEntity> history;

  ProfileLoaded({
    required this.user,
    required this.wishList,
    required this.history,
  });

  ProfileLoaded copyWith({
    UserEntity? user,
    List<MovieEntity>? wishList,
    List<MovieEntity>? history,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      wishList: wishList ?? this.wishList,
      history: history ?? this.history,
    );
  }
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUnauthenticated extends ProfileState {}
