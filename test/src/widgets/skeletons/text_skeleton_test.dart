import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_skeleton.dart';

void main() {
  group('TextSkeleton', () {
    testWidgets(
      'debería renderizar con el ancho calculado basado en el texto',
      (tester) async {
        const baseColor = Colors.grey;
        const text = 'Hola Mundo';
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextSkeleton(baseColor: baseColor, text: text),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));

        final constraints = container.constraints;
        expect(constraints?.maxWidth, text.length * 10.0);
        expect(constraints?.maxHeight, 20);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(4));
      },
    );

    testWidgets('debería usar un ancho por defecto cuando el texto es null', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TextSkeleton(baseColor: baseColor))),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final constraints = container.constraints;
      expect(constraints?.maxWidth, 100.0); // 10 caracteres por defecto * 10.0
      expect(constraints?.maxHeight, 20);
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      const text = 'Hola Mundo';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextSkeleton(baseColor: baseColor, text: text)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería tener un borderRadius de 4', (tester) async {
      const baseColor = Colors.grey;
      const text = 'Hola Mundo';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextSkeleton(baseColor: baseColor, text: text)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });
  });
}
