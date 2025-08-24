import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/list_view_skeleton.dart';

class ListViewSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is ListView;

  @override
  int get priority => 9;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final listView = originalWidget as ListView;

    Axis scrollDirection = listView.scrollDirection;

    int itemCount = 3;

    return ListViewSkeleton(
      baseColor: baseColor,
      scrollDirection: scrollDirection,
      itemCount: itemCount,
    );
  }
}
