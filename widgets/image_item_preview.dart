import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion/config/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageItemPreview extends StatelessWidget {
  const ImageItemPreview({
    super.key,
    this.image,
    this.imageUrl,
    this.onCloseTap,
  }) : assert(image != null || imageUrl != null);
  final File? image;
  final String? imageUrl;
  final VoidCallback? onCloseTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Align(
            alignment: Alignment.center,
            child: image != null
                ? Image.file(
                    image!,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.none,
                    width: double.maxFinite,
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.fill,
                    width: double.maxFinite,
                    progressIndicatorBuilder: (_, url, progress) => Center(
                      child:
                          CircularProgressIndicator(value: progress.progress),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
          ),
          if (onCloseTap != null)
            Padding(
              padding: const EdgeInsets.all(4),
              child: InkWell(
                onTap: onCloseTap,
                child: Icon(Icons.close, color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
