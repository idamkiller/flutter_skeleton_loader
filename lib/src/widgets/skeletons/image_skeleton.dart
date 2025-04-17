import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class ImageSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;

  const ImageSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
