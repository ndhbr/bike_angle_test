import 'package:flutter/material.dart';

/// Clip widget in half
class HalfClip extends CustomClipper<Rect> {
  final bool isRight;

  HalfClip({this.isRight});

  @override
  Rect getClip(Size size) {
    Rect rect;

    if (isRight != null && isRight) {
      rect = Rect.fromLTRB(0.0, 0.0, (size.width / 2 + 5), size.height);
    } else {
      rect = Rect.fromLTRB((size.width / 2 - 5), 0.0, size.width, size.height);
    }

    return rect;
  }

  @override
  bool shouldReclip(HalfClip oldClipper) {
    return false;
  }
}
