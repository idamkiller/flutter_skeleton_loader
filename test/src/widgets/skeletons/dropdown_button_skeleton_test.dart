import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/dropdown_button_skeleton.dart';

void main() {
  group('DropdownButtonSkeleton', () {
    testWidgets('debería renderizar con las dimensiones especificadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 160.0;
      const height = 48.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownButtonSkeleton(
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

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      const width = 160.0;
      const height = 48.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownButtonSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería tener un borderRadius de 8', (tester) async {
      const baseColor = Colors.grey;
      const width = 160.0;
      const height = 48.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownButtonSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
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
