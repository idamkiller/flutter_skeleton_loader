import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

void main() {
  group('MyApp', () {
    testWidgets('debería construir la aplicación correctamente', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(MyHomePage), findsOneWidget);
    });
  });

  group('MyHomePage', () {
    testWidgets('debería mostrar skeletons inicialmente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(delay: Duration.zero)),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byKey(const Key('text_example')), findsNothing);
      expect(find.byKey(const Key('image_example')), findsNothing);
      expect(find.byKey(const Key('container_example')), findsNothing);
      expect(find.byKey(const Key('icon_example')), findsNothing);
      expect(find.byKey(const Key('button_example')), findsNothing);
      expect(find.byKey(const Key('avatar_example')), findsNothing);
      expect(find.byKey(const Key('checkbox_example')), findsNothing);
      expect(find.byKey(const Key('radio_example')), findsNothing);
      expect(find.byKey(const Key('switch_example')), findsNothing);
      expect(find.byKey(const Key('slider_example')), findsNothing);
      expect(find.byKey(const Key('dropdown_example')), findsNothing);

      // Avanzar 2 segundos
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('debería mostrar el contenido real después de 2 segundos', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage()));

      // Verificar que los skeletons están presentes inicialmente
      expect(find.byType(SkeletonLoader), findsOneWidget);

      // Avanzar 2 segundos
      await tester.pump(const Duration(seconds: 2));

      // Verificar que los skeletons están presentes
      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byKey(const Key('text_example')), findsOneWidget);
      expect(find.byKey(const Key('image_example')), findsOneWidget);
      expect(find.byKey(const Key('container_example')), findsOneWidget);
      expect(find.byKey(const Key('icon_example')), findsOneWidget);
      expect(find.byKey(const Key('button_example')), findsOneWidget);
      expect(find.byKey(const Key('avatar_example')), findsOneWidget);
      expect(find.byKey(const Key('checkbox_example')), findsOneWidget);
      expect(find.byKey(const Key('radio_example')), findsOneWidget);
      expect(find.byKey(const Key('switch_example')), findsOneWidget);
      expect(find.byKey(const Key('slider_example')), findsOneWidget);
      expect(find.byKey(const Key('dropdown_example')), findsOneWidget);
    });
  });
}
