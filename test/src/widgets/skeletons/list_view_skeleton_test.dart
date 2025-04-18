import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/list_view_skeleton.dart';

void main() {
  group('ListViewSkeleton', () {
    testWidgets('debería renderizar con el número correcto de elementos', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const itemCount = 3;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      // Verificar que hay 3 contenedores (uno por elemento)
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Container),
        ),
      );
      expect(containers.length, itemCount);

      // Verificar las propiedades de cada contenedor
      for (final container in containers) {
        final constraints = container.constraints;
        expect(constraints?.maxHeight, 72);

        expect(
          container.margin,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }
    });

    testWidgets(
      'debería renderizar con dirección de desplazamiento horizontal',
      (tester) async {
        const baseColor = Colors.grey;
        const itemCount = 2;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListViewSkeleton(
                baseColor: baseColor,
                itemCount: itemCount,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.scrollDirection, Axis.horizontal);
      },
    );

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      const itemCount = 2;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
      }
    });

    testWidgets('debería tener un borderRadius de 8', (tester) async {
      const baseColor = Colors.grey;
      const itemCount = 2;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }
    });

    testWidgets('debería tener márgenes horizontales de 16 y verticales de 8', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const itemCount = 2;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        expect(
          container.margin,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );
      }
    });
  });
}
