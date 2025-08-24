import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class BuilderPatternExample extends StatelessWidget {
  const BuilderPatternExample({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Builder Pattern (API Mejorada)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SkeletonLoaderBuilder()
            .child(
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Contenido con Builder Pattern'),
                  ],
                ),
              ),
            )
            .loading(isLoading)
            .fastAnimation() // [TEMA PREDEFINIDO] Animación rápida
            .build(),
      ],
    );
  }
}
