import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class CardSkeleton extends BaseSkeleton {
  final double width;
  final double height;

  const CardSkeleton({
    super.key,
    required super.baseColor,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
