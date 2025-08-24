import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/circle_avatar_skeleton.dart';

class CircleAvatarSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is CircleAvatar;

  @override
  int get priority => 7;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final avatar = originalWidget as CircleAvatar;

    double radius = avatar.radius ?? 20.0;

    double size = radius * 2;

    radius = sanitizeDimension(radius, 20.0);
    size = sanitizeDimension(size, 40.0);

    return CircleAvatarSkeleton(
      baseColor: baseColor,
      radius: radius,
    );
  }
}
