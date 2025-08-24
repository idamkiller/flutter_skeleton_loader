import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/page_view_skeleton.dart';

class PageViewSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is PageView;

  @override
  int get priority => 8;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    originalWidget as PageView;

    int itemCount = 3;

    // **[DIMENSIONES POR DEFECTO]** Para PageView típico
    double height = 200;
    double? width;

    return PageViewSkeleton(
      baseColor: baseColor,
      itemCount: itemCount,
      height: height,
      width: width,
    );
  }
}
