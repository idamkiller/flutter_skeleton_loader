import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/image_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/image_skeleton.dart';

void main() {
  group('ImageSkeletonProvider', () {
    late ImageSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = ImageSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget Image', () {
        final imageWidget = Image.asset('assets/test.png');

        expect(provider.canHandle(imageWidget), isTrue);
      });

      test('Debería retornar true para Image.network', () {
        final imageWidget = Image.network('https://example.com/image.jpg');

        expect(provider.canHandle(imageWidget), isTrue);
      });

      test('Debería retornar true para Image.file', () {
        final imageWidget = Image.memory(Uint8List.fromList([1, 2, 3]));

        expect(provider.canHandle(imageWidget), isTrue);
      });

      test('Debería retornar true para Image con dimensiones personalizadas',
          () {
        final imageWidget = Image.asset(
          'assets/test.png',
          width: 200,
          height: 150,
        );

        expect(provider.canHandle(imageWidget), isTrue);
      });

      test('Debería retornar true para Image con propiedades personalizadas',
          () {
        final imageWidget = Image.asset(
          'assets/test.png',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          color: Colors.red,
          colorBlendMode: BlendMode.multiply,
        );

        expect(provider.canHandle(imageWidget), isTrue);
      });

      test('Debería retornar true para Image con alignment', () {
        final imageWidget = Image.asset(
          'assets/test.png',
          alignment: Alignment.topLeft,
          repeat: ImageRepeat.noRepeat,
        );

        expect(provider.canHandle(imageWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son Image', () {
        const textWidget = Text('No es una imagen');
        final containerWidget = Container();
        const iconWidget = Icon(Icons.image);
        final iconButtonWidget = IconButton(
          icon: const Icon(Icons.image),
          onPressed: () {},
        );

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
        expect(provider.canHandle(iconButtonWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 8', () {
        expect(provider.priority, 8);
      });
    });

    group('createSkeleton', () {
      testWidgets(
          'Debería crear ImageSkeleton para Image básico sin dimensiones',
          (tester) async {
        final imageWidget = Image.asset('assets/test.png');

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.baseColor, baseColor);

        expect(imageSkeleton.width, 100.0);
        expect(imageSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ImageSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ImageSkeleton con dimensiones personalizadas',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/test.png',
          width: 200,
          height: 150,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.baseColor, baseColor);
        expect(imageSkeleton.width, 200.0);
        expect(imageSkeleton.height, 150.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 200.0);
        expect(size.height, 150.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ImageSkeleton con solo ancho especificado',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/test.png',
          width: 120,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.baseColor, baseColor);

        expect(imageSkeleton.width, 120.0);
        expect(imageSkeleton.height, 120.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 120.0);
        expect(size.height, 120.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ImageSkeleton con solo altura especificada',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/test.png',
          height: 180,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.baseColor, baseColor);

        expect(imageSkeleton.width, 180.0);
        expect(imageSkeleton.height, 180.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 180.0);
        expect(size.height, 180.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ImageSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        final imageWidget = Image.asset(
          'assets/test.png',
          color: Colors.red,
        );

        final skeleton = provider.createSkeleton(imageWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, customColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ImageSkeleton con bordes redondeados',
          (tester) async {
        final imageWidget = Image.asset('assets/test.png');

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image.network', (tester) async {
        final imageWidget = Image.network(
          'https://example.com/image.jpg',
          width: 250,
          height: 200,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.width, 250.0);
        expect(imageSkeleton.height, 200.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ImageSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image.memory', (tester) async {
        final imageWidget = Image.memory(
          Uint8List.fromList([1, 2, 3, 4, 5]),
          width: 80,
          height: 60,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.width, 80.0);
        expect(imageSkeleton.height, 60.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 80.0);
        expect(size.height, 60.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image con propiedades personalizadas',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/test.png',
          width: 160,
          height: 120,
          fit: BoxFit.cover,
          color: Colors.green,
          colorBlendMode: BlendMode.multiply,
          alignment: Alignment.center,
          repeat: ImageRepeat.noRepeat,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar diferentes tipos de Image', (tester) async {
        final testCases = [
          {
            'widget': Image.asset('assets/image1.png', width: 100, height: 80),
            'expectedWidth': 100.0,
            'expectedHeight': 80.0,
          },
          {
            'widget': Image.network('https://example.com/image2.jpg',
                width: 150, height: 120),
            'expectedWidth': 150.0,
            'expectedHeight': 120.0,
          },
          {
            'widget': Image.memory(Uint8List.fromList([1, 2, 3]),
                width: 90, height: 90),
            'expectedWidth': 90.0,
            'expectedHeight': 90.0,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as Image;
          final expectedWidth = testCase['expectedWidth'] as double;
          final expectedHeight = testCase['expectedHeight'] as double;

          final skeleton = provider.createSkeleton(widget, baseColor);

          expect(skeleton, isA<ImageSkeleton>());

          final imageSkeleton = skeleton as ImageSkeleton;
          expect(imageSkeleton.width, expectedWidth);
          expect(imageSkeleton.height, expectedHeight);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final size = tester.getSize(find.byType(Container));
          expect(size.width, expectedWidth);
          expect(size.height, expectedHeight);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image con dimensiones grandes',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/large.png',
          width: 500,
          height: 400,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.width, 500.0);
        expect(imageSkeleton.height, 400.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 500.0);
        expect(size.height, 400.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image con dimensiones pequeñas',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/small.png',
          width: 20,
          height: 15,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.width, 20.0);
        expect(imageSkeleton.height, 15.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 20.0);
        expect(size.height, 15.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('sanitización de dimensiones', () {
      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        final imageWidget = Image.asset(
          'assets/test.png',
          width: 175,
          height: 125,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);
        final imageSkeleton = skeleton as ImageSkeleton;

        expect(imageSkeleton.width, 175.0);
        expect(imageSkeleton.height, 125.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 175.0);
        expect(size.height, 125.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería usar valores por defecto cuando las dimensiones son nulas',
          (tester) async {
        final imageWidget = Image.asset('assets/test.png');

        final skeleton = provider.createSkeleton(imageWidget, baseColor);
        final imageSkeleton = skeleton as ImageSkeleton;

        expect(imageSkeleton.width, 100.0);
        expect(imageSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería calcular dimensión faltante basada en la especificada',
          (tester) async {
        final testCases = [
          {
            'widget': Image.asset('assets/test.png', width: 150),
            'expectedWidth': 150.0,
            'expectedHeight': 150.0,
          },
          {
            'widget': Image.asset('assets/test.png', height: 200),
            'expectedWidth': 200.0,
            'expectedHeight': 200.0,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as Image;
          final expectedWidth = testCase['expectedWidth'] as double;
          final expectedHeight = testCase['expectedHeight'] as double;

          final skeleton = provider.createSkeleton(widget, baseColor);
          final imageSkeleton = skeleton as ImageSkeleton;

          expect(imageSkeleton.width, expectedWidth);
          expect(imageSkeleton.height, expectedHeight);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<ImageSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        final imageWidget = Image.asset('assets/test.png');

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(imageWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar dimensiones muy pequeñas', (tester) async {
        final imageWidget = Image.asset(
          'assets/tiny.png',
          width: 1,
          height: 1,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ImageSkeleton), findsOneWidget);
        final size = tester.getSize(find.byType(Container));
        expect(size.width, 1.0);
        expect(size.height, 1.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar dimensiones muy grandes', (tester) async {
        final imageWidget = Image.asset(
          'assets/huge.png',
          width: 600,
          height: 400,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ImageSkeleton), findsOneWidget);
        final size = tester.getSize(find.byType(Container));
        expect(size.width, 600.0);
        expect(size.height, 400.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy oscuro', (tester) async {
        const darkColor = Color(0xFF000000);
        final imageWidget = Image.asset('assets/dark.png');

        final skeleton = provider.createSkeleton(imageWidget, darkColor);

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
        final imageWidget = Image.asset('assets/light.png');

        final skeleton = provider.createSkeleton(imageWidget, lightColor);

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
          'Debería manejar Image con color personalizado que debe ser ignorado',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/colored.png',
          width: 120,
          height: 90,
          color: Colors.purple,
          colorBlendMode: BlendMode.overlay,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image con dimensiones cero', (tester) async {
        final imageWidget = Image.asset(
          'assets/zero.png',
          width: 0,
          height: 0,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;

        expect(imageSkeleton.width, 100.0);
        expect(imageSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image con BoxFit y alignment complejos',
          (tester) async {
        final imageWidget = Image.asset(
          'assets/complex.png',
          width: 200,
          height: 150,
          fit: BoxFit.contain,
          alignment: Alignment.topLeft,
          repeat: ImageRepeat.repeatX,
          centerSlice: const Rect.fromLTWH(10, 10, 80, 80),
          matchTextDirection: true,
          gaplessPlayback: false,
          semanticLabel: 'Imagen compleja',
          excludeFromSemantics: false,
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.width, 200.0);
        expect(imageSkeleton.height, 150.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 200.0);
        expect(size.height, 150.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de Image', () {
      testWidgets('Debería manejar Image en avatar circular', (tester) async {
        final imageWidget = Image.asset(
          'assets/avatar.png',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ImageSkeleton), findsOneWidget);

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image en banner', (tester) async {
        final imageWidget = Image.network(
          'https://example.com/banner.jpg',
          width: 300,
          height: 100,
          fit: BoxFit.cover,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.width, 300.0);
        expect(imageSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ImageSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image en galería', (tester) async {
        final imageWidget = Image.asset(
          'assets/gallery_thumb.jpg',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );

        final skeleton = provider.createSkeleton(imageWidget, baseColor);

        expect(skeleton, isA<ImageSkeleton>());

        final imageSkeleton = skeleton as ImageSkeleton;
        expect(imageSkeleton.width, 100.0);
        expect(imageSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 100.0);
        expect(size.height, 100.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Image responsiva', (tester) async {
        final testCases = [
          {'width': 300.0, 'height': 200.0},
          {'width': 200.0, 'height': 300.0},
          {'width': 250.0, 'height': 250.0},
        ];

        for (final testCase in testCases) {
          final width = testCase['width'] as double;
          final height = testCase['height'] as double;

          final imageWidget = Image.network(
            'https://example.com/responsive.jpg',
            width: width,
            height: height,
            fit: BoxFit.contain,
          );

          final skeleton = provider.createSkeleton(imageWidget, baseColor);

          expect(skeleton, isA<ImageSkeleton>());

          final imageSkeleton = skeleton as ImageSkeleton;
          expect(imageSkeleton.width, width);
          expect(imageSkeleton.height, height);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final size = tester.getSize(find.byType(Container));
          expect(size.width, width);
          expect(size.height, height);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });
  });
}
