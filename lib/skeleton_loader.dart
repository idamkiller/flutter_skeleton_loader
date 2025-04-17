import 'package:flutter/material.dart';
import 'src/widgets/shimmer_effect.dart';
import 'src/widgets/skeleton_builder.dart';

class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color baseColor;
  final Color highlightColor;
  final Color endColor;
  final Duration transitionDuration;

  const SkeletonLoader({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
    this.endColor = Colors.grey,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late SkeletonBuilder _skeletonBuilder;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
    _skeletonBuilder = SkeletonBuilder(baseColor: widget.baseColor);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.transitionDuration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child:
          widget.isLoading
              ? ShimmerEffect(
                animation: _animation,
                baseColor: widget.baseColor,
                highlightColor: widget.highlightColor,
                endColor: widget.endColor,
                child: _skeletonBuilder.buildSkeleton(widget.child),
              )
              : widget.child,
    );
  }
}
