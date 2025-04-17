import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class ListSkeleton extends BaseSkeleton {
  final int itemCount;
  final double itemHeight;
  final double itemSpacing;
  final double itemBorderRadius;

  const ListSkeleton({
    super.key,
    required super.baseColor,
    this.itemCount = 3,
    this.itemHeight = 60,
    this.itemSpacing = 8,
    this.itemBorderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < itemCount - 1 ? itemSpacing : 0,
          ),
          child: Container(
            height: itemHeight,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(itemBorderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
