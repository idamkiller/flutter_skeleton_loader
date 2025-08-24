import 'package:flutter/material.dart';

/// [WidgetValidator]
/// Utility to validate and sanitize widgets before converting them to skeletons.
/// Prevents common errors such as infinite dimensions, overflow, and problematic
/// configurations that can cause rendering exceptions.
class WidgetValidator {
  /// [MAIN VALIDATION] Verify if a widget is safe for skeleton creation
  ///
  /// @param widget Widget to validate
  /// @return true if the widget is safe for skeleton, false if it needs sanitization
  static bool isValidForSkeleton(Widget widget) {
    try {
      // [CONTAINER VALIDATION] Verify problematic constraints
      if (widget is Container) {
        final container = widget;

        // Validate that it doesn't have problematic infinite dimensions
        if (container.constraints != null) {
          final constraints = container.constraints!;
          if (constraints.maxHeight == double.infinity &&
              constraints.minHeight == double.infinity) {
            return false;
          }
          if (constraints.maxWidth == double.infinity &&
              constraints.minWidth == double.infinity) {
            return false;
          }
        }

        // Validate direct dimensions (Container doesn't have direct width/height)
        // In Container, dimensions are in constraints or decoration
        if (container.constraints != null) {
          final constraints = container.constraints!;
          if ((constraints.maxWidth == double.infinity &&
                  constraints.minWidth == double.infinity) ||
              (constraints.maxHeight == double.infinity &&
                  constraints.minHeight == double.infinity)) {
            return false;
          }
        }
      }

      // [SizedBox VALIDATION] Verify dimensions of SizedBox
      if (widget is SizedBox) {
        final sizedBox = widget;
        if (sizedBox.width == double.infinity ||
            sizedBox.height == double.infinity) {
          return false;
        }
      }

      // [EXPANDED VALIDATION] Expanded widgets need special handling
      if (widget is Expanded) {
        // Expanded widgets always need special handling
        return false;
      }

      // [FLEXIBLE VALIDATION] Similar to Expanded
      if (widget is Flexible) {
        return false;
      }

      return true;
    } catch (e) {
      // [ERROR HANDLING] If there's any error in validation,
      // we assume the widget needs sanitization
      debugPrint('WidgetValidator: Error validating widget: $e');
      return false;
    }
  }

  /// [SANITIZATION] Cleans and prepares a widget for safe conversion to skeleton
  ///
  /// @param widget Original widget that may have issues
  /// @return Sanitized widget safe for skeleton
  static Widget sanitizeWidget(Widget widget) {
    try {
      // [SANITIZATION CONTAINER] Fix Container issues
      if (widget is Container) {
        final container = widget;

        // Container doesn't have direct width/height, only constraints
        BoxConstraints? newConstraints = container.constraints;

        // Fix problematic constraints
        if (newConstraints != null) {
          newConstraints = BoxConstraints(
            minWidth: newConstraints.minWidth.isInfinite
                ? 0
                : newConstraints.minWidth,
            maxWidth: newConstraints.maxWidth.isInfinite
                ? double.infinity
                : newConstraints.maxWidth,
            minHeight: newConstraints.minHeight.isInfinite
                ? 0
                : newConstraints.minHeight,
            maxHeight: newConstraints.maxHeight.isInfinite
                ? 200
                : newConstraints.maxHeight,
          );
        }

        return Container(
          constraints: newConstraints,
          margin: container.margin,
          padding: container.padding,
          decoration: container.decoration,
          child:
              container.child != null ? sanitizeWidget(container.child!) : null,
        );
      }

      // [SizedBox SANITIZATION] Fix problematic dimensions
      if (widget is SizedBox) {
        final sizedBox = widget;

        double? newWidth = sizedBox.width;
        double? newHeight = sizedBox.height;

        if (newWidth == double.infinity) {
          newWidth = null;
        }

        if (newHeight == double.infinity) {
          newHeight = 100; // Default height
        }

        return SizedBox(
          width: newWidth,
          height: newHeight,
          child:
              sizedBox.child != null ? sanitizeWidget(sizedBox.child!) : null,
        );
      }

      // [EXPANDED SANITIZATION] Convert to normal container
      if (widget is Expanded) {
        // Convert Expanded to SizedBox to avoid context issues
        return SizedBox(
          height: 50, // Default height for Expanded
          child: sanitizeWidget(widget.child),
        );
      }

      // [FLEXIBLE SANITIZATION] Similar to Expanded
      if (widget is Flexible) {
        return SizedBox(
          height: 50,
          child: sanitizeWidget(widget.child),
        );
      }

      // [RECURSIVE SANITIZATION] Handle widgets with children
      if (widget is SingleChildRenderObjectWidget) {
        if (widget.child != null) {
          // Create a sanitized version while preserving main properties
          return Container(
            child: sanitizeWidget(widget.child!),
          );
        }
      }

      // If no specific sanitization is needed, return the original widget
      return widget;
    } catch (e) {
      // [EMERGENCY FALLBACK] If sanitization fails, create basic container
      debugPrint('WidgetValidator: Error sanitizing widget: $e');
      return Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
  }

  /// [UTILITY] Verify if a widget is in a valid Flex context
  ///
  /// Note: This is a basic approximation. A complete implementation would
  /// require access to the BuildContext to verify the parent widget tree.
  ///
  /// @param widget Widget to verify
  /// @return true if probably in valid Flex context
  static bool isInFlexContext(Widget widget) {
    // [HEURISTIC] For now, we assume that certain widgets indicate Flex context
    // In a more robust implementation, this would require analysis of the widget tree

    if (widget is Expanded || widget is Flexible) {
      // These widgets should be in a Flex context, but we can't guarantee it
      // without access to the parent context
      return true;
    }

    return false;
  }

  /// [DEBUGGING] Get diagnostic information about a widget
  ///
  /// @param widget Widget to diagnose
  /// @return String with debugging information
  static String getDiagnosticInfo(Widget widget) {
    final buffer = StringBuffer();
    buffer.writeln('Widget Type: ${widget.runtimeType}');

    if (widget is Container) {
      final container = widget;
      buffer.writeln('Container constraints: ${container.constraints}');
      buffer.writeln('Container decoration: ${container.decoration}');
    }

    if (widget is SizedBox) {
      final sizedBox = widget;
      buffer.writeln('SizedBox width: ${sizedBox.width}');
      buffer.writeln('SizedBox height: ${sizedBox.height}');
    }

    buffer.writeln('Is valid for skeleton: ${isValidForSkeleton(widget)}');

    return buffer.toString();
  }
}
