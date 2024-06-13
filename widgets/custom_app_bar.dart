import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.haveBackButton = false,
    this.centerTitle = false,
    this.haveLogo = true,
    this.onBack,
  });

  final String? title;
  final bool haveBackButton;
  final bool centerTitle;
  final VoidCallback? onBack;
  final bool haveLogo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: haveBackButton
          ? InkWell(
              child: const Icon(Icons.arrow_back_ios),
              onTap: () {
                context.pop();
                if (onBack != null) onBack!();
              },
            )
          : null,
      automaticallyImplyLeading: false,
      title: title != null ? Text(title!) : haveLogo ? Assets.icons.logo.svg() : null,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
