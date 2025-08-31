import '../../flutter_skeleton_loader.dart';

/// [BaseSkeletonProvider] abstract base class that provides common functionality
/// for specific skeleton providers
abstract class BaseSkeletonProvider implements SkeletonProvider {
  @override
  int get priority => 0;

  /// [UTILITY] Helper method to validate dimensions
  /// Prevents common errors with infinite dimensions
  bool hasValidDimensions(double? width, double? height) {
    return (width == null || width.isFinite) &&
        (height == null || height.isFinite);
  }

  /// [SANITIZATION] Converts problematic dimensions to safe values
  double sanitizeDimension(double? dimension, double defaultValue) {
    if (dimension == null || !dimension.isFinite || dimension <= 0) {
      return defaultValue;
    }
    return dimension;
  }
}
