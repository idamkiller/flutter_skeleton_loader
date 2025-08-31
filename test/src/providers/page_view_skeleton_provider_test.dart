import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/page_view_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/page_view_skeleton.dart';

void main() {
  group('PageViewSkeletonProvider', () {
    late PageViewSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = PageViewSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget PageView', () {
        final pageViewWidget = PageView(
          children: const [
            Text('Página 1'),
            Text('Página 2'),
          ],
        );

        expect(provider.canHandle(pageViewWidget), isTrue);
      });

      test('Debería retornar true para PageView.builder', () {
        final pageViewWidget = PageView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Text('Página $index'),
        );

        expect(provider.canHandle(pageViewWidget), isTrue);
      });

      test('Debería retornar true para PageView.custom', () {
        final pageViewWidget = PageView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) => Text('Página personalizada $index'),
            childCount: 3,
          ),
        );

        expect(provider.canHandle(pageViewWidget), isTrue);
      });

      test('Debería retornar true para PageView con scrollDirection horizontal',
          () {
        final pageViewWidget = PageView(
          scrollDirection: Axis.horizontal,
          children: const [
            Text('Página H1'),
            Text('Página H2'),
          ],
        );

        expect(provider.canHandle(pageViewWidget), isTrue);
      });

      test('Debería retornar true para PageView con scrollDirection vertical',
          () {
        final pageViewWidget = PageView(
          scrollDirection: Axis.vertical,
          children: const [
            Text('Página V1'),
            Text('Página V2'),
          ],
        );

        expect(provider.canHandle(pageViewWidget), isTrue);
      });

      test('Debería retornar true para PageView con propiedades personalizadas',
          () {
        final pageViewWidget = PageView(
          controller: PageController(viewportFraction: 0.8),
          scrollDirection: Axis.horizontal,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          pageSnapping: true,
          onPageChanged: (index) {},
          children: const [
            Text('Página personalizada 1'),
            Text('Página personalizada 2'),
          ],
        );

        expect(provider.canHandle(pageViewWidget), isTrue);
      });

      test(
          'Debería retornar true para PageView con PageController personalizado',
          () {
        final controller = PageController(
          initialPage: 1,
          keepPage: true,
          viewportFraction: 0.9,
        );
        final pageViewWidget = PageView(
          controller: controller,
          children: const [
            Text('Página con controller'),
          ],
        );

        expect(provider.canHandle(pageViewWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son PageView', () {
        const textWidget = Text('No es un PageView');
        final containerWidget = Container();
        const iconWidget = Icon(Icons.pages);
        final listViewWidget = ListView(children: const [Text('Lista')]);
        final gridViewWidget = GridView.count(crossAxisCount: 2);
        final singleChildScrollViewWidget =
            SingleChildScrollView(child: Container());

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
        expect(provider.canHandle(listViewWidget), isFalse);
        expect(provider.canHandle(gridViewWidget), isFalse);
        expect(provider.canHandle(singleChildScrollViewWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 8', () {
        expect(provider.priority, 8);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear PageViewSkeleton para PageView básico',
          (tester) async {
        final pageViewWidget = PageView(
          children: const [
            Text('Página 1'),
            Text('Página 2'),
            Text('Página 3'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        expect(skeleton, isA<PageViewSkeleton>());

        final pageViewSkeleton = skeleton as PageViewSkeleton;
        expect(pageViewSkeleton.baseColor, baseColor);
        expect(pageViewSkeleton.itemCount, 3);
        expect(pageViewSkeleton.height, 200.0);
        expect(pageViewSkeleton.width, isNull);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear PageViewSkeleton con configuración por defecto',
          (tester) async {
        final pageViewWidget = PageView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Text('Página $index'),
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        expect(skeleton, isA<PageViewSkeleton>());

        final pageViewSkeleton = skeleton as PageViewSkeleton;
        expect(pageViewSkeleton.baseColor, baseColor);
        expect(pageViewSkeleton.itemCount, 3);
        expect(pageViewSkeleton.height, 200.0);
        expect(pageViewSkeleton.width, isNull);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear PageViewSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        final pageViewWidget = PageView(
          children: const [
            Text('Página con color personalizado'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));

        final skeletonContainers = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.color == customColor;
        }).toList();

        expect(skeletonContainers.isNotEmpty, isTrue);

        for (final container in skeletonContainers) {
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.color, customColor);
          expect(decoration.borderRadius, BorderRadius.circular(8));
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear PageViewSkeleton con bordes redondeados',
          (tester) async {
        final pageViewWidget = PageView(
          children: const [
            Text('Página para verificar bordes'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));

        final skeletonContainers = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.color == baseColor;
        }).toList();

        expect(skeletonContainers.isNotEmpty, isTrue);

        for (final container in skeletonContainers) {
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.borderRadius, BorderRadius.circular(8));
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear PageViewSkeleton con physics deshabilitados',
          (tester) async {
        final pageViewWidget = PageView(
          physics: const BouncingScrollPhysics(),
          children: const [
            Text('Página con physics'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final pageView = tester.widget<PageView>(find.byType(PageView));
        expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar PageView.builder', (tester) async {
        final pageViewWidget = PageView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            color: Colors.red,
            child: Center(child: Text('Página $index')),
          ),
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        expect(skeleton, isA<PageViewSkeleton>());

        final pageViewSkeleton = skeleton as PageViewSkeleton;
        expect(pageViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar PageView.custom', (tester) async {
        final pageViewWidget = PageView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              color: Colors.green,
              child: Center(child: Text('Página custom $index')),
            ),
            childCount: 7,
          ),
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        expect(skeleton, isA<PageViewSkeleton>());

        final pageViewSkeleton = skeleton as PageViewSkeleton;
        expect(pageViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería ignorar propiedades de PageController',
          (tester) async {
        final controller = PageController(
          initialPage: 2,
          keepPage: false,
          viewportFraction: 0.8,
        );

        final pageViewWidget = PageView(
          controller: controller,
          onPageChanged: (index) {},
          children: const [
            Text('Página con controller'),
            Text('Otra página'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        final pageView = tester.widget<PageView>(find.byType(PageView));
        expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería ignorar scrollDirection del PageView original',
          (tester) async {
        final testCases = [
          {
            'scrollDirection': Axis.horizontal,
            'description': 'horizontal',
          },
          {
            'scrollDirection': Axis.vertical,
            'description': 'vertical',
          },
        ];

        for (final testCase in testCases) {
          final scrollDirection = testCase['scrollDirection'] as Axis;
          final description = testCase['description'] as String;

          final pageViewWidget = PageView(
            scrollDirection: scrollDirection,
            children: [
              Text('Página $description 1'),
              Text('Página $description 2'),
            ],
          );

          final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

          expect(skeleton, isA<PageViewSkeleton>());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(PageViewSkeleton), findsOneWidget);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear exactamente 3 páginas por defecto',
          (tester) async {
        final pageViewWidget = PageView(
          children: const [
            Text('Página 1'),
            Text('Página 2'),
            Text('Página 3'),
            Text('Página 4'),
            Text('Página 5'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);

        expect(find.byType(PageView), findsOneWidget);

        expect(find.byKey(const ValueKey('page_skeleton_0')), findsOneWidget);

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería usar altura por defecto de 200', (tester) async {
        final pageViewWidget = PageView(
          children: const [
            Text('Página para verificar altura'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

        final mainSizedBox = sizedBoxes.firstWhere(
          (sizedBox) => sizedBox.height == 200.0,
          orElse: () =>
              throw StateError('No se encontró SizedBox con altura 200'),
        );
        expect(mainSizedBox.height, 200.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería adaptar el ancho automáticamente', (tester) async {
        final pageViewWidget = PageView(
          children: const [
            Text('Página para verificar ancho'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                width: 300,
                child: skeleton,
              ),
            ),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(find.byType(LayoutBuilder), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('configuración del skeleton', () {
      test('Debería usar itemCount fijo de 3', () {
        final testCases = [
          PageView(children: const [Text('1')]),
          PageView(children: const [Text('1'), Text('2')]),
          PageView(children: const [
            Text('1'),
            Text('2'),
            Text('3'),
            Text('4'),
            Text('5')
          ]),
          PageView.builder(
              itemCount: 100, itemBuilder: (_, __) => const Text('Página')),
        ];

        for (final pageViewWidget in testCases) {
          final skeleton = provider.createSkeleton(pageViewWidget, baseColor);
          final pageViewSkeleton = skeleton as PageViewSkeleton;

          expect(pageViewSkeleton.itemCount, 3);
        }
      });

      test('Debería usar altura fija de 200', () {
        final testCases = [
          PageView(children: const [Text('A')]),
          PageView.builder(
              itemCount: 5, itemBuilder: (_, __) => Container(height: 100)),
          PageView.custom(
              childrenDelegate: SliverChildBuilderDelegate(
            (_, __) => Container(height: 300),
            childCount: 2,
          )),
        ];

        for (final pageViewWidget in testCases) {
          final skeleton = provider.createSkeleton(pageViewWidget, baseColor);
          final pageViewSkeleton = skeleton as PageViewSkeleton;

          expect(pageViewSkeleton.height, 200.0);
        }
      });

      test('Debería usar ancho adaptativo (null)', () {
        final testCases = [
          PageView(children: const [Text('A')]),
          PageView.builder(
              itemCount: 3, itemBuilder: (_, __) => Container(width: 200)),
        ];

        for (final pageViewWidget in testCases) {
          final skeleton = provider.createSkeleton(pageViewWidget, baseColor);
          final pageViewSkeleton = skeleton as PageViewSkeleton;

          expect(pageViewSkeleton.width, isNull);
        }
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<PageViewSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        final pageViewWidget = PageView(children: const [Text('Test')]);

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(pageViewWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar PageView vacío', (tester) async {
        final pageViewWidget = PageView(children: const []);

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(find.byKey(const ValueKey('page_skeleton_0')), findsOneWidget);

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy oscuro', (tester) async {
        const darkColor = Color(0xFF000000);
        final pageViewWidget = PageView(
          children: const [
            Text('Página oscura'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, darkColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));
        final skeletonContainers = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.color == darkColor;
        }).toList();

        expect(skeletonContainers.isNotEmpty, isTrue);
        for (final container in skeletonContainers) {
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.color, darkColor);
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy claro', (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        final pageViewWidget = PageView(
          children: const [
            Text('Página clara'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, lightColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));
        final skeletonContainers = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.color == lightColor;
        }).toList();

        expect(skeletonContainers.isNotEmpty, isTrue);
        for (final container in skeletonContainers) {
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.color, lightColor);
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar PageView con páginas complejas',
          (tester) async {
        final pageViewWidget = PageView(
          children: [
            Column(
              children: [
                Container(height: 100, color: Colors.red),
                const Text('Página compleja 1'),
                const Icon(Icons.star),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Text('Título de página'),
                    Text('Contenido de página'),
                  ],
                ),
              ),
            ),
            ListView(
              children: const [
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
              ],
            ),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);

        expect(find.byKey(const ValueKey('page_skeleton_0')), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar PageView con controller personalizado complejo',
          (tester) async {
        final controller = PageController(
          initialPage: 1,
          keepPage: true,
          viewportFraction: 0.85,
        );

        final pageViewWidget = PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          reverse: true,
          physics: const ClampingScrollPhysics(),
          pageSnapping: false,
          onPageChanged: (index) {},
          children: const [
            Text('Página con controller complejo'),
            Text('Segunda página'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        final pageView = tester.widget<PageView>(find.byType(PageView));
        expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
        expect(tester.takeException(), isNull);

        controller.dispose();
      });

      testWidgets('Debería manejar constraints extremos', (tester) async {
        final pageViewWidget = PageView(
          children: const [
            Text('Página con constraints extremos'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                width: 50,
                height: 50,
                child: skeleton,
              ),
            ),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(find.byType(LayoutBuilder), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de PageView', () {
      testWidgets('Debería manejar PageView para onboarding', (tester) async {
        final pageViewWidget = PageView.builder(
          itemCount: 4,
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 100),
              const SizedBox(height: 20),
              Text('Bienvenido - Paso ${index + 1}'),
              const SizedBox(height: 10),
              Text('Descripción del paso ${index + 1}'),
            ],
          ),
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: skeleton,
              bottomNavigationBar: Container(
                height: 60,
                child: const Center(child: Text('Indicadores')),
              ),
            ),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(find.byKey(const ValueKey('page_skeleton_0')), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar PageView para galería de imágenes',
          (tester) async {
        final pageViewWidget = PageView(
          children: [
            for (int i = 0; i < 5; i++)
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://example.com/image$i.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Imagen $i',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(find.byKey(const ValueKey('page_skeleton_0')), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar PageView con indicadores de página',
          (tester) async {
        final pageViewWidget = PageView(
          controller: PageController(viewportFraction: 0.8),
          children: const [
            Text('Página con indicadores 1'),
            Text('Página con indicadores 2'),
            Text('Página con indicadores 3'),
          ],
        );

        final skeleton = provider.createSkeleton(pageViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(child: skeleton),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.circle, size: 12),
                        Icon(Icons.circle_outlined, size: 12),
                        Icon(Icons.circle_outlined, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(PageViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar diferentes tipos de PageView',
          (tester) async {
        final testCases = [
          {
            'description': 'PageView básico',
            'widget': PageView(
              children: const [Text('A'), Text('B')],
            ),
          },
          {
            'description': 'PageView.builder',
            'widget': PageView.builder(
              itemCount: 5,
              itemBuilder: (_, index) => Text('Item $index'),
            ),
          },
          {
            'description': 'PageView.custom',
            'widget': PageView.custom(
              childrenDelegate: SliverChildBuilderDelegate(
                (_, index) => Text('Custom $index'),
                childCount: 3,
              ),
            ),
          },
        ];

        for (final testCase in testCases) {
          final description = testCase['description'] as String;
          final widget = testCase['widget'] as PageView;

          final skeleton = provider.createSkeleton(widget, baseColor);

          expect(skeleton, isA<PageViewSkeleton>(),
              reason: 'Falló para: $description');

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(PageViewSkeleton), findsOneWidget,
              reason: 'Falló para: $description');

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });
  });
}
