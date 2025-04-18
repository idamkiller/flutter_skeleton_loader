import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/avatar_skeleton.dart';

void main() {
  group('AvatarSkeleton', () {
    testWidgets('debería renderizar con el tamaño por defecto', (tester) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AvatarSkeleton(baseColor: baseColor))),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, 40);
      expect(constraints?.maxHeight, 40);
    });

    testWidgets('debería renderizar con un tamaño personalizado', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const size = 60.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarSkeleton(baseColor: baseColor, size: size),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, size);
      expect(constraints?.maxHeight, size);
    });

    testWidgets('debería renderizar como circular por defecto', (tester) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AvatarSkeleton(baseColor: baseColor))),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration
              as BoxDecoration;

      expect(decoration.shape, BoxShape.circle);
      expect(decoration.borderRadius, null);
    });

    testWidgets(
      'debería renderizar como rectangular cuando isCircular es false',
      (tester) async {
        const baseColor = Colors.grey;
        const size = 40.0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AvatarSkeleton(
                baseColor: baseColor,
                size: size,
                isCircular: false,
              ),
            ),
          ),
        );

        final decoration =
            tester.widget<Container>(find.byType(Container)).decoration
                as BoxDecoration;

        expect(decoration.shape, BoxShape.rectangle);
        expect(decoration.borderRadius, BorderRadius.circular(size / 4));
      },
    );

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AvatarSkeleton(baseColor: baseColor))),
      );

      final decoration =
          tester.widget<Container>(find.byType(Container)).decoration
              as BoxDecoration;

      expect(decoration.color, baseColor);
    });
  });
}
