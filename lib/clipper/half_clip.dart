import 'package:flutter/material.dart';

class HalfClip extends CustomClipper<Rect> {
  final bool left;

  HalfClip({this.left});

  @override
  Rect getClip(Size size) {
    Rect rect;

    if (left != null && left) {
      rect = Rect.fromLTRB((size.width / 2 - 5), 0.0, size.width, size.height);
    } else {
      rect = Rect.fromLTRB(0.0, 0.0, (size.width / 2 + 5), size.height);
    }

    return rect;
  }

  @override
  bool shouldReclip(HalfClip oldClipper) {
    return false;
  }
}
