import 'package:flutter/material.dart';

class ShimmerEffect extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Color endColor;
  final Animation<double> animation;

  const ShimmerEffect({
    super.key,
    required this.child,
    required this.animation,
    required this.baseColor,
    required this.highlightColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(animation.value - 1, 0),
              end: Alignment(animation.value, 0),
              colors: [baseColor, highlightColor, endColor],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
