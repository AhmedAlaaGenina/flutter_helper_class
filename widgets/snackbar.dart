import 'package:fashion/config/routes/routes.dart';
import 'package:fashion/config/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/*
! in Material App 
!   navigatorKey: rootNavigatorKey,
? define rootNavigatorKey as Global variable
?   GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
 */
class CustomSnackBar {
  static errorSnackBar(String text) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.maybeOf(
                RouteConfigurations.parentNavigatorKey.currentState!.context)!
            .showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            behavior: SnackBarBehavior.floating,
            width: 350,
            elevation: 30,
            content: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(RouteConfigurations
                      .parentNavigatorKey.currentState!.context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  static warningSnackBar(String text) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
              RouteConfigurations.parentNavigatorKey.currentState!.context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.yellow,
          behavior: SnackBarBehavior.floating,
          width: 350,
          elevation: 30,
          content: Row(
            children: [
              const Icon(Icons.warning, color: AppColors.primary),
              const SizedBox(width: 5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(RouteConfigurations
                        .parentNavigatorKey.currentState!.context)
                    .textTheme
                    .titleLarge,
              ),
            ],
          ),
        ),
      );
    });
  }

  static primarySnackBar(String text) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(
                RouteConfigurations.parentNavigatorKey.currentState!.context)
            .showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xff4338CA),
            behavior: SnackBarBehavior.floating,
            width: 350,
            elevation: 30,
            content: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(RouteConfigurations
                      .parentNavigatorKey.currentState!.context)
                  .textTheme
                  .titleMedium,
            ),
          ),
        );
      },
    );
  }

  static customSnackBar({
    required String text,
    required Color color,
     Color? textColor,
  }) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(
                RouteConfigurations.parentNavigatorKey.currentState!.context)
            .showSnackBar(
          SnackBar(
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            width: 350,
            elevation: 30,
            content: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(RouteConfigurations
                      .parentNavigatorKey.currentState!.context)
                  .textTheme
                  .titleMedium!.copyWith(color: textColor),
            ),
          ),
        );
      },
    );
  }
}
