import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/list_skeleton.dart';

void main() {
  group('ListSkeleton', () {
    testWidgets('debería renderizar con los valores por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ListSkeleton(baseColor: baseColor))),
      );

      final List<Container> containers = [];

      for (var i = 0; i < 2; i++) {
        final container = tester.widget<Container>(
          find.byKey(Key('list_skeleton_container_$i')),
        );
        containers.add(container);
      }

      for (var i = 0; i < containers.length; i++) {
        final container = containers.elementAt(i);
        final constraints = container.constraints;
        expect(constraints?.maxHeight, 60);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
      }

      final List<Padding> paddings = [];

      for (var i = 0; i < 2; i++) {
        final padding = tester.widget<Padding>(
          find.byKey(Key('list_skeleton_padding_$i')),
        );
        paddings.add(padding);
      }

      for (var i = 0; i < paddings.length; i++) {
        final padding = paddings.elementAt(i);
        expect(padding.padding, const EdgeInsets.only(bottom: 8));
      }
    });

    testWidgets('debería renderizar con valores personalizados', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const itemCount = 5;
      const itemHeight = 80.0;
      const itemSpacing = 16.0;
      const itemBorderRadius = 12.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListSkeleton(
              baseColor: baseColor,
              itemCount: itemCount,
              itemHeight: itemHeight,
              itemSpacing: itemSpacing,
              itemBorderRadius: itemBorderRadius,
            ),
          ),
        ),
      );

      // Buscar los contenedores dentro del ListSkeleton
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(ListSkeleton),
          matching: find.byType(Container),
        ),
      );

      expect(containers.length, itemCount);

      for (final container in containers) {
        final constraints = container.constraints;
        expect(constraints?.maxHeight, itemHeight);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(
          decoration.borderRadius,
          BorderRadius.circular(itemBorderRadius),
        );
      }

      // Buscar los paddings dentro del ListSkeleton
      final List<Padding> paddings = [];

      for (var i = 0; i < itemCount; i++) {
        final padding = tester.widget<Padding>(
          find.byKey(Key('list_skeleton_padding_$i')),
        );
        paddings.add(padding);
      }

      expect(paddings.length, itemCount);

      for (var i = 0; i < paddings.length; i++) {
        final padding = paddings.elementAt(i);
        if (i < itemCount - 1) {
          expect(padding.padding, EdgeInsets.only(bottom: itemSpacing));
        } else {
          expect(padding.padding, EdgeInsets.zero);
        }
      }
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ListSkeleton(baseColor: baseColor))),
      );

      // Buscar los contenedores dentro del ListSkeleton
      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(ListSkeleton),
          matching: find.byType(Container),
        ),
      );

      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
      }
    });
  });
}
