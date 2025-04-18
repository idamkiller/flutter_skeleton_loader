import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/card_skeleton.dart';

void main() {
  group('CardSkeleton', () {
    testWidgets('debería renderizar con los valores por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CardSkeleton(baseColor: baseColor))),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final constraints = container.constraints;
      expect(constraints?.maxWidth, double.infinity);
      expect(constraints?.maxHeight, 200);
      expect(container.padding, const EdgeInsets.all(16));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('debería renderizar con dimensiones personalizadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 300.0;
      const height = 150.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardSkeleton(
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
      const borderRadius = 20.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardSkeleton(
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

    testWidgets('debería renderizar con un padding personalizado', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const padding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardSkeleton(baseColor: baseColor, padding: padding),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      expect(container.padding, padding);
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CardSkeleton(baseColor: baseColor))),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });
  });
}
