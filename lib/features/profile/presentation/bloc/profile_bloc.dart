import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_account_use_case.dart';
import '../../domain/usecases/get_history_use_case.dart';
import '../../domain/usecases/get_user_profile_use_case.dart';
import '../../domain/usecases/get_wishlist_use_case.dart';
import '../../domain/usecases/reset_password_profile_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../../domain/usecases/stream_history_use_case.dart';
import '../../domain/usecases/stream_wishlist_use_case.dart';
import '../../domain/usecases/update_user_data_use_case.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final GetWishlistUseCase getWishlistUseCase;
  final GetHistoryUseCase getHistoryUseCase;
  final StreamWishlistUseCase streamWishlistUseCase;
  final StreamHistoryUseCase streamHistoryUseCase;
  final UpdateUserDataUseCase updateUserDataUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordProfileUseCase resetPasswordProfileUseCase;

  StreamSubscription? _wishlistSub;
  StreamSubscription? _historySub;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.getWishlistUseCase,
    required this.getHistoryUseCase,
    required this.streamWishlistUseCase,
    required this.streamHistoryUseCase,
    required this.updateUserDataUseCase,
    required this.deleteAccountUseCase,
    required this.signOutUseCase,
    required this.resetPasswordProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<WishlistUpdatedEvent>(_onWishlistUpdated);
    on<HistoryUpdatedEvent>(_onHistoryUpdated);
    on<UpdateUserDataEvent>(_onUpdateUserData);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<SignOutEvent>(_onSignOut);
    on<ResetPasswordProfileEvent>(_onResetPassword);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await getUserProfileUseCase();
      final wishList = await getWishlistUseCase();
      final history = await getHistoryUseCase();
      emit(ProfileLoaded(
        user: user,
        wishList: wishList,
        history: history,
      ));

      // Start continuous real-time streams for favorites and history
      await _wishlistSub?.cancel();
      _wishlistSub = streamWishlistUseCase(user.id).listen(
        (updatedWishlist) => add(WishlistUpdatedEvent(updatedWishlist)),
      );

      await _historySub?.cancel();
      _historySub = streamHistoryUseCase(user.id).listen(
        (updatedHistory) => add(HistoryUpdatedEvent(updatedHistory)),
      );
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onWishlistUpdated(
    WishlistUpdatedEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(wishList: event.wishList));
    }
  }

  void _onHistoryUpdated(
    HistoryUpdatedEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(history: event.history));
    }
  }

  Future<void> _onUpdateUserData(
    UpdateUserDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());
    try {
      await updateUserDataUseCase(
        name: event.name,
        phone: event.phone,
        avatarId: event.avatarId,
      );
      emit(ProfileUpdateSuccess());

      // Refresh loaded user profile
      final user = await getUserProfileUseCase();
      final wishList = await getWishlistUseCase();
      final history = await getHistoryUseCase();
      emit(ProfileLoaded(
        user: user,
        wishList: wishList,
        history: history,
      ));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _wishlistSub?.cancel();
      await _historySub?.cancel();
      await deleteAccountUseCase();
      emit(ProfileUnauthenticated());
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _wishlistSub?.cancel();
      await _historySub?.cancel();
      await signOutUseCase();
      emit(ProfileUnauthenticated());
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await resetPasswordProfileUseCase(event.email);
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    _wishlistSub?.cancel();
    _historySub?.cancel();
    return super.close();
  }
}
