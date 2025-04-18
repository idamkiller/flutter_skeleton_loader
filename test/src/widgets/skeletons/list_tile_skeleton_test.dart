import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/list_tile_skeleton.dart';

void main() {
  group('ListTileSkeleton', () {
    testWidgets('debería renderizar con todos los elementos por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ListTileSkeleton(baseColor: baseColor)),
        ),
      );

      // Verificar el contenedor principal
      final mainContainer = tester.widget<Container>(
        find.ancestor(of: find.byType(Row), matching: find.byType(Container)),
      );
      expect(mainContainer.constraints?.maxHeight, 72);
      expect(
        mainContainer.padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );

      // Verificar el elemento leading (círculo)
      final leadingContainer = tester.widget<Container>(
        find.byKey(const Key('list_tile_skeleton_leading')),
      );
      expect(leadingContainer.constraints?.maxWidth, 40);
      expect(leadingContainer.constraints?.maxHeight, 40);
      final leadingDecoration = leadingContainer.decoration as BoxDecoration;
      expect(leadingDecoration.color, baseColor);
      expect(leadingDecoration.shape, BoxShape.circle);

      // Verificar el título
      final titleContainer = tester.widget<Container>(
        find.byKey(const Key('list_tile_skeleton_title')),
      );
      expect(titleContainer.constraints?.maxWidth, 200);
      expect(titleContainer.constraints?.maxHeight, 16);
      final titleDecoration = titleContainer.decoration as BoxDecoration;
      expect(titleDecoration.color, baseColor);
      expect(titleDecoration.borderRadius, BorderRadius.circular(4));

      // Verificar el subtítulo
      final subtitleContainer = tester.widget<Container>(
        find.byKey(const Key('list_tile_skeleton_subtitle')),
      );
      expect(subtitleContainer.constraints?.maxWidth, 150);
      expect(subtitleContainer.constraints?.maxHeight, 14);
      final subtitleDecoration = subtitleContainer.decoration as BoxDecoration;
      expect(subtitleDecoration.color, baseColor);
      expect(subtitleDecoration.borderRadius, BorderRadius.circular(4));

      // Verificar el elemento trailing
      final trailingContainer = tester.widget<Container>(
        find.byKey(const Key('list_tile_skeleton_trailing')),
      );
      expect(trailingContainer.constraints?.maxWidth, 24);
      expect(trailingContainer.constraints?.maxHeight, 24);
      final trailingDecoration = trailingContainer.decoration as BoxDecoration;
      expect(trailingDecoration.color, baseColor);
      expect(trailingDecoration.borderRadius, BorderRadius.circular(4));
    });

    testWidgets(
      'debería renderizar sin elemento leading cuando showLeading es false',
      (tester) async {
        const baseColor = Colors.grey;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListTileSkeleton(baseColor: baseColor, showLeading: false),
            ),
          ),
        );

        // Verificar que no hay elemento leading
        expect(
          find.byType(Container).evaluate().length,
          4,
        ); // Solo el contenedor principal, título, subtítulo y trailing
      },
    );

    testWidgets(
      'debería renderizar sin elemento trailing cuando showTrailing es false',
      (tester) async {
        const baseColor = Colors.grey;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListTileSkeleton(baseColor: baseColor, showTrailing: false),
            ),
          ),
        );

        // Verificar que no hay elemento trailing
        expect(
          find.byType(Container).evaluate().length,
          4,
        ); // Solo el contenedor principal, leading, título y subtítulo
      },
    );

    testWidgets(
      'debería aplicar el color base correctamente a todos los elementos',
      (tester) async {
        const baseColor = Colors.blue;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ListTileSkeleton(baseColor: baseColor)),
          ),
        );

        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(Row),
            matching: find.byType(Container),
          ),
        );

        for (final container in containers) {
          if (container.decoration != null) {
            final decoration = container.decoration as BoxDecoration;
            expect(decoration.color, baseColor);
          }
        }
      },
    );
  });
}
