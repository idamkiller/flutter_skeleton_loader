import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class ContainerSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;

  const ContainerSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
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
