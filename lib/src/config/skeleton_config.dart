import 'package:flutter/material.dart';

/// [SkeletonConfig] global configuration for SkeletonLoader that allows you to set values
/// by default for the entire application, reducing the need to pass
/// the same parameters repeatedly.
///
/// Example usage:
/// ```dart
/// SkeletonConfig.configure(
///   baseColor: Colors.grey[300],
///   highlightColor: Colors.white,
///   shimmerDuration: Duration(milliseconds: 1000),
/// );
/// ```
class SkeletonConfig {
  static SkeletonConfig? _instance;

  /// Default base color for all skeletons
  final Color defaultBaseColor;

  /// Default highlight color for the shimmer effect
  final Color defaultHighlightColor;

  /// Default duration for the shimmer animation
  final Duration defaultShimmerDuration;

  /// Default duration for the transition between skeleton and content
  final Duration defaultTransitionDuration;

  const SkeletonConfig._({
    this.defaultBaseColor = const Color(0xFFE0E0E0),
    this.defaultHighlightColor = const Color(0xFFEEEEEE),
    this.defaultShimmerDuration = const Duration(milliseconds: 1500),
    this.defaultTransitionDuration = const Duration(milliseconds: 300),
  });

  /// [LAZY LOADING] Gets the singleton instance of the configuration
  /// It is only created when it is needed for the first time
  static SkeletonConfig get instance => _instance ??= SkeletonConfig._();

  /// [SkeletonConfig] global configuration for SkeletonLoader that allows you to set values
  /// by default for the entire application, reducing the need to pass
  /// the same parameters repeatedly.
  ///
  /// Example usage:
  /// ```dart
  /// SkeletonConfig.configure(
  ///   baseColor: Colors.grey[300],
  ///   highlightColor: Colors.white,
  ///   shimmerDuration: Duration(milliseconds: 1000),
  /// );
  /// ```
  static void configure({
    Color? baseColor,
    Color? highlightColor,
    Duration? shimmerDuration,
    Duration? transitionDuration,
  }) {
    _instance = SkeletonConfig._(
      defaultBaseColor: baseColor ?? instance.defaultBaseColor,
      defaultHighlightColor: highlightColor ?? instance.defaultHighlightColor,
      defaultShimmerDuration:
          shimmerDuration ?? instance.defaultShimmerDuration,
      defaultTransitionDuration:
          transitionDuration ?? instance.defaultTransitionDuration,
    );
  }

  /// [UTILITY] Resets the configuration to the default values
  static void reset() {
    _instance = null;
  }
}
