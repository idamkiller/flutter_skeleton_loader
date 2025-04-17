import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/card_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/checkbox_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/circle_avatar_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/dropdown_button_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/icon_button_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/icon_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/radio_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/sized_box_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/slider_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_field_skeleton.dart';
import '../utils/widget_utils.dart';
import 'skeletons/skeletons.dart';

class SkeletonBuilder {
  final Color baseColor;

  const SkeletonBuilder({required this.baseColor});

  Widget buildSkeleton(Widget originalWidget) {
    if (originalWidget is Text) {
      return TextSkeleton(baseColor: baseColor, text: originalWidget.data);
    } else if (originalWidget is Image) {
      return ImageSkeleton(
        baseColor: baseColor,
        width: originalWidget.width,
        height: originalWidget.height,
      );
    } else if (originalWidget is Container) {
      return ContainerSkeleton(
        baseColor: baseColor,
        width: originalWidget.constraints?.maxWidth,
        height: originalWidget.constraints?.maxHeight,
      );
    } else if (originalWidget is SizedBox) {
      return SizedBoxSkeleton(
        baseColor: baseColor,
        width: originalWidget.width ?? 100,
        height: originalWidget.height ?? 10,
      );
    } else if (originalWidget is Card) {
      return CardSkeleton(
        baseColor: baseColor,
        width: originalWidget.child != null ? 100 : 0,
        height: originalWidget.child != null ? 100 : 0,
      );
    } else if (originalWidget is IconButton) {
      return IconButtonSkeleton(
        baseColor: baseColor,
        width: originalWidget.iconSize ?? 24,
        height: originalWidget.iconSize ?? 24,
      );
    } else if (originalWidget is Icon) {
      return IconSkeleton(
        baseColor: baseColor,
        size: originalWidget.size ?? 24,
      );
    } else if (originalWidget is CircleAvatar) {
      return CircleAvatarSkeleton(
        baseColor: baseColor,
        radius: originalWidget.radius != null ? originalWidget.radius! * 2 : 40,
      );
    } else if (originalWidget is ListTile) {
      return ListTileSkeleton(
        baseColor: baseColor,
        showLeading: originalWidget.leading != null,
        showTrailing: originalWidget.trailing != null,
      );
    } else if (originalWidget is ListView) {
      return ListViewSkeleton(
        baseColor: baseColor,
        scrollDirection: originalWidget.scrollDirection,
        itemCount: WidgetUtils.getItemCount(originalWidget),
      );
    } else if (originalWidget is PageView) {
      return PageViewSkeleton(
        baseColor: baseColor,
        itemCount: WidgetUtils.getItemCount(originalWidget),
      );
    } else if (originalWidget is Form) {
      return buildSkeleton(originalWidget.child);
    } else if (originalWidget is TextField || originalWidget is TextFormField) {
      return TextFieldSkeleton(baseColor: baseColor, height: 48);
    } else if (originalWidget is Checkbox || originalWidget is Switch) {
      return CheckboxSkeleton(baseColor: baseColor, width: 36, height: 36);
    } else if (originalWidget is Radio) {
      return RadioSkeleton(baseColor: baseColor, width: 20, height: 20);
    } else if (originalWidget is DropdownButton ||
        originalWidget is PopupMenuButton) {
      return DropdownButtonSkeleton(
        baseColor: baseColor,
        height: 48,
        width: 160,
      );
    } else if (originalWidget is Slider) {
      return SliderSkeleton(baseColor: baseColor, height: 20);
    } else if (originalWidget is Row ||
        originalWidget is Column ||
        originalWidget is Wrap ||
        originalWidget is Flex) {
      return _buildMultiChildSkeleton(originalWidget);
    }

    return _buildDefaultSkeleton();
  }

  Widget _buildMultiChildSkeleton(Widget widget) {
    final List<Widget> children = [];
    if (widget is MultiChildRenderObjectWidget) {
      for (final child in widget.children) {
        children.add(buildSkeleton(child));
      }
    }

    if (widget is Row) {
      return Row(
        key: widget.key,
        spacing: widget.spacing,
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
        key: widget.key,
        spacing: widget.spacing,
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
        key: widget.key,
        spacing: widget.spacing,
        runSpacing: widget.runSpacing,
        alignment: widget.alignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        children: children,
      );
    } else if (widget is Flex) {
      return Flex(
        key: widget.key,
        direction: widget.direction,
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        children: children,
      );
    }

    return _buildDefaultSkeleton();
  }

  Widget _buildDefaultSkeleton() {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
