import 'package:flutter/material.dart';

abstract class BaseSkeleton extends StatelessWidget {
  final Color baseColor;

  const BaseSkeleton({super.key, required this.baseColor});
}
