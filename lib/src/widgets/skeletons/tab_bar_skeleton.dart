import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class TabBarSkeleton extends BaseSkeleton {
  final int tabCount;
  final double? height;
  final double? tabWidth;

  const TabBarSkeleton({
    super.key,
    required super.baseColor,
    this.tabCount = 3,
    this.height,
    this.tabWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          tabCount,
          (index) => Container(
            width: tabWidth ?? 80,
            height: height ?? 48,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
