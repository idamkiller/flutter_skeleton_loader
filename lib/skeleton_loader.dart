import 'package:flutter/material.dart';
import 'src/widgets/shimmer_effect.dart';
import 'src/widgets/skeleton_builder.dart';

/// A widget that shows a skeleton loading animation while data is being loaded.
///
/// The [SkeletonLoader] wraps any Flutter widget and automatically creates a skeleton
/// version of it when [isLoading] is true. When the data is ready, it smoothly
/// transitions to show the actual content.
///
/// The skeleton version mimics the structure of the original widget with a shimmer
/// animation to indicate the loading state.
///
/// Example usage:
/// ```dart
/// SkeletonLoader(
///   isLoading: _isLoading, // Set to true while loading data
///   child: Text('Content loaded successfully!'),
/// )
/// ```
///
/// You can customize the appearance of the skeleton by adjusting the [baseColor],
/// [highlightColor], and animation speed with [shimmerDuration].
class SkeletonLoader extends StatefulWidget {
  /// The widget to display when loading is complete.
  ///
  /// This widget will be analyzed to create an appropriate skeleton
  /// representation when [isLoading] is true.
  final Widget child;

  /// Controls whether to show the skeleton or the actual content.
  ///
  /// When true, a skeleton version of [child] will be displayed with
  /// a shimmer effect. When false, the actual [child] will be shown.
  final bool isLoading;

  /// The base color of the skeleton.
  ///
  /// This color serves as the primary color for skeleton representations.
  /// Default is a light gray (0xFFE0E0E0).
  final Color baseColor;

  /// The highlight color for the shimmer effect.
  ///
  /// This color creates the moving highlight that gives the skeleton
  /// its animated appearance. Default is a lighter gray (0xFFEEEEEE).
  final Color highlightColor;

  /// The duration of one complete shimmer animation cycle.
  ///
  /// Controls how fast the highlight moves across the skeleton.
  /// Default is 1.5 seconds.
  final Duration shimmerDuration;

  /// The duration of the transition between skeleton and content.
  ///
  /// Controls how quickly the UI changes from skeleton to actual content
  /// when [isLoading] changes from true to false. Default is 300 milliseconds.
  final Duration transitionDuration;

  /// Creates a skeleton loader widget.
  ///
  /// The [child] and [isLoading] parameters are required.
  /// All other parameters have default values that can be customized.
  const SkeletonLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFEEEEEE),
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> {
  late Widget _skeletonWidget;
  late Widget _actualWidget;

  @override
  void initState() {
    super.initState();
    _buildWidgets();
  }

  @override
  void didUpdateWidget(SkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child ||
        oldWidget.baseColor != widget.baseColor ||
        oldWidget.highlightColor != widget.highlightColor) {
      _buildWidgets();
    }
  }

  /// Builds and caches both the skeleton and actual widgets.
  ///
  /// This method is called on initialization and when relevant properties change.
  /// Using [RepaintBoundary] improves performance by isolating the shimmer animation
  /// and preventing unnecessary repaints of the widget tree.
  void _buildWidgets() {
    // RepaintBoundary is used to isolate the widget from the rest of the widget tree
    // and prevent it from being affected by the shimmer effect.
    // This is important for performance reasons, as it prevents unnecessary repaints.
    _skeletonWidget = RepaintBoundary(
      child: ShimmerEffect(
        baseColor: widget.baseColor,
        highlightColor: widget.highlightColor,
        duration: widget.shimmerDuration,
        child: _buildSkeletonFromWidget(widget.child, widget.baseColor),
      ),
    );

    _actualWidget = widget.child;
  }

  /// Converts a regular widget into its skeleton representation.
  ///
  /// Uses [SkeletonBuilder] to analyze the widget structure and create
  /// an appropriate skeleton version based on the widget type.
  Widget _buildSkeletonFromWidget(Widget widget, Color color) =>
      SkeletonBuilder(baseColor: color).buildSkeleton(widget);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedCrossFade(
          firstChild: _skeletonWidget,
          secondChild: _actualWidget,
          duration: widget.transitionDuration,
          crossFadeState: widget.isLoading
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                  key: bottomChildKey,
                  child: bottomChild,
                ),
                Positioned.fill(
                  key: topChildKey,
                  child: topChild,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
