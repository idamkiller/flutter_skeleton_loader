import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/page_view_skeleton.dart';

void main() {
  group('PageViewSkeleton', () {
    testWidgets('debería renderizar con el número correcto de páginas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const itemCount = 3;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(PageView),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        expect(container.margin, const EdgeInsets.all(16));

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      const itemCount = 2;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(PageView),
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
            body: PageViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(PageView),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }
    });

    testWidgets('debería tener un margen de 16 en todos los lados', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const itemCount = 2;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageViewSkeleton(baseColor: baseColor, itemCount: itemCount),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(PageView),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        expect(container.margin, const EdgeInsets.all(16));
      }
    });
  });
}
