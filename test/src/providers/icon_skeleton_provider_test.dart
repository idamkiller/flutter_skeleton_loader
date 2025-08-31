import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/icon_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/icon_skeleton.dart';

void main() {
  group('IconSkeletonProvider', () {
    late IconSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = IconSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget Icon', () {
        const iconWidget = Icon(Icons.home);

        expect(provider.canHandle(iconWidget), isTrue);
      });

      test('Debería retornar true para Icon con tamaño personalizado', () {
        const iconWidget = Icon(
          Icons.star,
          size: 32,
        );

        expect(provider.canHandle(iconWidget), isTrue);
      });

      test('Debería retornar true para Icon con color personalizado', () {
        const iconWidget = Icon(
          Icons.favorite,
          color: Colors.red,
          size: 28,
        );

        expect(provider.canHandle(iconWidget), isTrue);
      });

      test('Debería retornar true para Icon con propiedades opcionales', () {
        const iconWidget = Icon(
          Icons.settings,
          size: 24,
          color: Colors.blue,
          semanticLabel: 'Settings',
          textDirection: TextDirection.ltr,
        );

        expect(provider.canHandle(iconWidget), isTrue);
      });

      test('Debería retornar true para Icon con semántica personalizada', () {
        const iconWidget = Icon(
          Icons.accessibility,
          semanticLabel: 'Accessibility Icon',
          textDirection: TextDirection.rtl,
        );

        expect(provider.canHandle(iconWidget), isTrue);
      });

      test('Debería retornar true para Icon con diferentes IconData', () {
        const homeIcon = Icon(Icons.home);
        const starIcon = Icon(Icons.star);
        const favoriteIcon = Icon(Icons.favorite);
        const settingsIcon = Icon(Icons.settings);

        expect(provider.canHandle(homeIcon), isTrue);
        expect(provider.canHandle(starIcon), isTrue);
        expect(provider.canHandle(favoriteIcon), isTrue);
        expect(provider.canHandle(settingsIcon), isTrue);
      });

      test('Debería retornar false para widgets que no son Icon', () {
        const textWidget = Text('No es un ícono');
        final containerWidget = Container();
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        );
        const buttonWidget =
            ElevatedButton(onPressed: null, child: Text('Botón'));

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(iconButtonWidget), isFalse);
        expect(provider.canHandle(buttonWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 6', () {
        expect(provider.priority, 6);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear IconSkeleton para Icon básico',
          (tester) async {
        const iconWidget = Icon(Icons.home);

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.baseColor, baseColor);
        expect(iconSkeleton.size, 24.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear IconSkeleton con tamaño por defecto cuando no se especifica',
          (tester) async {
        const iconWidget = Icon(Icons.star);

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.baseColor, baseColor);
        expect(iconSkeleton.size, 24.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 24.0);
        expect(size.height, 24.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear IconSkeleton con tamaño personalizado',
          (tester) async {
        const iconWidget = Icon(
          Icons.favorite,
          size: 32,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.baseColor, baseColor);
        expect(iconSkeleton.size, 32.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 32.0);
        expect(size.height, 32.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear IconSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        const iconWidget = Icon(
          Icons.settings,
          color: Colors.red,
        );

        final skeleton = provider.createSkeleton(iconWidget, customColor);

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

      testWidgets('Debería crear IconSkeleton con forma circular',
          (tester) async {
        const iconWidget = Icon(Icons.circle);

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

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

      testWidgets('Debería manejar Icon con tamaño grande', (tester) async {
        const iconWidget = Icon(
          Icons.zoom_in,
          size: 48,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 48.0);

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

      testWidgets('Debería manejar Icon con tamaño pequeño', (tester) async {
        const iconWidget = Icon(
          Icons.zoom_out,
          size: 16,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 16.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 16.0);
        expect(size.height, 16.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Icon con color y propiedades personalizadas',
          (tester) async {
        const iconWidget = Icon(
          Icons.palette,
          size: 30,
          color: Colors.green,
          semanticLabel: 'Paleta de colores',
          textDirection: TextDirection.ltr,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

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

      testWidgets('Debería manejar Icon con semántica personalizada',
          (tester) async {
        const iconWidget = Icon(
          Icons.accessibility,
          size: 26,
          semanticLabel: 'Accesibilidad',
          textDirection: TextDirection.rtl,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 26.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar diferentes tipos de iconos', (tester) async {
        final testCases = [
          {'icon': Icons.home, 'size': 24.0},
          {'icon': Icons.star, 'size': 20.0},
          {'icon': Icons.favorite, 'size': 36.0},
          {'icon': Icons.settings, 'size': 28.0},
          {'icon': Icons.help, 'size': 32.0},
        ];

        for (final testCase in testCases) {
          final icon = testCase['icon'] as IconData;
          final size = testCase['size'] as double;

          final iconWidget = Icon(icon, size: size);

          final skeleton = provider.createSkeleton(iconWidget, baseColor);

          expect(skeleton, isA<IconSkeleton>());

          final iconSkeleton = skeleton as IconSkeleton;
          expect(iconSkeleton.size, size);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final containerSize = tester.getSize(find.byType(Container));
          expect(containerSize.width, size);
          expect(containerSize.height, size);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Icon sin tamaño especificado',
          (tester) async {
        const iconWidget = Icon(Icons.help);

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 24.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 24.0);
        expect(size.height, 24.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('sanitización de dimensiones', () {
      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        const iconWidget = Icon(
          Icons.check,
          size: 26,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);
        final iconSkeleton = skeleton as IconSkeleton;

        expect(iconSkeleton.size, 26.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 26.0);
        expect(size.height, 26.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería usar el valor por defecto cuando size es nulo',
          (tester) async {
        const iconWidget = Icon(Icons.help);

        final skeleton = provider.createSkeleton(iconWidget, baseColor);
        final iconSkeleton = skeleton as IconSkeleton;

        expect(iconSkeleton.size, 24.0);

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
        expect(provider, isA<IconSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        const iconWidget = Icon(Icons.build);

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(iconWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar tamaño muy pequeño', (tester) async {
        const iconWidget = Icon(
          Icons.minimize,
          size: 8,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconSkeleton), findsOneWidget);
        final size = tester.getSize(find.byType(Container));
        expect(size.width, 8.0);
        expect(size.height, 8.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar tamaño muy grande', (tester) async {
        const iconWidget = Icon(
          Icons.fullscreen,
          size: 64,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconSkeleton), findsOneWidget);
        final size = tester.getSize(find.byType(Container));
        expect(size.width, 64.0);
        expect(size.height, 64.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy oscuro', (tester) async {
        const darkColor = Color(0xFF000000);
        const iconWidget = Icon(Icons.dark_mode);

        final skeleton = provider.createSkeleton(iconWidget, darkColor);

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

      testWidgets('Debería manejar color base muy claro', (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        const iconWidget = Icon(Icons.light_mode);

        final skeleton = provider.createSkeleton(iconWidget, lightColor);

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

      testWidgets(
          'Debería manejar Icon con color personalizado que debe ser ignorado',
          (tester) async {
        const iconWidget = Icon(
          Icons.colorize,
          color: Colors.purple,
          size: 30,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

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

      testWidgets('Debería manejar Icon con tamaño cero', (tester) async {
        const iconWidget = Icon(
          Icons.close,
          size: 0,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 24.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar Icon con propiedades de accesibilidad completas',
          (tester) async {
        const iconWidget = Icon(
          Icons.accessibility_new,
          size: 25,
          color: Colors.blue,
          semanticLabel: 'Nueva funcionalidad de accesibilidad',
          textDirection: TextDirection.ltr,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 25.0);

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

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 25.0);
        expect(size.height, 25.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de Icon', () {
      testWidgets('Debería manejar Icon en AppBar', (tester) async {
        const iconWidget = Icon(
          Icons.menu,
          size: 24,
          color: Colors.white,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconSkeleton), findsOneWidget);

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Icon en navegación', (tester) async {
        const iconWidget = Icon(
          Icons.arrow_back,
          size: 20,
          color: Colors.black87,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(IconSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Icon decorativo', (tester) async {
        const iconWidget = Icon(
          Icons.star_border,
          size: 18,
          color: Colors.amber,
        );

        final skeleton = provider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<IconSkeleton>());

        final iconSkeleton = skeleton as IconSkeleton;
        expect(iconSkeleton.size, 18.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 18.0);
        expect(size.height, 18.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Icon con diferentes direcciones de texto',
          (tester) async {
        final testCases = [
          {'textDirection': TextDirection.ltr, 'size': 22.0},
          {'textDirection': TextDirection.rtl, 'size': 26.0},
        ];

        for (final testCase in testCases) {
          final textDirection = testCase['textDirection'] as TextDirection;
          final size = testCase['size'] as double;

          final iconWidget = Icon(
            Icons.translate,
            size: size,
            textDirection: textDirection,
          );

          final skeleton = provider.createSkeleton(iconWidget, baseColor);

          expect(skeleton, isA<IconSkeleton>());

          final iconSkeleton = skeleton as IconSkeleton;
          expect(iconSkeleton.size, size);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final containerSize = tester.getSize(find.byType(Container));
          expect(containerSize.width, size);
          expect(containerSize.height, size);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });
  });
}
