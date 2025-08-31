import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class DropdownExample extends StatelessWidget {
  final bool isLoading;
  const DropdownExample({super.key, required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          '6. Ejemplo de Dropdown',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SkeletonLoaderBuilder.light(
          isLoading: isLoading,
          child: Wrap(
            children: [
              DropdownButton<String>(
                hint: const Text('Selecciona una opción'),
                items:
                    <String>['Uno', 'Dos', 'Tres'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {},
              ),
              SizedBox(width: 16.0),
              DropdownButton<bool>(
                value: true,
                items:
                    <bool>[true, false].map((bool value) {
                      return DropdownMenuItem<bool>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                onChanged: (bool? newValue) {},
              ),
              Slider(value: 0.5, onChanged: (double newValue) {}),
            ],
          ),
        ),
      ],
    );
  }
}
