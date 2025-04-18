import 'package:flutter/material.dart';
import 'src/widgets/shimmer_effect.dart';
import 'src/widgets/skeleton_builder.dart';

/// A widget that displays a loading effect (skeleton) while the real content is loading.
///
/// This widget wraps any child widget and shows an animated skeleton when [isLoading] is true.
/// The skeleton is automatically generated based on the child widget type, maintaining its dimensions
/// and basic structure.
///
/// Usage example:
/// ```dart
/// SkeletonLoader(
///   isLoading: isLoading,
///   child: YourWidget(),
/// )
/// ```
class SkeletonLoader extends StatefulWidget {
  /// The widget to be displayed when [isLoading] is false.
  final Widget child;

  /// Indicates whether to show the skeleton or the real content.
  /// Defaults to true.
  final bool isLoading;

  /// The base color of the skeleton.
  /// Defaults to [Colors.grey].
  final Color baseColor;

  /// The color of the shimmer effect that moves through the skeleton.
  /// Defaults to [Colors.white].
  final Color highlightColor;

  /// The final color of the shimmer effect.
  /// Defaults to [Colors.grey].
  final Color endColor;

  /// The duration of the transition between skeleton and real content.
  /// Defaults to 300 milliseconds.
  final Duration transitionDuration;

  /// Creates a new [SkeletonLoader].
  ///
  /// The [child] parameter is required and represents the widget to be displayed
  /// when [isLoading] is false.
  ///
  /// The other parameters are optional and have default values:
  /// - [isLoading]: true
  /// - [baseColor]: Colors.grey
  /// - [highlightColor]: Colors.white
  /// - [endColor]: Colors.grey
  /// - [transitionDuration]: Duration(milliseconds: 300)
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

/// Internal state of the [SkeletonLoader] widget.
///
/// This class handles the shimmer effect animation and the skeleton construction
/// based on the child widget.
class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  /// Controller for the shimmer effect animation.
  late AnimationController _controller;

  /// Animation that controls the movement of the shimmer effect.
  late Animation<double> _animation;

  /// Builder for the skeleton based on the child widget.
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
      child: widget.isLoading
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
