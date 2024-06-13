import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion/core/widgets/custom_button.dart';
import 'package:fashion/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePictureWithTransition extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onEdit;
  final String? imageUrl;
  final ImageProvider? image;
  final double size;
  final double transitionBorderWidth;
  final double? uploadProgress;

  const ProfilePictureWithTransition({
    super.key,
    required this.primaryColor,
    required this.onEdit,
    this.image,
    this.imageUrl,
    this.size = 190.0,
    this.transitionBorderWidth = 20.0,
    this.uploadProgress,
  }) : assert(image != null || imageUrl != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.h,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: size.w,
            height: size.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.05),
            ),
          ),
          Container(
            height: size.h - transitionBorderWidth.h,
            width: size.w - transitionBorderWidth.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                stops: const [0.01, 0.5],
                colors: [Colors.white, primaryColor.withOpacity(0.1)],
              ),
            ),
          ),
          Container(
            height: size.h - (transitionBorderWidth * 2).h,
            width: size.w - (transitionBorderWidth * 2).w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.4),
            ),
          ),
          Container(
            height: size.h - (transitionBorderWidth * 3).h,
            width: size.w - (transitionBorderWidth * 3).w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          uploadProgress != null
              ? CircularProgressIndicator(
                  value: uploadProgress! / 100,
                  color: Colors.white,
                )
              : image == null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: size.h - (transitionBorderWidth * 4).h,
                          width: size.w - (transitionBorderWidth * 4).w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                        );
                      },
                      progressIndicatorBuilder: (_, url, progress) => Center(
                        child:
                            CircularProgressIndicator(value: progress.progress),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Container(
                      height: size.h - (transitionBorderWidth * 4).h,
                      width: size.w - (transitionBorderWidth * 4).w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: image!,
                        ),
                      ),
                    ),
          Positioned(
            top: 30.h,
            right: 20.w,
            child: CustomCircularButtonIcon(
              onPressed: onEdit,
              size: 38.sp,
              child: Assets.icons.pencilSimple.svg(
                height: 38.h,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
