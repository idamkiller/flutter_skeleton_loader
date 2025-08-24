import 'package:flutter/material.dart';
import '../interfaces/base_skeleton_provider.dart';
import '../widgets/skeletons/text_skeleton.dart';

class TextSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Text;

  @override
  int get priority => 10;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final text = originalWidget as Text;

    final textData = text.data ?? '';

    return TextSkeleton(
      baseColor: baseColor,
      text: textData.isNotEmpty ? textData : null,
    );
  }
}
