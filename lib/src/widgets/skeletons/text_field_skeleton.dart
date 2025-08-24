import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class TextFieldSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isMultiline;
  final bool hasDecoration;

  const TextFieldSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.isMultiline = false,
    this.hasDecoration = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? (isMultiline ? 120 : 48);

    return Container(
      width: width,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasDecoration
            ? Border.all(color: baseColor.withOpacity(0.5), width: 1)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasDecoration && effectiveHeight > 32)
              Container(
                height: 8,
                width: (width ?? 200) * 0.3,
                decoration: BoxDecoration(
                  color: baseColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            if (hasDecoration && effectiveHeight > 32)
              const SizedBox(height: 4),
            Container(
              height: isMultiline ? 60 : 12,
              width: (width ?? 200) * 0.8,
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
