import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class ListViewSkeleton extends BaseSkeleton {
  final Axis scrollDirection;
  final int itemCount;

  const ListViewSkeleton({
    super.key,
    required super.baseColor,
    this.scrollDirection = Axis.vertical,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: 72,
          width: 300,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
