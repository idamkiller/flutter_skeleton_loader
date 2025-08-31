import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/sized_box_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/sized_box_skeleton.dart';

void main() {
  group('SizedBoxSkeletonProvider', () {
    late SizedBoxSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = SizedBoxSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget SizedBox', () {
        const sizedBoxWidget = SizedBox(width: 100, height: 50);

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox con solo width', () {
        const sizedBoxWidget = SizedBox(width: 200);

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox con solo height', () {
        const sizedBoxWidget = SizedBox(height: 150);

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox.expand', () {
        const sizedBoxWidget = SizedBox.expand();

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox.shrink', () {
        const sizedBoxWidget = SizedBox.shrink();

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox.square', () {
        const sizedBoxWidget = SizedBox.square(dimension: 100);

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox con child', () {
        const sizedBoxWidget = SizedBox(
          width: 100,
          height: 100,
          child: Text('Contenido'),
        );

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox sin dimensiones y sin child',
          () {
        const sizedBoxWidget = SizedBox();

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar true para SizedBox con dimensiones infinitas', () {
        const sizedBoxWidget = SizedBox(
          width: double.infinity,
          height: double.infinity,
        );

        expect(provider.canHandle(sizedBoxWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son SizedBox', () {
        const textWidget = Text('No es un SizedBox');
        final containerWidget = Container(
          width: 100,
          height: 100,
          color: Colors.red,
        );
        const expandedWidget = Expanded(child: Text('Expanded'));
        const flexibleWidget = Flexible(child: Text('Flexible'));
        final paddingWidget = Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Padding'),
        );

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(expandedWidget), isFalse);
        expect(provider.canHandle(flexibleWidget), isFalse);
        expect(provider.canHandle(paddingWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 6', () {
        expect(provider.priority, 6);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear SizedBoxSkeleton para SizedBox básico',
          (tester) async {
        const sizedBoxWidget = SizedBox(width: 100, height: 50);

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 100.0);
        expect(sizedBoxSkeleton.height, 50.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear SizedBoxSkeleton con solo width',
          (tester) async {
        const sizedBoxWidget = SizedBox(width: 200);

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 200.0);
        expect(sizedBoxSkeleton.height, isNull);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear SizedBoxSkeleton con solo height',
          (tester) async {
        const sizedBoxWidget = SizedBox(height: 150);

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, isNull);
        expect(sizedBoxSkeleton.height, 150.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear SizedBoxSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        const sizedBoxWidget = SizedBox(width: 100, height: 100);

        final skeleton = provider.createSkeleton(sizedBoxWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final sizedBoxSkeleton =
            tester.widget<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton));
        expect(sizedBoxSkeleton.baseColor, customColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox.expand', (tester) async {
        const sizedBoxWidget = SizedBox.expand();

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 100.0);
        expect(sizedBoxSkeleton.height, 40.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox.shrink', (tester) async {
        const sizedBoxWidget = SizedBox.shrink();

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 100.0);
        expect(sizedBoxSkeleton.height, 40.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox.square', (tester) async {
        const sizedBoxWidget = SizedBox.square(dimension: 80);

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 80.0);
        expect(sizedBoxSkeleton.height, 80.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox con child (no vacío)',
          (tester) async {
        const sizedBoxWidget = SizedBox(
          width: 120,
          height: 80,
          child: Text('Contenido'),
        );

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 120.0);
        expect(sizedBoxSkeleton.height, 80.0);
        expect(sizedBoxSkeleton.isEmpty, isFalse);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería usar dimensiones por defecto cuando no hay dimensiones ni child',
          (tester) async {
        const sizedBoxWidget = SizedBox();

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, isNull);
        expect(sizedBoxSkeleton.height, isNull);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería usar dimensiones por defecto cuando tiene child pero no dimensiones',
          (tester) async {
        const sizedBoxWidget = SizedBox(
          child: Text('Texto sin dimensiones'),
        );

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 100.0);
        expect(sizedBoxSkeleton.height, 40.0);
        expect(sizedBoxSkeleton.isEmpty, isFalse);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería sanitizar dimensiones', (tester) async {
        const sizedBoxWidget = SizedBox(width: -50, height: -30);

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 100.0);
        expect(sizedBoxSkeleton.height, 40.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar dimensiones muy grandes', (tester) async {
        const sizedBoxWidget = SizedBox(width: 10000, height: 8000);

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 10000.0);
        expect(sizedBoxSkeleton.height, 8000.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar dimensiones infinitas', (tester) async {
        const sizedBoxWidget = SizedBox(
          width: double.infinity,
          height: double.infinity,
        );

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.baseColor, baseColor);
        expect(sizedBoxSkeleton.width, 100.0);
        expect(sizedBoxSkeleton.height, 40.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('lógica de dimensiones', () {
      test('Debería preservar dimensiones cuando están definidas', () {
        const sizedBoxWidget = SizedBox(width: 250, height: 175);

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);
        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;

        expect(sizedBoxSkeleton.width, 250.0);
        expect(sizedBoxSkeleton.height, 175.0);
      });

      test('Debería usar null cuando solo una dimensión está definida', () {
        const sizedBoxWidthOnly = SizedBox(width: 300);
        const sizedBoxHeightOnly = SizedBox(height: 200);

        final skeletonWidth =
            provider.createSkeleton(sizedBoxWidthOnly, baseColor);
        final skeletonHeight =
            provider.createSkeleton(sizedBoxHeightOnly, baseColor);

        final sizedBoxSkeletonWidth = skeletonWidth as SizedBoxSkeleton;
        final sizedBoxSkeletonHeight = skeletonHeight as SizedBoxSkeleton;

        expect(sizedBoxSkeletonWidth.width, 300.0);
        expect(sizedBoxSkeletonWidth.height, isNull);
        expect(sizedBoxSkeletonHeight.width, isNull);
        expect(sizedBoxSkeletonHeight.height, 200.0);
      });

      test(
          'Debería usar dimensiones por defecto solo cuando tiene child y no tiene dimensiones',
          () {
        const sizedBoxWithChild = SizedBox(child: Text('Test'));
        const sizedBoxWithoutChild = SizedBox();

        final skeletonWithChild =
            provider.createSkeleton(sizedBoxWithChild, baseColor);
        final skeletonWithoutChild =
            provider.createSkeleton(sizedBoxWithoutChild, baseColor);

        final sizedBoxSkeletonWithChild = skeletonWithChild as SizedBoxSkeleton;
        final sizedBoxSkeletonWithoutChild =
            skeletonWithoutChild as SizedBoxSkeleton;

        expect(sizedBoxSkeletonWithChild.width, 100.0);
        expect(sizedBoxSkeletonWithChild.height, 40.0);
        expect(sizedBoxSkeletonWithoutChild.width, isNull);
        expect(sizedBoxSkeletonWithoutChild.height, isNull);
      });

      test('Debería detectar correctamente si está vacío', () {
        const sizedBoxEmpty = SizedBox(width: 100, height: 100);
        const sizedBoxWithChild =
            SizedBox(width: 100, height: 100, child: Text('Test'));

        final skeletonEmpty = provider.createSkeleton(sizedBoxEmpty, baseColor);
        final skeletonWithChild =
            provider.createSkeleton(sizedBoxWithChild, baseColor);

        final sizedBoxSkeletonEmpty = skeletonEmpty as SizedBoxSkeleton;
        final sizedBoxSkeletonWithChild = skeletonWithChild as SizedBoxSkeleton;

        expect(sizedBoxSkeletonEmpty.isEmpty, isTrue);
        expect(sizedBoxSkeletonWithChild.isEmpty, isFalse);
      });
    });

    group('sanitización de dimensiones', () {
      test('Debería sanitizar width correctamente', () {
        const testCases = [
          {'input': -10.0, 'expected': 100.0},
          {'input': 0.0, 'expected': 100.0},
          {'input': 50.0, 'expected': 50.0},
          {'input': double.infinity, 'expected': 100.0},
        ];

        for (final testCase in testCases) {
          final input = testCase['input'] as double;
          final expected = testCase['expected'] as double;

          final sizedBoxWidget = SizedBox(width: input, height: 50);
          final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);
          final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;

          expect(sizedBoxSkeleton.width, expected);
        }
      });

      test('Debería sanitizar height correctamente', () {
        const testCases = [
          {'input': -20.0, 'expected': 40.0},
          {'input': 0.0, 'expected': 40.0},
          {'input': 75.0, 'expected': 75.0},
          {'input': double.infinity, 'expected': 40.0},
        ];

        for (final testCase in testCases) {
          final input = testCase['input'] as double;
          final expected = testCase['expected'] as double;

          final sizedBoxWidget = SizedBox(width: 100, height: input);
          final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);
          final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;

          expect(sizedBoxSkeleton.height, expected);
        }
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<SizedBoxSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        const sizedBoxWidget = SizedBox(width: 100, height: 50);

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(sizedBoxWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar color base muy oscuro', (tester) async {
        const darkColor = Color(0xFF000000);
        const sizedBoxWidget = SizedBox(width: 100, height: 100);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: provider.createSkeleton(sizedBoxWidget, darkColor),
            ),
          ),
        );

        final sizedBoxSkeleton =
            tester.widget<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton));
        expect(sizedBoxSkeleton.baseColor, darkColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy claro', (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        const sizedBoxWidget = SizedBox(width: 100, height: 100);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: provider.createSkeleton(sizedBoxWidget, lightColor),
            ),
          ),
        );

        final sizedBoxSkeleton =
            tester.widget<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton));
        expect(sizedBoxSkeleton.baseColor, lightColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox con child complejo',
          (tester) async {
        final sizedBoxWidget = SizedBox(
          width: 200,
          height: 150,
          child: Column(
            children: [
              const Text('Título'),
              Container(
                width: 50,
                height: 50,
                color: Colors.red,
              ),
              const Icon(Icons.star),
            ],
          ),
        );

        final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBoxSkeleton>());

        final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
        expect(sizedBoxSkeleton.width, 200.0);
        expect(sizedBoxSkeleton.height, 150.0);
        expect(sizedBoxSkeleton.isEmpty, isFalse);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar valores extremos de dimensiones',
          (tester) async {
        const testCases = [
          {
            'width': 0.1,
            'height': 0.1,
            'expectedWidth': 0.1,
            'expectedHeight': 0.1
          },
          {
            'width': 99999.0,
            'height': 88888.0,
            'expectedWidth': 99999.0,
            'expectedHeight': 88888.0
          },
          {
            'width': double.infinity,
            'height': 500.0,
            'expectedWidth': 100.0,
            'expectedHeight': 500.0
          },
          {
            'width': 300.0,
            'height': double.infinity,
            'expectedWidth': 300.0,
            'expectedHeight': 40.0
          },
        ];

        for (int i = 0; i < testCases.length; i++) {
          final testCase = testCases[i];
          final width = testCase['width'] as double;
          final height = testCase['height'] as double;
          final expectedWidth = testCase['expectedWidth'] as double;
          final expectedHeight = testCase['expectedHeight'] as double;

          final sizedBoxWidget = SizedBox(width: width, height: height);
          final skeleton = provider.createSkeleton(sizedBoxWidget, baseColor);

          expect(skeleton, isA<SizedBoxSkeleton>());

          final sizedBoxSkeleton = skeleton as SizedBoxSkeleton;
          expect(sizedBoxSkeleton.width, expectedWidth);
          expect(sizedBoxSkeleton.height, expectedHeight);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(SizedBoxSkeleton), findsOneWidget);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de SizedBox', () {
      testWidgets('Debería manejar SizedBox como espaciador', (tester) async {
        const sizedBoxWidget = SizedBox(height: 20);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const Text('Texto 1'),
                  provider.createSkeleton(sizedBoxWidget, baseColor),
                  const Text('Texto 2'),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);

        final sizedBoxSkeleton =
            tester.widget<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton));
        expect(sizedBoxSkeleton.width, isNull);
        expect(sizedBoxSkeleton.height, 20.0);
        expect(sizedBoxSkeleton.isEmpty, isTrue);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox como contenedor de imagen',
          (tester) async {
        const sizedBoxWidget = SizedBox(
          width: 150,
          height: 150,
          child: Icon(Icons.image, size: 100),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: provider.createSkeleton(sizedBoxWidget, baseColor),
            ),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);

        final sizedBoxSkeleton =
            tester.widget<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton));
        expect(sizedBoxSkeleton.width, 150.0);
        expect(sizedBoxSkeleton.height, 150.0);
        expect(sizedBoxSkeleton.isEmpty, isFalse);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox en layouts flexibles',
          (tester) async {
        const sizedBoxWidget = SizedBox(
          width: 100,
          child: Text('Texto con ancho fijo'),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  const Expanded(child: Text('Flexible')),
                  provider.createSkeleton(sizedBoxWidget, baseColor),
                  const Expanded(child: Text('Flexible')),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);

        final sizedBoxSkeleton =
            tester.widget<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton));
        expect(sizedBoxSkeleton.width, 100.0);
        expect(sizedBoxSkeleton.height, isNull);
        expect(sizedBoxSkeleton.isEmpty, isFalse);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar múltiples SizedBox con diferentes configuraciones',
          (tester) async {
        const sizedBoxes = [
          SizedBox(width: 50, height: 50),
          SizedBox(width: 200),
          SizedBox(height: 100),
          SizedBox.square(dimension: 75),
          SizedBox.shrink(),
          SizedBox(width: 120, height: 80, child: Text('Con contenido')),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: sizedBoxes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final sizedBox = entry.value;
                  final color = Color(0xFF000000 + (index * 0x111111));
                  return provider.createSkeleton(sizedBox, color);
                }).toList(),
              ),
            ),
          ),
        );

        final sizedBoxSkeletons = tester
            .widgetList<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton))
            .toList();
        expect(sizedBoxSkeletons, hasLength(6));

        expect(sizedBoxSkeletons[0].width, 50.0);
        expect(sizedBoxSkeletons[0].height, 50.0);
        expect(sizedBoxSkeletons[0].isEmpty, isTrue);

        expect(sizedBoxSkeletons[1].width, 200.0);
        expect(sizedBoxSkeletons[1].height, isNull);
        expect(sizedBoxSkeletons[1].isEmpty, isTrue);

        expect(sizedBoxSkeletons[2].width, isNull);
        expect(sizedBoxSkeletons[2].height, 100.0);
        expect(sizedBoxSkeletons[2].isEmpty, isTrue);

        expect(sizedBoxSkeletons[3].width, 75.0);
        expect(sizedBoxSkeletons[3].height, 75.0);
        expect(sizedBoxSkeletons[3].isEmpty, isTrue);

        expect(sizedBoxSkeletons[4].width, 100.0);
        expect(sizedBoxSkeletons[4].height, 40.0);
        expect(sizedBoxSkeletons[4].isEmpty, isTrue);

        expect(sizedBoxSkeletons[5].width, 120.0);
        expect(sizedBoxSkeletons[5].height, 80.0);
        expect(sizedBoxSkeletons[5].isEmpty, isFalse);

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox anidados', (tester) async {
        const sizedBoxWidget = SizedBox(
          width: 200,
          height: 200,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Text('Anidado'),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: provider.createSkeleton(sizedBoxWidget, baseColor),
            ),
          ),
        );

        expect(find.byType(SizedBoxSkeleton), findsOneWidget);

        final sizedBoxSkeleton =
            tester.widget<SizedBoxSkeleton>(find.byType(SizedBoxSkeleton));
        expect(sizedBoxSkeleton.width, 200.0);
        expect(sizedBoxSkeleton.height, 200.0);
        expect(sizedBoxSkeleton.isEmpty, isFalse);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
