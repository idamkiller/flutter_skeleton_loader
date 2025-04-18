import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/button_skeleton.dart';

void main() {
  group('ButtonSkeleton', () {
    testWidgets('debería renderizar con los valores por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ButtonSkeleton(baseColor: baseColor))),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, 120);
      expect(constraints?.maxHeight, 40);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('debería renderizar con dimensiones personalizadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 200.0;
      const height = 60.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonSkeleton(
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

    testWidgets('debería renderizar con un radio de borde personalizado', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const borderRadius = 16.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonSkeleton(
              baseColor: baseColor,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(borderRadius));
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ButtonSkeleton(baseColor: baseColor))),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });
  });
}
