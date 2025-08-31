import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class PageViewSkeleton extends BaseSkeleton {
  final int itemCount;
  final double height;
  final double? width;

  const PageViewSkeleton({
    super.key,
    required super.baseColor,
    required this.itemCount,
    this.height = 200,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double currentWidth = width ??
            (constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : double.infinity);

        return SizedBox(
          width: currentWidth,
          height: height,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Container(
                key: ValueKey('page_skeleton_$index'),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        );
      },
    );
  }
}
