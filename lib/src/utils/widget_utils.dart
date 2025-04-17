import 'package:flutter/material.dart';

class WidgetUtils {
  static int getItemCount(Widget widget) {
    if (widget is ListView) {
      if (widget.childrenDelegate is SliverChildBuilderDelegate) {
        final delegate = widget.childrenDelegate as SliverChildBuilderDelegate;
        return delegate.estimatedChildCount ?? 5;
      } else if (widget.childrenDelegate is SliverChildListDelegate) {
        final delegate = widget.childrenDelegate as SliverChildListDelegate;
        return delegate.children.length;
      }
    } else if (widget is PageView) {
      if (widget.childrenDelegate is SliverChildBuilderDelegate) {
        final delegate = widget.childrenDelegate as SliverChildBuilderDelegate;
        return delegate.estimatedChildCount ?? 3;
      } else if (widget.childrenDelegate is SliverChildListDelegate) {
        final delegate = widget.childrenDelegate as SliverChildListDelegate;
        return delegate.children.length;
      }
    } else if (widget is Column || widget is Row || widget is Wrap) {
      if (widget is MultiChildRenderObjectWidget) {
        return widget.children.length;
      }
    }
    return 5;
  }
}
