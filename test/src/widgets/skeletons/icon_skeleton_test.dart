import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/icon_skeleton.dart';

void main() {
  group('IconSkeleton', () {
    testWidgets('debería renderizar con el tamaño especificado', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const size = 24.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: IconSkeleton(baseColor: baseColor, size: size)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final constraints = container.constraints;
      expect(constraints?.maxWidth, size);
      expect(constraints?.maxHeight, size);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      const size = 24.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: IconSkeleton(baseColor: baseColor, size: size)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería tener un shape circular', (tester) async {
      const baseColor = Colors.grey;
      const size = 24.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: IconSkeleton(baseColor: baseColor, size: size)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });
  });
}
