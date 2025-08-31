import 'package:flutter/material.dart';

/// [SkeletonProvider] interface for skeleton providers that defines the contract
/// that all specific skeleton generators must adhere to.
abstract class SkeletonProvider {
  /// [VALIDATION] Determines if this provider can handle the given widget
  ///
  /// @param widget The original widget for which a skeleton is needed
  /// @return true if this provider can create a skeleton for the widget
  bool canHandle(Widget widget);

  /// [SKELETON GENERATION] Creates the corresponding skeleton
  ///
  /// @param originalWidget The original widget to convert into a skeleton
  /// @param baseColor The base color for the skeleton
  /// @return The generated skeleton widget
  Widget createSkeleton(Widget originalWidget, Color baseColor);

  /// [PRIORITY] Defines the priority of this provider
  /// Providers with higher priority are evaluated first
  /// Default is 0 (normal priority)
  int get priority => 0;
}
