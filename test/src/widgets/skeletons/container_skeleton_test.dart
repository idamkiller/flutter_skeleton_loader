import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/container_skeleton.dart';

void main() {
  group('ContainerSkeleton', () {
    testWidgets('debería renderizar con dimensiones por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ContainerSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final constraints = container.constraints;
      expect(constraints?.maxWidth, null);
      expect(constraints?.maxHeight, null);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('debería renderizar con dimensiones personalizadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 200.0;
      const height = 100.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContainerSkeleton(
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
          home: Scaffold(body: ContainerSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería tener un borderRadius de 8', (tester) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ContainerSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });
  });
}
