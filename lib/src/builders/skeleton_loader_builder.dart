import 'package:flutter/material.dart';
import '../../skeleton_loader.dart';
import '../config/skeleton_config.dart';

/// [SkeletonLoaderBuilder]Builder pattern to create SkeletonLoader with fluent syntax and configuration
/// more intuitive. Reduces verbosity and improves developer experience.
///
/// **Usage Example:**
/// ```dart
/// SkeletonLoaderBuilder()
///   .child(Text('Hello World'))
///   .loading(true)
///   .baseColor(Colors.grey[300])
///   .shimmerDuration(Duration(milliseconds: 1000))
///   .build()
/// ```
class SkeletonLoaderBuilder {
  Color? _baseColor;
  Color? _highlightColor;
  Duration? _shimmerDuration;
  Duration? _transitionDuration;
  Widget? _child;
  bool? _isLoading;

  /// [BASE COLOR CONFIGURATION]
  /// Sets the base color for the skeleton
  SkeletonLoaderBuilder baseColor(Color color) {
    _baseColor = color;
    return this;
  }

  /// [HIGHLIGHT COLOR CONFIGURATION]
  /// Sets the highlight color for the shimmer effect
  SkeletonLoaderBuilder highlightColor(Color color) {
    _highlightColor = color;
    return this;
  }

  /// [SHIMMER DURATION CONFIGURATION]
  /// Sets the duration of the shimmer animation
  SkeletonLoaderBuilder shimmerDuration(Duration duration) {
    _shimmerDuration = duration;
    return this;
  }

  /// [TRANSITION DURATION CONFIGURATION]
  /// Sets the duration of the transition between skeleton and content
  SkeletonLoaderBuilder transitionDuration(Duration duration) {
    _transitionDuration = duration;
    return this;
  }

  /// [CHILD WIDGET CONFIGURATION]
  /// Sets the widget to display when loading is complete
  SkeletonLoaderBuilder child(Widget child) {
    _child = child;
    return this;
  }

  /// [LOADING STATE CONFIGURATION]
  /// Sets whether to show the skeleton (true) or the actual content (false)
  SkeletonLoaderBuilder loading(bool isLoading) {
    _isLoading = isLoading;
    return this;
  }

  /// [THEME CONFIGURATION]
  /// Applies a common light theme
  SkeletonLoaderBuilder lightTheme() {
    _baseColor = const Color(0xFFE0E0E0);
    _highlightColor = const Color(0xFFF5F5F5);
    return this;
  }

  /// [DARK THEME CONFIGURATION]
  /// Applies a dark theme
  SkeletonLoaderBuilder darkTheme() {
    _baseColor = const Color(0xFF424242);
    _highlightColor = const Color(0xFF616161);
    return this;
  }

  /// [FAST ANIMATION CONFIGURATION]
  /// Applies configuration for fast skeletons
  SkeletonLoaderBuilder fastAnimation() {
    _shimmerDuration = const Duration(milliseconds: 800);
    _transitionDuration = const Duration(milliseconds: 200);
    return this;
  }

  /// [SLOW ANIMATION CONFIGURATION]
  /// Applies configuration for slow and smooth skeletons
  SkeletonLoaderBuilder slowAnimation() {
    _shimmerDuration = const Duration(milliseconds: 2500);
    _transitionDuration = const Duration(milliseconds: 500);
    return this;
  }

  /// [VALIDATION AND CONSTRUCTION]
  /// Builds the final SkeletonLoader with validations
  SkeletonLoader build() {
    // [REQUIRED VALIDATION] Child is mandatory
    if (_child == null) {
      throw ArgumentError(
          'Child widget is required. Use child() method to set it.');
    }

    // [STATE VALIDATION] isLoading must be defined
    if (_isLoading == null) {
      throw ArgumentError(
          'Loading state is required. Use loading() method to set it.');
    }

    // [DEFAULTS APPLICATION] Use global config as fallback
    final config = SkeletonConfig.instance;

    return SkeletonLoader(
      isLoading: _isLoading!,
      baseColor: _baseColor ?? config.defaultBaseColor,
      highlightColor: _highlightColor ?? config.defaultHighlightColor,
      shimmerDuration: _shimmerDuration ?? config.defaultShimmerDuration,
      transitionDuration:
          _transitionDuration ?? config.defaultTransitionDuration,
      child: _child!,
    );
  }

  /// [STATIC UTILITY] Convenience method for quick configuration
  static SkeletonLoader quick({
    required Widget child,
    required bool isLoading,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return SkeletonLoaderBuilder()
        .child(child)
        .loading(isLoading)
        .baseColor(baseColor ?? SkeletonConfig.instance.defaultBaseColor)
        .highlightColor(
            highlightColor ?? SkeletonConfig.instance.defaultHighlightColor)
        .build();
  }

  /// [STATIC UTILITY] Quick configuration with light theme
  static SkeletonLoader light({
    required Widget child,
    required bool isLoading,
  }) {
    return SkeletonLoaderBuilder()
        .child(child)
        .loading(isLoading)
        .lightTheme()
        .build();
  }

  /// [STATIC UTILITY] Quick configuration with dark theme
  static SkeletonLoader dark({
    required Widget child,
    required bool isLoading,
  }) {
    return SkeletonLoaderBuilder()
        .child(child)
        .loading(isLoading)
        .darkTheme()
        .build();
  }
}
