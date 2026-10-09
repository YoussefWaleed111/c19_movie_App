import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../utils/avatar_helper.dart';

class AvatarPickerBottomSheet extends StatefulWidget {
  final int selectedAvatarId;

  const AvatarPickerBottomSheet({
    super.key,
    required this.selectedAvatarId,
  });

  static Future<int?> show(BuildContext context, int currentAvatarId) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AvatarPickerBottomSheet(selectedAvatarId: currentAvatarId),
    );
  }

  @override
  State<AvatarPickerBottomSheet> createState() => _AvatarPickerBottomSheetState();
}

class _AvatarPickerBottomSheetState extends State<AvatarPickerBottomSheet> {
  late int _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedAvatarId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFF282A28),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Pick Your Avatar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(AvatarHelper.avatars.length, (index) {
              final avatarId = index + 1;
              final isSelected = avatarId == _selectedId;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedId = avatarId;
                  });
                  Navigator.pop(context, avatarId);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 3.w,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: const Color(0xFF1E1F1E),
                    backgroundImage: AssetImage(AvatarHelper.avatars[index]),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
