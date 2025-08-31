import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/src/interfaces/base_skeleton_provider.dart';

class TestSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Container;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container(
      width: 100,
      height: 100,
      color: baseColor,
    );
  }

  @override
  int get priority => 5;

  // Métodos públicos para probar métodos protegidos
  bool testHasValidDimensions(double? width, double? height) {
    return hasValidDimensions(width, height);
  }

  double testSanitizeDimension(double? dimension, double defaultValue) {
    return sanitizeDimension(dimension, defaultValue);
  }
}
