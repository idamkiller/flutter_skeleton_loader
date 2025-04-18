import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/checkbox_skeleton.dart';

void main() {
  group('CheckboxSkeleton', () {
    testWidgets('debería renderizar con los valores por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CheckboxSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, 36);
      expect(constraints?.maxHeight, 36);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });

    testWidgets('debería renderizar con dimensiones personalizadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 48.0;
      const height = 48.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CheckboxSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, width);
      expect(constraints?.maxHeight, height);
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CheckboxSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería mantener el radio de borde fijo en 4', (tester) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CheckboxSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });
  });
}
