import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_field_skeleton.dart';

void main() {
  group('TextFieldSkeleton', () {
    testWidgets('debería renderizar con las dimensiones por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFieldSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final constraints = container.constraints;
      expect(constraints?.maxWidth, double.infinity); // width es opcional
      expect(constraints?.maxHeight, 48); // altura por defecto

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(8),
      ); // borderRadius por defecto
    });

    testWidgets('debería renderizar con dimensiones personalizadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 200.0;
      const height = 60.0;
      const borderRadius = 12.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFieldSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final constraints = container.constraints;
      expect(constraints?.maxWidth, width);
      expect(constraints?.maxHeight, height);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(borderRadius));
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFieldSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería usar el borderRadius por defecto de 8', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFieldSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });
  });
}
