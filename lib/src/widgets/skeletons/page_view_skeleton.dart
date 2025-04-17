import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class PageViewSkeleton extends BaseSkeleton {
  final int itemCount;

  const PageViewSkeleton({
    super.key,
    required super.baseColor,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
