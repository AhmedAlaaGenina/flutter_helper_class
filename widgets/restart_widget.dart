import 'package:flutter/material.dart';

class RestartWidget extends StatelessWidget {
  final Widget child;

  const RestartWidget({
    required Key key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
