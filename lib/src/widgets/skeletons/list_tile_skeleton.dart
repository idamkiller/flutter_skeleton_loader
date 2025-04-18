import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class ListTileSkeleton extends BaseSkeleton {
  final bool showLeading;
  final bool showTrailing;

  const ListTileSkeleton({
    super.key,
    required super.baseColor,
    this.showLeading = true,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (showLeading)
            Container(
              key: const Key('list_tile_skeleton_leading'),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  key: const Key('list_tile_skeleton_title'),
                  width: 200,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  key: const Key('list_tile_skeleton_subtitle'),
                  width: 150,
                  height: 14,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          if (showTrailing)
            Container(
              key: const Key('list_tile_skeleton_trailing'),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
