import 'package:flutter/material.dart';

class CountDownWidget extends StatefulWidget {
  const CountDownWidget({
    super.key,
    required this.duration,
    this.circularSize = 26,
    this.circularColor,
    this.counterTextColor,
  });
  final Duration duration;
  final double circularSize;
  final Color? circularColor;
  final Color? counterTextColor;
  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  String get counterText {
    final Duration count = controller.duration! * controller.value;
    return count.inSeconds.toString();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    controller.reverse(from: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: widget.circularSize,
              width: widget.circularSize,
              child: CircularProgressIndicator(
                value: controller.value,
                strokeWidth: 2,
                color: widget.circularColor ?? Colors.white,
              ),
            ),
            Text(
              counterText,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: widget.counterTextColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        );
      },
    );
  }
}
