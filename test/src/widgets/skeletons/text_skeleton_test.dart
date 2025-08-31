import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_skeleton.dart';

void main() {
  group('TextSkeleton', () {
    testWidgets(
      'debería renderizar con texto cuando se proporciona texto',
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

        expect(find.text(text), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(4));

        expect(container.constraints, isNull);
      },
    );

    testWidgets('debería usar dimensiones específicas cuando el texto es null',
        (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TextSkeleton(baseColor: baseColor))),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      expect(find.byType(Text), findsNothing);

      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, 100.0);
      expect(containerSize.height, 20);
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

    testWidgets('debería manejar texto vacío como null', (tester) async {
      const baseColor = Colors.grey;
      const text = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextSkeleton(baseColor: baseColor, text: text)),
        ),
      );

      expect(find.byType(Text), findsNothing);

      final containerSize = tester.getSize(find.byType(Container));
      expect(containerSize.width, 0.0);
      expect(containerSize.height, 20);
    });

    testWidgets(
        'debería calcular el ancho basado en la longitud del texto cuando no hay texto',
        (tester) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TextSkeleton(baseColor: baseColor))),
      );

      final containerSize = tester.getSize(find.byType(Container));
      expect(containerSize.width, 100.0);
      expect(containerSize.height, 20);
    });

    testWidgets(
        'debería aplicar el estilo correcto al texto cuando está presente',
        (tester) async {
      const baseColor = Colors.blue;
      const text = 'Test Text';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextSkeleton(baseColor: baseColor, text: text)),
        ),
      );

      final textWidget = tester.widget<Text>(find.text(text));
      expect(textWidget.style?.color, baseColor);
    });

    testWidgets('debería heredar propiedades de BaseSkeleton', (tester) async {
      const baseColor = Colors.red;
      const textSkeleton = TextSkeleton(baseColor: baseColor);

      expect(textSkeleton.baseColor, baseColor);
    });

    testWidgets(
        'debería renderizar correctamente con diferentes longitudes de texto',
        (tester) async {
      const baseColor = Colors.grey;

      const shortText = 'Hi';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: TextSkeleton(baseColor: baseColor, text: shortText)),
        ),
      );

      expect(find.text(shortText), findsOneWidget);

      const longText = 'Este es un texto mucho más largo para probar';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: TextSkeleton(baseColor: baseColor, text: longText)),
        ),
      );

      expect(find.text(longText), findsOneWidget);
    });

    testWidgets(
        'debería tener decoración consistente independientemente del texto',
        (tester) async {
      const baseColor = Colors.purple;

      await tester.pumpWidget(
        MaterialApp(
          home:
              Scaffold(body: TextSkeleton(baseColor: baseColor, text: 'Text')),
        ),
      );

      var container = tester.widget<Container>(find.byType(Container));
      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(4));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextSkeleton(baseColor: baseColor)),
        ),
      );

      container = tester.widget<Container>(find.byType(Container));
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });

    testWidgets('debería manejar caracteres especiales en el texto',
        (tester) async {
      const baseColor = Colors.grey;
      const text = 'Héllo Wørld! 123 @#\$%';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextSkeleton(baseColor: baseColor, text: text)),
        ),
      );

      expect(find.text(text), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería ser inmutable', (tester) async {
      const baseColor = Colors.grey;
      const text = 'Test';
      const skeleton1 = TextSkeleton(baseColor: baseColor, text: text);
      const skeleton2 = TextSkeleton(baseColor: baseColor, text: text);

      expect(skeleton1.baseColor, equals(skeleton2.baseColor));
      expect(skeleton1.text, equals(skeleton2.text));
    });
  });
}
