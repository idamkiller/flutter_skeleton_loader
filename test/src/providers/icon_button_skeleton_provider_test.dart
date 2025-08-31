import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/icon_button_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/icon_button_skeleton.dart';

void main() {
  group('IconButtonSkeletonProvider', () {
    late IconButtonSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = IconButtonSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget IconButton', () {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        );

        expect(provider.canHandle(iconButtonWidget), isTrue);
      });

      test('Debería retornar true para IconButton con iconSize personalizado',
          () {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.star),
          iconSize: 32,
          onPressed: () {},
        );

        expect(provider.canHandle(iconButtonWidget), isTrue);
      });

      test(
          'Debería retornar true para IconButton con propiedades personalizadas',
          () {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.favorite),
          iconSize: 28,
          color: Colors.red,
          splashColor: Colors.pink,
          highlightColor: Colors.purple,
          focusColor: Colors.blue,
          hoverColor: Colors.orange,
          tooltip: 'Favorite',
          onPressed: () {},
        );

        expect(provider.canHandle(iconButtonWidget), isTrue);
      });

      test('Debería retornar true para IconButton deshabilitado', () {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.disabled_by_default),
          onPressed: null,
        );

        expect(provider.canHandle(iconButtonWidget), isTrue);
      });

      test('Debería retornar true para IconButton con padding y constraints',
          () {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.settings),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(
            minWidth: 60,
            minHeight: 60,
          ),
          onPressed: () {},
        );

        expect(provider.canHandle(iconButtonWidget), isTrue);
      });

      test('Debería retornar true para IconButton con alineación', () {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.align_horizontal_center),
          alignment: Alignment.topLeft,
          onPressed: () {},
        );

        expect(provider.canHandle(iconButtonWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son IconButton', () {
        const textWidget = Text('Not an icon button');
        final containerWidget = Container();
        const iconWidget = Icon(Icons.home);
        const buttonWidget =
            ElevatedButton(onPressed: null, child: Text('Button'));

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
        expect(provider.canHandle(buttonWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 7', () {
        expect(provider.priority, 7);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear IconButtonSkeleton para IconButton básico',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.baseColor, baseColor);

        expect(iconButtonSkeleton.width, 48.0);
        expect(iconButtonSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear IconButtonSkeleton con iconSize predeterminado cuando no se especifica',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.star),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.baseColor, baseColor);
        expect(iconButtonSkeleton.width, 48.0);
        expect(iconButtonSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 48.0);
        expect(size.height, 48.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear IconButtonSkeleton con iconSize personalizado',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.favorite),
          iconSize: 32,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.baseColor, baseColor);

        expect(iconButtonSkeleton.width, 56.0);
        expect(iconButtonSkeleton.height, 56.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 56.0);
        expect(size.height, 56.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear IconButtonSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.settings),
          color: Colors.red,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, customColor);
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear IconButtonSkeleton con forma circular',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.circle),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton deshabilitado', (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.disabled_by_default),
          onPressed: null,
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton con iconSize grande',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.zoom_in),
          iconSize: 48,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.width, 72.0);
        expect(iconButtonSkeleton.height, 72.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 72.0);
        expect(size.height, 72.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton con iconSize pequeño',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.zoom_out),
          iconSize: 16,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.width, 40.0);
        expect(iconButtonSkeleton.height, 40.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 40.0);
        expect(size.height, 40.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar IconButton con colores y propiedades personalizadas',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.palette),
          iconSize: 30,
          color: Colors.green,
          splashColor: Colors.yellow,
          highlightColor: Colors.orange,
          focusColor: Colors.purple,
          hoverColor: Colors.cyan,
          tooltip: 'Color Palette',
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton con padding y restricciones',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.crop),
          iconSize: 20,
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(
            minWidth: 80,
            minHeight: 80,
          ),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.width, 44.0);
        expect(iconButtonSkeleton.height, 44.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 44.0);
        expect(size.height, 44.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton con alineación', (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.align_horizontal_center),
          alignment: Alignment.topLeft,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar diferentes tipos de iconos', (tester) async {
        final testCases = [
          {'icon': Icons.home, 'iconSize': 24.0, 'expectedSize': 48.0},
          {'icon': Icons.star, 'iconSize': 20.0, 'expectedSize': 44.0},
          {'icon': Icons.favorite, 'iconSize': 36.0, 'expectedSize': 60.0},
          {'icon': Icons.settings, 'iconSize': 28.0, 'expectedSize': 52.0},
        ];

        for (final testCase in testCases) {
          final icon = testCase['icon'] as IconData;
          final iconSize = testCase['iconSize'] as double;
          final expectedSize = testCase['expectedSize'] as double;

          final iconButtonWidget = IconButton(
            icon: Icon(icon),
            iconSize: iconSize,
            onPressed: () {},
          );

          final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

          expect(skeleton, isA<IconButtonSkeleton>());

          final iconButtonSkeleton = skeleton as IconButtonSkeleton;
          expect(iconButtonSkeleton.width, expectedSize);
          expect(iconButtonSkeleton.height, expectedSize);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final size = tester.getSize(find.byType(Container));
          expect(size.width, expectedSize);
          expect(size.height, expectedSize);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });

    group('sanitización de dimensiones', () {
      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.check),
          iconSize: 26,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);
        final iconButtonSkeleton = skeleton as IconButtonSkeleton;

        expect(iconButtonSkeleton.width, 50.0);
        expect(iconButtonSkeleton.height, 50.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 50.0);
        expect(size.height, 50.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería usar el valor predeterminado cuando iconSize es nulo',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.help),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);
        final iconButtonSkeleton = skeleton as IconButtonSkeleton;

        expect(iconButtonSkeleton.width, 48.0);
        expect(iconButtonSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<IconButtonSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.accessibility),
          onPressed: () {},
        );

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(iconButtonWidget, baseColor),
            returnsNormally);
      });
    });

    group('Casos de borde', () {
      testWidgets('Debería manejar iconSize muy pequeño', (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.minimize),
          iconSize: 8,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);
        final size = tester.getSize(find.byType(Container));
        expect(size.width, 32.0);
        expect(size.height, 32.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar iconSize muy grande', (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.fullscreen),
          iconSize: 64,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);
        final size = tester.getSize(find.byType(Container));
        expect(size.width, 88.0);
        expect(size.height, 88.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar un color de fondo muy oscuro',
          (tester) async {
        const darkColor = Color(0xFF000000);
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.dark_mode),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, darkColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, darkColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar un color de fondo muy claro',
          (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.light_mode),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, lightColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, lightColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton con un widget Icon personalizado',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(
            Icons.build,
            color: Colors.purple,
            size: 30,
          ),
          iconSize: 40,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.width, 64.0);
        expect(iconButtonSkeleton.height, 64.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton con iconSize cero',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.close),
          iconSize: 0,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.width, 24.0);
        expect(iconButtonSkeleton.height, 24.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de IconButton', () {
      testWidgets('Debería manejar IconButton en AppBar', (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 24,
          color: Colors.white,
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton en estilo FloatingActionButton',
          (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.add),
          iconSize: 36,
          color: Colors.white,
          tooltip: 'Add',
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.width, 60.0);
        expect(iconButtonSkeleton.height, 60.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar IconButton en navegación', (tester) async {
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
          onPressed: () {},
        );

        final skeleton = provider.createSkeleton(iconButtonWidget, baseColor);

        expect(skeleton, isA<IconButtonSkeleton>());

        final iconButtonSkeleton = skeleton as IconButtonSkeleton;
        expect(iconButtonSkeleton.width, 44.0);
        expect(iconButtonSkeleton.height, 44.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
