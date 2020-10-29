import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppBackgroundContainer extends StatelessWidget {
  final Widget child;
  EdgeInsetsGeometry padding;
  EdgeInsetsGeometry margin;
  AlignmentGeometry alignment;

  AppBackgroundContainer({
    Key key,
    @required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      alignment: alignment,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            const Color(0xFFffa354),
            const Color(0xFFffa354),
            const Color(0xFFff8b54),
            const Color(0xFFff8b54),
          ],
        ),
      ),
      child: child,
    );
  }
}
