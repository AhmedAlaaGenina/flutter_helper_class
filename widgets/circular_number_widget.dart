import 'package:fashion/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularNumberWidget extends StatelessWidget {
  const CircularNumberWidget({
    super.key,
    required this.step,
    required this.isSelected,
    required this.onTap,
  });

  final int step;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: AppColors.primary,
        radius: 15.r,
        child: CircleAvatar(
          backgroundColor: isSelected ? AppColors.primary : Colors.white,
          radius: 14.r,
          child: Center(
            child: Text(
              '$step',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
