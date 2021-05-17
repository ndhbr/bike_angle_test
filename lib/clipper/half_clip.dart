import 'package:flutter/material.dart';

class HalfClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(HalfClip oldClipper) {
    return true;
  }
}
