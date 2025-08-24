import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/skeleton_loader.dart';

class BasicExample extends StatelessWidget {
  final bool isLoading;
  const BasicExample({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Ejemplo Básico',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SkeletonLoader(
          isLoading: isLoading,
          child: const Text('Texto corto', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 8),
        SkeletonLoader(
          isLoading: isLoading,
          child: const Text(
            'Este es un texto que aparece cuando la carga termina. '
            'El skeleton loader creará automáticamente una representación '
            'visual basada en el contenido.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
