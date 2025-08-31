import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/src/providers/checkbox_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/circle_avatar_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/icon_button_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/icon_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/image_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/list_tile_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/list_view_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/page_view_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/radio_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/sized_box_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/slider_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/switch_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/providers/text_field_skeleton_provider.dart';
import '../interfaces/skeleton_provider.dart';
import '../providers/dropdown_button_skeleton_provider.dart';
import '../providers/text_skeleton_provider.dart';
import '../providers/container_skeleton_provider.dart';
import '../widgets/skeletons/default_skeleton.dart';

/// [OptimizedSkeletonRegistry] Registry for optimized skeleton loading
class OptimizedSkeletonRegistry {
  /// [PERFORMANCE CACHE] Cache to avoid unnecessary rebuilds
  static final Map<String, Widget> _skeletonCache = {};

  /// [LAZY LOADING] Providers are loaded only when needed
  static List<SkeletonProvider>? _providers;

  /// [DEFERRED INITIALIZATION] Initializes providers only when needed
  static List<SkeletonProvider> _getProviders() {
    return _providers ??= [
      CheckboxSkeletonProvider(),
      CircleAvatarSkeletonProvider(),
      ContainerSkeletonProvider(),
      DropdownButtonSkeletonProvider(),
      IconButtonSkeletonProvider(),
      IconSkeletonProvider(),
      ImageSkeletonProvider(),
      ListTileSkeletonProvider(),
      ListViewSkeletonProvider(),
      PageViewSkeletonProvider(),
      RadioSkeletonProvider(),
      SizedBoxSkeletonProvider(),
      SliderSkeletonProvider(),
      SwitchSkeletonProvider(),
      TextFieldSkeletonProvider(),
      TextSkeletonProvider(),
      // etc.
    ]..sort((a, b) => b.priority.compareTo(a.priority)); // Sort by priority
  }

  /// [CACHE KEY GENERATION] Creates a unique key to cache skeletons
  static String _generateCacheKey(Widget widget, Color baseColor) {
    return '${widget.runtimeType}_${widget.hashCode}_${baseColor.value}';
  }

  /// [OPTIMIZED MAIN METHOD] Builds skeletons with caching and fallbacks
  static Widget buildSkeleton(Widget widget, Color baseColor) {
    try {
      // [CACHE VERIFICATION] Attempts to use cached skeleton
      final cacheKey = _generateCacheKey(widget, baseColor);
      if (_skeletonCache.containsKey(cacheKey)) {
        return _skeletonCache[cacheKey]!;
      }

      Widget? skeleton;

      // [SPECIAL MANAGEMENT OF COMPLEX CASES] Cases that need special logic
      skeleton = _handleSpecialCases(widget, baseColor);

      if (skeleton == null) {
        // [SEARCHING FOR PROVIDERS] Look for compatible provider
        final providers = _getProviders();

        for (final provider in providers) {
          if (provider.canHandle(widget)) {
            skeleton = provider.createSkeleton(widget, baseColor);
            break;
          }
        }
      }

      // [FALLBACK] If no provider is found, use default skeleton
      skeleton ??= _buildDefaultSkeleton(baseColor);

      // [CACHE RESULT] Store in cache for future queries
      _skeletonCache[cacheKey] = skeleton;

      return skeleton;
    } catch (e, _) {
      /// Fallback to default skeleton
      return _buildDefaultSkeleton(baseColor);
    }
  }

  /// [SPECIAL CASES HANDLING] Logic for widgets that need special treatment
  static Widget? _handleSpecialCases(Widget widget, Color baseColor) {
    // [SIZEDBOX WITH CHILD] Preserve dimensions of SizedBox
    if (widget is SizedBox && widget.child != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: buildSkeleton(widget.child!, baseColor),
      );
    }

    // [GESTUREDETECTOR] Process child of GestureDetector
    if (widget is GestureDetector) {
      final child = widget.child;
      return child != null
          ? buildSkeleton(child, baseColor)
          : _buildDefaultSkeleton(baseColor);
    }

    // [PADDING AND MARGIN HANDLING] Preserve spacing
    if (widget is Padding) {
      final child = widget.child;
      if (child == null) {
        return Padding(
          padding: widget.padding,
          child: _buildDefaultSkeleton(baseColor),
        );
      }
      return Padding(
        padding: widget.padding,
        child: buildSkeleton(child, baseColor),
      );
    }

    // [FORM] Process child of Form
    if (widget is Form) {
      return buildSkeleton(widget.child, baseColor);
    }

    if (widget is Container && widget.child != null) {
      return Container(
        width: widget.constraints?.maxWidth,
        height: widget.constraints?.maxHeight,
        margin: widget.margin,
        padding: widget.padding,
        decoration: widget.decoration,
        constraints: widget.constraints,
        child: buildSkeleton(widget.child!, baseColor),
      );
    }

    // [WIDGETS FLEX] Handle Row, Column, Wrap, Flex, Card
    if (widget is Row ||
        widget is Column ||
        widget is Wrap ||
        widget is Flex ||
        widget is Card) {
      return _buildMultiChildSkeleton(widget, baseColor);
    }

    // [EXPANDED/FLEXIBLE] Special handling to avoid context errors
    if (widget is Expanded) {
      // Convert to normal container to avoid context issues
      return SizedBox(
        height: 50, // Reasonable default height
        child: buildSkeleton(widget.child, baseColor),
      );
    }

    if (widget is Flexible) {
      return SizedBox(
        height: 50,
        child: buildSkeleton(widget.child, baseColor),
      );
    }

    return null; // Not a special case
  }

  /// [MULTI-CHILD PROCESSING] Handle widgets with multiple children
  static Widget _buildMultiChildSkeleton(Widget widget, Color baseColor) {
    final List<Widget> children = [];

    if (widget is MultiChildRenderObjectWidget) {
      for (final child in widget.children) {
        children.add(buildSkeleton(child, baseColor));
      }
    }

    // [PROPERTY PRESERVATION] Preserve properties of the original widget
    if (widget is Row) {
      return Row(
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        children: children,
      );
    } else if (widget is Column) {
      return Column(
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        children: children,
      );
    } else if (widget is Wrap) {
      return Wrap(
        runSpacing: widget.runSpacing,
        alignment: widget.alignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        children: children,
      );
    } else if (widget is Card) {
      // [CARD SPECIAL HANDLING]
      // Process the content of the Card recursively
      return _buildCardSkeleton(widget, baseColor);
    }

    // [GENERIC FLEX] For other types of Flex
    final Flex flexWidget = widget as Flex;
    return Flex(
      direction: flexWidget.direction,
      mainAxisSize: flexWidget.mainAxisSize,
      mainAxisAlignment: flexWidget.mainAxisAlignment,
      crossAxisAlignment: flexWidget.crossAxisAlignment,
      textDirection: flexWidget.textDirection,
      verticalDirection: flexWidget.verticalDirection,
      textBaseline: flexWidget.textBaseline,
      children: children,
    );
  }

  /// [CARD SPECIAL HANDLING]
  /// Process the content of a Card recursively,
  /// preserving all properties of the original Card
  static Widget _buildCardSkeleton(Card widget, Color baseColor) {
    Widget? processedChild;

    if (widget.child != null) {
      // Process the content of the Card recursively
      processedChild = buildSkeleton(widget.child!, baseColor);
    } else {
      // If there's no content, create a placeholder
      processedChild = _buildDefaultSkeleton(baseColor);
    }

    // Return a Card with all original properties
    // but with the processed content as skeleton
    return Card(
      key: widget.key,
      color: widget.color,
      shadowColor: widget.shadowColor,
      surfaceTintColor: widget.surfaceTintColor,
      elevation: widget.elevation,
      shape: widget.shape,
      borderOnForeground: widget.borderOnForeground,
      margin: widget.margin,
      clipBehavior: widget.clipBehavior,
      child: processedChild,
    );
  }

  /// [DEFAULT SKELETON] Fallback for widgets without a specific provider
  static Widget _buildDefaultSkeleton(Color baseColor) {
    return DefaultSkeleton(baseColor: baseColor, width: 100, height: 40);
  }

  /// [CLEANUP UTILITY] Cleans the cache when necessary
  static void clearCache() {
    _skeletonCache.clear();
  }

  /// [REGISTRATION UTILITY] Allows dynamic addition of providers
  static void registerProvider(SkeletonProvider provider) {
    _providers?.add(provider);
    _providers?.sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// [DEBUG INFO] Provides statistics about the registry
  static Map<String, dynamic> getDebugInfo() {
    return {
      'cached_skeletons': _skeletonCache.length,
      'registered_providers': _getProviders().length,
      'provider_types':
          _getProviders().map((p) => p.runtimeType.toString()).toList(),
    };
  }
}
