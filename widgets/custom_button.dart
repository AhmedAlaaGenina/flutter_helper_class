import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_developer_test/config/theme/theme.dart';
import 'package:mobile_developer_test/core/widgets/widgets.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    this.elevation,
    this.color,
    this.margin,
    this.border,
    this.colorGradient,
    this.haveShadow,
    this.enableDisabledBackgroundColor,
    this.colorShadow,
    this.shadowRadius,
    this.fitHeight = false,
    this.loading = false,
  });

  final BorderRadiusGeometry? borderRadius;
  final Widget child;
  final double? height;
  final VoidCallback? onPressed;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final double? elevation;
  final Color? color;
  final Color? colorShadow;
  final Gradient? colorGradient;
  final BoxBorder? border;
  final bool? enableDisabledBackgroundColor;
  final bool? haveShadow;
  final bool fitHeight;
  final double? shadowRadius;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.zero;
    final colorShadow = this.colorShadow ?? AppColors.shadowColor;
    final haveShadow = this.haveShadow ?? false;
    final enableDisabledBackgroundColor =
        this.enableDisabledBackgroundColor ?? false;
    final height = fitHeight ? null : (this.height ?? 44.h);
    return ShadowWidget(
      offset: Offset.zero,
      sigma: 3.5,
      color: !haveShadow ? Colors.transparent : colorShadow,
      radius: shadowRadius ?? 32.r,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          gradient: colorGradient,
          borderRadius: borderRadius,
          border: border,
        ),
        child: ElevatedButton(
          onPressed: onPressed != null
              ? () async {
                  FocusScope.of(context).unfocus();
                  await HapticFeedback.heavyImpact();
                  if (onPressed != null) onPressed!();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor:
                enableDisabledBackgroundColor ? color : null,
            padding: padding,
            alignment: alignment,
            elevation: elevation ?? (haveShadow ? 0.1 : null),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            // shadowColor: haveShadow ? colorShadow : null,
          ),
          child: loading
              ? Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}

class CustomButtonText extends StatelessWidget {
  const CustomButtonText({
    super.key,
    required this.title,
    this.onPressed,
    this.color,
    this.width,
    this.textColor,
    this.radius,
    this.shadowRadius,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.haveShadow,
    this.enableDisabledBackgroundColor,
    this.elevation,
    this.margin,
    this.colorShadow,
    this.padding,
    this.inverseColor = false,
    this.border,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.haveFullWidth = true,
    this.loading = false,
    this.fitHeight = false,
    this.isExpandText = false,
  });

  final String title;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? colorShadow;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? radius;
  final double? shadowRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? haveShadow;
  final bool? enableDisabledBackgroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool inverseColor;
  final BoxBorder? border;
  final MainAxisAlignment mainAxisAlignment;
  final bool haveFullWidth;
  final bool loading;
  final bool fitHeight;
  final bool isExpandText;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      loading: loading,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 6.r)),
      width: width,
      height: height,
      fitHeight: fitHeight,
      color: color ?? (inverseColor ? Colors.white : AppColors.primary),
      colorShadow: colorShadow,
      haveShadow: haveShadow,
      elevation: elevation,
      padding: padding,
      margin: margin,
      border: border,
      shadowRadius: shadowRadius,
      enableDisabledBackgroundColor: enableDisabledBackgroundColor,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: haveFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          isExpandText
              ? Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: textColor ??
                              (inverseColor ? AppColors.primary : Colors.white),
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                        ),
                  ),
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: textColor ??
                            (inverseColor ? AppColors.primary : Colors.white),
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                ),
        ],
      ),
    );
  }
}

class CustomButtonIcon extends StatelessWidget {
  const CustomButtonIcon({
    super.key,
    required this.icon,
    this.color,
    this.iconColor,
    this.shadowColor,
    this.radius,
    this.onPressed,
    this.padding,
    this.elevation,
    this.iconSize,
    this.margin,
  });

  final Color? color;
  final IconData icon;
  final Color? iconColor;
  final Color? shadowColor;
  final double? radius;
  final double? elevation;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: elevation,
        shadowColor: shadowColor,
        color: color,
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(6),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.primary,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class CustomCircularButtonIcon extends StatelessWidget {
  const CustomCircularButtonIcon({
    super.key,
    required this.child,
    this.color,
    this.onPressed,
    this.padding,
    this.elevation,
    this.size,
  });

  final Widget child;
  final Color? color;
  final double? elevation;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: null,
          onPressed: onPressed,
          elevation: elevation,
          backgroundColor: color ?? Colors.white,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomButtonSvgLogo extends StatelessWidget {
  const CustomButtonSvgLogo({
    super.key,
    required this.logo,
    this.color,
    this.radius,
    this.onPressed,
    this.padding,
    this.margin,
    this.elevation,
    this.iconSize,
    this.logoColor,
    this.colorBlendMode = BlendMode.srcIn,
  });

  final Color? color;
  final double? radius;
  final double? elevation;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed;
  final String logo;
  final Color? logoColor;
  final BlendMode colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: margin,
        elevation: elevation ?? 0,
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(6),
          child: SvgPicture.asset(
            logo,
            height: iconSize?.h,
            width: iconSize?.w,
            colorFilter: logoColor != null
                ? ColorFilter.mode(logoColor!, colorBlendMode)
                : null,
          ),
        ),
      ),
    );
  }
}

class CustomButtonTextIcon extends StatelessWidget {
  const CustomButtonTextIcon({
    super.key,
    required this.title,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.haveFullWidth = true,
    this.border,
    this.iconColor,
    this.titleColor,
    this.padding,
    this.margin,
    this.elevation,
    this.height,
    this.width,
    this.iconSize,
    this.radius,
    this.haveShadow,
    this.colorShadow,
    this.circularIconRadius,
    this.circularIconColor,
    this.isIconInEnd = false,
    this.haveCircularIcon = false,
    this.fontSize,
    this.fontWeight,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.logo,
    this.colorBlendMode = BlendMode.srcIn,
    this.enableDisabledBackgroundColor,
    this.inverseColor = false,
  });

  final String title;
  final Color? backgroundColor;
  final BoxBorder? border;
  final Color? iconColor;
  final Color? titleColor;
  final IconData? icon;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final double? height;
  final double? width;
  final double? iconSize;
  final double? radius;
  final double? circularIconRadius;
  final Color? circularIconColor;
  final bool? haveShadow;
  final Color? colorShadow;
  final bool isIconInEnd;
  final bool haveCircularIcon;
  final bool haveFullWidth;
  final double? fontSize;
  final FontWeight? fontWeight;
  final MainAxisAlignment mainAxisAlignment;
  final String? logo;
  final BlendMode colorBlendMode;
  final bool? enableDisabledBackgroundColor;
  final bool inverseColor;

  @override
  Widget build(BuildContext context) {
    final haveShadow = this.haveShadow ?? false;
    final radius = this.radius ?? 6.r;

    final colorShadow = this.colorShadow ?? AppColors.shadowColor;
    return ShadowWidget(
      offset: Offset.zero,
      sigma: 3.5,
      color: !haveShadow ? Colors.transparent : colorShadow,
      radius: radius,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        child: Directionality(
          textDirection: isIconInEnd ? TextDirection.rtl : TextDirection.ltr,
          child: CustomButton(
            onPressed: onPressed,
            enableDisabledBackgroundColor: enableDisabledBackgroundColor,
            haveShadow: haveShadow,
            border: border,
            padding: padding,
            elevation: elevation,
            height: height ?? 44.0,
            width: width,
            color: backgroundColor ??
                (inverseColor ? Colors.white : AppColors.primary),
            borderRadius: BorderRadius.circular(radius),
            child: Row(
              mainAxisSize: haveFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment,
              children: [
                if (logo != null)
                  SvgPicture.asset(
                    logo!,
                    colorFilter: iconColor != null
                        ? ColorFilter.mode(iconColor!, colorBlendMode)
                        : null,
                    width: iconSize,
                    height: iconSize,
                  ),
                if (icon != null)
                  haveCircularIcon
                      ? Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circularIconColor,
                          ),
                          child: Icon(
                            icon,
                            size: iconSize,
                            color: iconColor ?? AppColors.primary,
                          ),
                        )
                      : Icon(
                          icon,
                          color: iconColor ??
                              (inverseColor ? AppColors.primary : Colors.white),
                          size: iconSize,
                        ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: titleColor ??
                            (inverseColor ? AppColors.primary : Colors.white),
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavouriteButtonSizeColorAnimation extends StatefulWidget {
  const FavouriteButtonSizeColorAnimation({
    super.key,
    required this.isFavourite,
    required this.onTap,
    this.changeUi = true,
    this.iconSize,
    this.size,
    this.activeColor = Colors.red,
    this.inactiveColor,
    this.duration = const Duration(milliseconds: 500),
  });

  final bool isFavourite;
  final bool changeUi;
  final VoidCallback onTap;
  final double? iconSize;
  final double? size;
  final Color activeColor;
  final Color? inactiveColor;
  final Duration duration;

  @override
  State<FavouriteButtonSizeColorAnimation> createState() =>
      _FavouriteButtonSizeColorAnimationState();
}

class _FavouriteButtonSizeColorAnimationState
    extends State<FavouriteButtonSizeColorAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late AnimationController _colorController;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  late bool _isFavourite;

  @override
  void initState() {
    super.initState();

    _isFavourite = widget.isFavourite;

    _sizeController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _colorController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _sizeController,
        curve: Curves.elasticOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: widget.inactiveColor ?? AppColors.primary,
      end: widget.activeColor,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ),
    );

    _colorController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _sizeController.reverse();
      }
    });

    // Initialize color controller to end value if the item is favourite, but don't start size animation
    if (_isFavourite) {
      _colorController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isFavourite) {
      _sizeController.forward();
      _colorController.reverse();
    } else {
      _sizeController.forward();
      _colorController.forward();
    }
    if (widget.changeUi) {
      setState(() {
        _isFavourite = !_isFavourite;
      });
    }

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: CustomCircularButtonIcon(
        onPressed: _handleTap,
        size: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([_sizeAnimation, _colorAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _sizeAnimation.value,
              child: Icon(
                _isFavourite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _colorAnimation.value,
                size: widget.iconSize,
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavouriteButtonScaleAnimation extends StatefulWidget {
  const FavouriteButtonScaleAnimation({
    super.key,
    required this.isFavourite,
    required this.onTap,
    this.iconSize,
    this.size,
  });

  final bool isFavourite;
  final VoidCallback onTap;
  final double? iconSize;
  final double? size;

  @override
  State<FavouriteButtonScaleAnimation> createState() =>
      _FavouriteButtonScaleAnimationState();
}

class _FavouriteButtonScaleAnimationState
    extends State<FavouriteButtonScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CustomCircularButtonIcon(
        onPressed: _handleTap,
        size: widget.size,
        child: Icon(
          widget.isFavourite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: AppColors.primary,
          size: widget.iconSize,
        ),
      ),
    );
  }
}

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    super.key,
    required this.isFavourite,
    required this.onTap,
    this.iconSize,
    this.size,
  });

  final bool isFavourite;
  final VoidCallback onTap;
  final double? iconSize;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CustomCircularButtonIcon(
      onPressed: onTap,
      size: size,
      child: Icon(
        isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: AppColors.primary,
        size: iconSize,
      ),
    );
  }
}
