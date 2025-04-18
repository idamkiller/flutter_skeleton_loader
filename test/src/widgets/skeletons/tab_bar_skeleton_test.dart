import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/tab_bar_skeleton.dart';

void main() {
  group('TabBarSkeleton', () {
    testWidgets('debería renderizar con los valores por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TabBarSkeleton(baseColor: baseColor))),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TabBarSkeleton),
          matching: find.byType(Container),
        ),
      );
      expect(containers.length, 3);

      for (final container in containers) {
        final constraints = container.constraints;
        expect(constraints?.maxWidth, 80);
        expect(constraints?.maxHeight, 48);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 48);
    });

    testWidgets('debería renderizar con valores personalizados', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const tabCount = 5;
      const height = 60.0;
      const tabWidth = 100.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TabBarSkeleton(
              baseColor: baseColor,
              tabCount: tabCount,
              height: height,
              tabWidth: tabWidth,
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TabBarSkeleton),
          matching: find.byType(Container),
        ),
      );
      expect(containers.length, tabCount);

      for (final container in containers) {
        final constraints = container.constraints;
        expect(constraints?.maxWidth, tabWidth);
        expect(constraints?.maxHeight, height);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, height);
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TabBarSkeleton(baseColor: baseColor))),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TabBarSkeleton),
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
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TabBarSkeleton(baseColor: baseColor))),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TabBarSkeleton),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }
    });
  });
}
