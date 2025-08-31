import 'package:flutter/material.dart';
import 'flutter_skeleton_loader.dart';
import 'src/widgets/shimmer_effect.dart';
import 'src/widgets/skeleton_builder.dart';

/// [SkeletonLoader] wraps any Flutter widget and automatically creates a skeleton
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

  /// [CONSTRUCTOR INTERNO] Constructor privado real
  const SkeletonLoader._internal({
    super.key,
    required this.child,
    required this.isLoading,
    required this.baseColor,
    required this.highlightColor,
    required this.shimmerDuration,
    required this.transitionDuration,
  });

  /// [SkeletonLoader] wraps any Flutter widget and automatically creates a skeleton
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
  factory SkeletonLoader({
    Key? key,
    required Widget child,
    required bool isLoading,
    Color? baseColor,
    Color? highlightColor,
    Duration? shimmerDuration,
    Duration? transitionDuration,
  }) {
    final config = SkeletonConfig.instance;

    return SkeletonLoader._internal(
      key: key,
      isLoading: isLoading,
      baseColor: baseColor ?? config.defaultBaseColor,
      highlightColor: highlightColor ?? config.defaultHighlightColor,
      shimmerDuration: shimmerDuration ?? config.defaultShimmerDuration,
      transitionDuration:
          transitionDuration ?? config.defaultTransitionDuration,
      child: child,
    );
  }

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> {
  late Widget _skeletonWidget;
  late Widget _actualWidget;

  /// [CACHE SYSTEM] Variables to avoid unnecessary rebuilds
  String? _cachedSkeletonKey;

  /// [CACHE KEY] Generates a unique key based on the widget's properties
  String _generateSkeletonKey() {
    return '${widget.child.runtimeType}_${widget.child.hashCode}_${widget.baseColor.value}_${widget.highlightColor.value}';
  }

  @override
  void initState() {
    super.initState();
    _buildWidgets();
  }

  @override
  void didUpdateWidget(SkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// [CACHE OPTIMIZATION] Only rebuild if relevant properties changed
    final hasRelevantChanges = oldWidget.child != widget.child ||
        oldWidget.baseColor != widget.baseColor ||
        oldWidget.highlightColor != widget.highlightColor ||
        oldWidget.shimmerDuration != widget.shimmerDuration;

    if (hasRelevantChanges) {
      _buildWidgets();
    }
  }

  /// Builds and caches both the skeleton and actual widgets.
  ///
  /// This method is called on initialization and when relevant properties change.
  /// Using [RepaintBoundary] improves performance by isolating the shimmer animation
  /// and preventing unnecessary repaints of the widget tree.
  ///
  /// [CACHE SYSTEM IMPLEMENTED] Avoids unnecessary rebuilds
  void _buildWidgets() {
    try {
      final newKey = _generateSkeletonKey();

      /// [CACHE VERIFICATION] Only rebuild skeleton if key changed
      if (_cachedSkeletonKey != newKey) {
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

        _cachedSkeletonKey = newKey;
      }

      _actualWidget = widget.child;
    } catch (e) {
      // Create default skeleton in case of error
      _skeletonWidget = RepaintBoundary(
        child: ShimmerEffect(
          baseColor: widget.baseColor,
          highlightColor: widget.highlightColor,
          duration: widget.shimmerDuration,
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: widget.baseColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
      _actualWidget = widget.child;
    }
  }

  /// Converts a regular widget into its skeleton representation.
  ///
  /// Uses [SkeletonBuilder] to analyze the widget structure and create
  /// an appropriate skeleton version based on the widget type.
  Widget _buildSkeletonFromWidget(Widget widget, Color color) {
    return SkeletonBuilder(baseColor: color).buildSkeleton(widget);
  }

  @override
  Widget build(BuildContext context) {
    /// [SIMPLE LAYOUT SOLUTION]
    /// Using AnimatedSwitcher is more stable than AnimatedCrossFade
    /// to avoid "RenderBox was not laid out" issues
    return AnimatedSwitcher(
      duration: widget.transitionDuration,
      child: widget.isLoading
          ? KeyedSubtree(
              key: const ValueKey('skeleton'),
              child: _skeletonWidget,
            )
          : KeyedSubtree(
              key: const ValueKey('content'),
              child: _actualWidget,
            ),
    );
  }
}
