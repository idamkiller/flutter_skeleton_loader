import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class CardSkeleton extends BaseSkeleton {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;

  const CardSkeleton({
    super.key,
    required super.baseColor,
    this.width = double.infinity,
    this.height = 200,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
