import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/src/utils/widget_utils.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/default_skeleton.dart';
import '../widgets/skeletons/skeletons.dart';

typedef SkeletonBuilder = Widget Function(Widget widget, Color baseColor);

class SkeletonRegistry {
  static final Map<Type, SkeletonBuilder> _registry = {
    Text: (widget, baseColor) =>
        TextSkeleton(baseColor: baseColor, text: (widget as Text).data),
    Image: (widget, baseColor) => ImageSkeleton(
          baseColor: baseColor,
          width: (widget as Image).width ?? 100,
          height: widget.height ?? 100,
        ),
    Container: (widget, baseColor) => ContainerSkeleton(
          baseColor: baseColor,
          width: (widget as Container).constraints?.maxWidth,
          height: widget.constraints?.maxHeight,
        ),
    SizedBox: (widget, baseColor) => SizedBoxSkeleton(
          baseColor: baseColor,
          width: (widget as SizedBox).width ?? 100,
          height: widget.height ?? 10,
          isEmpty: widget.child == null,
        ),
    IconButton: (widget, baseColor) => IconButtonSkeleton(
          baseColor: baseColor,
          width: (widget as IconButton).iconSize ?? 24,
          height: widget.iconSize ?? 24,
        ),
    Icon: (widget, baseColor) => IconSkeleton(
          baseColor: baseColor,
          size: (widget as Icon).size ?? 24,
        ),
    CircleAvatar: (widget, baseColor) => CircleAvatarSkeleton(
          baseColor: baseColor,
          radius:
              (widget as CircleAvatar).radius != null ? widget.radius! * 2 : 40,
        ),
    ListTile: (widget, baseColor) => ListTileSkeleton(
          baseColor: baseColor,
          showLeading: (widget as ListTile).leading != null,
          showTrailing: widget.trailing != null,
        ),
    ListView: (widget, baseColor) => ListViewSkeleton(
          baseColor: baseColor,
          scrollDirection: (widget as ListView).scrollDirection,
          itemCount: WidgetUtils.getItemCount(widget),
        ),
    PageView: (widget, baseColor) => PageViewSkeleton(
          baseColor: baseColor,
          itemCount: WidgetUtils.getItemCount(widget),
        ),
    TextField: (widget, baseColor) =>
        TextFieldSkeleton(baseColor: baseColor, height: 48),
    TextFormField: (widget, baseColor) =>
        TextFieldSkeleton(baseColor: baseColor, height: 48),
    Checkbox: (widget, baseColor) =>
        CheckboxSkeleton(baseColor: baseColor, width: 36, height: 36),
    Switch: (widget, baseColor) =>
        CheckboxSkeleton(baseColor: baseColor, width: 36, height: 36),
    Radio<int>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<String>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<bool>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<double>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<Color>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<DateTime>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<Duration>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<Enum>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    Radio<void>: (widget, baseColor) =>
        RadioSkeleton(baseColor: baseColor, width: 20, height: 20),
    DropdownButton<int>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    DropdownButton<String>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    DropdownButton<bool>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    DropdownButton<double>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    DropdownButton<Color>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    DropdownButton<Duration>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<int>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<String>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<bool>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<double>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<Color>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<DateTime>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<Duration>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    PopupMenuButton<void>: (widget, baseColor) => DropdownButtonSkeleton(
          baseColor: baseColor,
          height: 48,
          width: 160,
        ),
    Slider: (widget, baseColor) =>
        SliderSkeleton(baseColor: baseColor, height: 20),
  };

  static Widget buildSkeleton(Widget widget, Color baseColor) {
    if (widget is SizedBox && widget.child != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: buildSkeleton(widget.child!, baseColor),
      );
    }

    if (widget is Expanded) {
      return Expanded(
        flex: widget.flex,
        child: buildSkeleton(widget.child, baseColor),
      );
    }

    if (widget is Flexible) {
      return Flexible(
        flex: widget.flex,
        fit: widget.fit,
        child: buildSkeleton(widget.child, baseColor),
      );
    }

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

    final builder = _registry[widget.runtimeType];
    if (builder != null) {
      return builder(widget, baseColor);
    }

    if (widget is GestureDetector) {
      final child = widget.child;
      return child != null
          ? buildSkeleton(child, baseColor)
          : _buildDefaultSkeleton(baseColor);
    }

    if (widget is Form) {
      return buildSkeleton(widget.child, baseColor);
    }

    if (widget is Row ||
        widget is Column ||
        widget is Wrap ||
        widget is Flex ||
        widget is Card) {
      return _buildMultiChildSkeleton(widget, baseColor);
    }

    return _buildDefaultSkeleton(baseColor);
  }

  static Widget _buildMultiChildSkeleton(Widget widget, Color baseColor) {
    final List<Widget> children = [];

    try {
      if (widget is MultiChildRenderObjectWidget) {
        for (final child in widget.children) {
          children.add(buildSkeleton(child, baseColor));
        }
      }

      if (widget is Row) {
        return IntrinsicHeight(
          child: Row(
            mainAxisSize: widget.mainAxisSize,
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            textDirection: widget.textDirection,
            verticalDirection: widget.verticalDirection,
            textBaseline: widget.textBaseline,
            children: children,
          ),
        );
      } else if (widget is Column) {
        return IntrinsicWidth(
          child: Column(
            mainAxisSize: widget.mainAxisSize,
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            textDirection: widget.textDirection,
            verticalDirection: widget.verticalDirection,
            textBaseline: widget.textBaseline,
            children: children,
          ),
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
        return _buildCardSkeleton(widget, baseColor);
      }

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
    } catch (e) {
      return _buildDefaultSkeleton(baseColor);
    }
  }

  static Widget _buildCardSkeleton(Card widget, Color baseColor) {
    Widget? processedChild;

    if (widget.child != null) {
      processedChild = buildSkeleton(widget.child!, baseColor);
    } else {
      processedChild = _buildDefaultSkeleton(baseColor);
    }

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

  static Widget _buildDefaultSkeleton(Color baseColor) {
    return DefaultSkeleton(baseColor: baseColor, width: 100, height: 40);
  }
}
