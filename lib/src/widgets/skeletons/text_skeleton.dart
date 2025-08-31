import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class TextSkeleton extends BaseSkeleton {
  final String? text;

  const TextSkeleton({super.key, required super.baseColor, this.text});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: baseColor,
      borderRadius: BorderRadius.circular(4),
    );
    if (text != null && text!.isNotEmpty) {
      return Container(
        decoration: decoration,
        child: Text(
          text ?? '',
          style: TextStyle(
            color: baseColor,
          ),
        ),
      );
    }
    return Container(
      width: (text?.length ?? 10) * 10.0,
      height: 20,
      decoration: decoration,
    );
  }
}
