import '../../../../core/utils/app_assets.dart';

class AvatarHelper {
  static const List<String> avatars = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
  ];

  static String getAvatarPath(dynamic avatarId) {
    final id = avatarId.toString();
    if (id.contains('2') || id == '2') {
      return AppAssets.avatar2;
    } else if (id.contains('3') || id == '3') {
      return AppAssets.avatar3;
    }
    return AppAssets.avatar1;
  }

  static int getAvatarId(dynamic avatarId) {
    final id = avatarId.toString();
    if (id.contains('2') || id == '2') return 2;
    if (id.contains('3') || id == '3') return 3;
    return 1;
  }
}
