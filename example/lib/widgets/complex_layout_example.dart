import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/skeleton_loader.dart';

class ComplexLayoutExample extends StatelessWidget {
  final bool isLoading;
  const ComplexLayoutExample({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Layout Complejo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SkeletonLoader(
          isLoading: isLoading,
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 25, child: Icon(Icons.person)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Usuario Ejemplo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'usuario@ejemplo.com',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('Contenido Principal')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
