import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/list_tile_skeleton.dart';

class ListTileSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is ListTile;

  @override
  int get priority => 8;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final listTile = originalWidget as ListTile;

    bool hasLeading = listTile.leading != null;
    bool hasTrailing = listTile.trailing != null;

    return ListTileSkeleton(
      baseColor: baseColor,
      showLeading: hasLeading,
      showTrailing: hasTrailing,
    );
  }
}
