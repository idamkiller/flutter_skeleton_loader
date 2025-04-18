import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/sized_box_skeleton.dart';

void main() {
  group('SizedBoxSkeleton', () {
    testWidgets('debería renderizar con las dimensiones especificadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 100.0;
      const height = 50.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBoxSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
              isEmpty: false,
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
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('debería renderizar sin decoración cuando isEmpty es true', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 100.0;
      const height = 50.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBoxSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
              isEmpty: true,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final constraints = container.constraints;
      expect(constraints?.maxWidth, width);
      expect(constraints?.maxHeight, height);
      expect(container.decoration, null);
    });

    testWidgets(
      'debería aplicar el color base correctamente cuando no está vacío',
      (tester) async {
        const baseColor = Colors.blue;
        const width = 100.0;
        const height = 50.0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBoxSkeleton(
                baseColor: baseColor,
                width: width,
                height: height,
                isEmpty: false,
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
      },
    );

    testWidgets('debería tener un borderRadius de 8 cuando no está vacío', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 100.0;
      const height = 50.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBoxSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
              isEmpty: false,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });
  });
}
