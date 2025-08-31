import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/list_view_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/list_view_skeleton.dart';

void main() {
  group('ListViewSkeletonProvider', () {
    late ListViewSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = ListViewSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget ListView', () {
        final listViewWidget = ListView(
          children: const [
            Text('Item 1'),
            Text('Item 2'),
          ],
        );

        expect(provider.canHandle(listViewWidget), isTrue);
      });

      test('Debería retornar true para ListView.builder', () {
        final listViewWidget = ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Text('Item $index'),
        );

        expect(provider.canHandle(listViewWidget), isTrue);
      });

      test('Debería retornar true para ListView.separated', () {
        final listViewWidget = ListView.separated(
          itemCount: 3,
          itemBuilder: (context, index) => Text('Item $index'),
          separatorBuilder: (context, index) => const Divider(),
        );

        expect(provider.canHandle(listViewWidget), isTrue);
      });

      test('Debería retornar true para ListView con scrollDirection horizontal',
          () {
        final listViewWidget = ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            Text('Item H1'),
            Text('Item H2'),
          ],
        );

        expect(provider.canHandle(listViewWidget), isTrue);
      });

      test('Debería retornar true para ListView con propiedades personalizadas',
          () {
        final listViewWidget = ListView(
          scrollDirection: Axis.vertical,
          reverse: true,
          controller: ScrollController(),
          primary: false,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemExtent: 100,
          children: const [
            Text('Custom Item 1'),
            Text('Custom Item 2'),
          ],
        );

        expect(provider.canHandle(listViewWidget), isTrue);
      });

      test('Debería retornar true para ListView.custom', () {
        final listViewWidget = ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) => Text('Custom Item $index'),
            childCount: 4,
          ),
        );

        expect(provider.canHandle(listViewWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son ListView', () {
        const textWidget = Text('No es un ListView');
        final containerWidget = Container();
        const iconWidget = Icon(Icons.list);
        final columnWidget = Column(children: const [Text('Item')]);
        final gridViewWidget = GridView.count(crossAxisCount: 2);
        final singleChildScrollViewWidget =
            SingleChildScrollView(child: Container());

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
        expect(provider.canHandle(columnWidget), isFalse);
        expect(provider.canHandle(gridViewWidget), isFalse);
        expect(provider.canHandle(singleChildScrollViewWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 9', () {
        expect(provider.priority, 9);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear ListViewSkeleton para ListView básico',
          (tester) async {
        final listViewWidget = ListView(
          children: const [
            Text('Item 1'),
            Text('Item 2'),
            Text('Item 3'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        expect(skeleton, isA<ListViewSkeleton>());

        final listViewSkeleton = skeleton as ListViewSkeleton;
        expect(listViewSkeleton.baseColor, baseColor);
        expect(listViewSkeleton.scrollDirection, Axis.vertical);
        expect(listViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ListViewSkeleton con scrollDirection vertical',
          (tester) async {
        final listViewWidget = ListView(
          scrollDirection: Axis.vertical,
          children: const [
            Text('Vertical Item 1'),
            Text('Vertical Item 2'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        expect(skeleton, isA<ListViewSkeleton>());

        final listViewSkeleton = skeleton as ListViewSkeleton;
        expect(listViewSkeleton.baseColor, baseColor);
        expect(listViewSkeleton.scrollDirection, Axis.vertical);
        expect(listViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.scrollDirection, Axis.vertical);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear ListViewSkeleton con scrollDirection horizontal',
          (tester) async {
        final listViewWidget = ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            Text('Horizontal Item 1'),
            Text('Horizontal Item 2'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        expect(skeleton, isA<ListViewSkeleton>());

        final listViewSkeleton = skeleton as ListViewSkeleton;
        expect(listViewSkeleton.baseColor, baseColor);
        expect(listViewSkeleton.scrollDirection, Axis.horizontal);
        expect(listViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.scrollDirection, Axis.horizontal);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ListViewSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        final listViewWidget = ListView(
          children: const [
            Text('Item con color personalizado'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, customColor);

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

      testWidgets('Debería crear ListViewSkeleton con bordes redondeados',
          (tester) async {
        final listViewWidget = ListView(
          children: const [
            Text('Item para verificar bordes'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

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

      testWidgets('Debería manejar ListView.builder', (tester) async {
        final listViewWidget = ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Text('Builder Item $index'),
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        expect(skeleton, isA<ListViewSkeleton>());

        final listViewSkeleton = skeleton as ListViewSkeleton;
        expect(listViewSkeleton.scrollDirection, Axis.vertical);
        expect(listViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListView.separated', (tester) async {
        final listViewWidget = ListView.separated(
          itemCount: 5,
          itemBuilder: (context, index) => Text('Separated Item $index'),
          separatorBuilder: (context, index) => const Divider(),
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        expect(skeleton, isA<ListViewSkeleton>());

        final listViewSkeleton = skeleton as ListViewSkeleton;
        expect(listViewSkeleton.scrollDirection, Axis.vertical);
        expect(listViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería ignorar propiedades personalizadas del ListView original',
          (tester) async {
        final listViewWidget = ListView(
          scrollDirection: Axis.vertical,
          reverse: true,
          controller: ScrollController(),
          primary: false,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(32),
          itemExtent: 150,
          children: const [
            Text('Item con propiedades personalizadas'),
            Text('Otro item'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.scrollDirection, Axis.vertical);
        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListView con diferentes scrollDirection',
          (tester) async {
        final testCases = [
          {
            'scrollDirection': Axis.vertical,
            'description': 'vertical',
          },
          {
            'scrollDirection': Axis.horizontal,
            'description': 'horizontal',
          },
        ];

        for (final testCase in testCases) {
          final scrollDirection = testCase['scrollDirection'] as Axis;
          final description = testCase['description'] as String;

          final listViewWidget = ListView(
            scrollDirection: scrollDirection,
            children: [
              Text('Item $description 1'),
              Text('Item $description 2'),
            ],
          );

          final skeleton = provider.createSkeleton(listViewWidget, baseColor);

          expect(skeleton, isA<ListViewSkeleton>());

          final listViewSkeleton = skeleton as ListViewSkeleton;
          expect(listViewSkeleton.scrollDirection, scrollDirection);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final listView = tester.widget<ListView>(find.byType(ListView));
          expect(listView.scrollDirection, scrollDirection);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear exactamente 3 items por defecto',
          (tester) async {
        final listViewWidget = ListView(
          children: const [
            Text('Item 1'),
            Text('Item 2'),
            Text('Item 3'),
            Text('Item 4'),
            Text('Item 5'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containers = tester.widgetList<Container>(find.byType(Container));

        final skeletonItems = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration &&
              decoration.color == baseColor &&
              decoration.borderRadius == BorderRadius.circular(8);
        }).toList();

        expect(skeletonItems.length, 3);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListView.custom', (tester) async {
        final listViewWidget = ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) => Text('Custom Item $index'),
            childCount: 8,
          ),
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        expect(skeleton, isA<ListViewSkeleton>());

        final listViewSkeleton = skeleton as ListViewSkeleton;
        expect(listViewSkeleton.itemCount, 3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('configuración del skeleton', () {
      test('Debería usar itemCount fijo de 3', () {
        final testCases = [
          ListView(children: const [Text('1')]),
          ListView(children: const [Text('1'), Text('2')]),
          ListView(children: const [
            Text('1'),
            Text('2'),
            Text('3'),
            Text('4'),
            Text('5')
          ]),
          ListView.builder(
              itemCount: 100, itemBuilder: (_, __) => const Text('Item')),
        ];

        for (final listViewWidget in testCases) {
          final skeleton = provider.createSkeleton(listViewWidget, baseColor);
          final listViewSkeleton = skeleton as ListViewSkeleton;

          expect(listViewSkeleton.itemCount, 3);
        }
      });

      test('Debería preservar scrollDirection del ListView original', () {
        final testCases = [
          {
            'widget': ListView(
                scrollDirection: Axis.vertical, children: const [Text('V')]),
            'expectedDirection': Axis.vertical,
          },
          {
            'widget': ListView(
                scrollDirection: Axis.horizontal, children: const [Text('H')]),
            'expectedDirection': Axis.horizontal,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as ListView;
          final expectedDirection = testCase['expectedDirection'] as Axis;

          final skeleton = provider.createSkeleton(widget, baseColor);
          final listViewSkeleton = skeleton as ListViewSkeleton;

          expect(listViewSkeleton.scrollDirection, expectedDirection);
        }
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<ListViewSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        final listViewWidget = ListView(children: const [Text('Test')]);

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(listViewWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar ListView vacío', (tester) async {
        final listViewWidget = ListView(children: const []);

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        final containers = tester.widgetList<Container>(find.byType(Container));
        final skeletonItems = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.color == baseColor;
        }).toList();

        expect(skeletonItems.length, 3);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy oscuro', (tester) async {
        const darkColor = Color(0xFF000000);
        final listViewWidget = ListView(
          children: const [
            Text('Item oscuro'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, darkColor);

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
        final listViewWidget = ListView(
          children: const [
            Text('Item claro'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, lightColor);

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

      testWidgets('Debería manejar ListView con elementos complejos',
          (tester) async {
        final listViewWidget = ListView(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Text('A')),
                title: const Text('Elemento complejo 1'),
                subtitle: const Text('Con múltiples widgets'),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ),
            ),
            Container(
              height: 100,
              color: Colors.blue,
              child: const Center(child: Text('Container personalizado')),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Texto con padding'),
            ),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        final containers = tester.widgetList<Container>(find.byType(Container));
        final skeletonItems = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration &&
              decoration.color == baseColor &&
              decoration.borderRadius == BorderRadius.circular(8);
        }).toList();

        expect(skeletonItems.length, 3);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar ListView con scrollController y physics personalizados',
          (tester) async {
        final controller = ScrollController();
        final listViewWidget = ListView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            Text('Item con controller'),
            Text('Item con physics'),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);

        controller.dispose();
      });
    });

    group('escenarios específicos de ListView', () {
      testWidgets('Debería manejar ListView en una pantalla de carga',
          (tester) async {
        final listViewWidget = ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('Contacto ${index + 1}'),
            subtitle: Text(
                'Teléfono: +1 234 567 ${index.toString().padLeft(4, '0')}'),
            trailing: const Icon(Icons.call),
          ),
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Contactos')),
              body: skeleton,
            ),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListView horizontal para galería',
          (tester) async {
        final listViewWidget = ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (int i = 0; i < 10; i++)
              Container(
                width: 150,
                height: 100,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('Imagen $i')),
              ),
          ],
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.scrollDirection, Axis.horizontal);
        expect(find.byType(ListViewSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListView.separated para lista con divisores',
          (tester) async {
        final listViewWidget = ListView.separated(
          itemCount: 15,
          itemBuilder: (context, index) => Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.star),
                const SizedBox(width: 16),
                Text('Elemento favorito ${index + 1}'),
              ],
            ),
          ),
          separatorBuilder: (context, index) => const Divider(height: 1),
        );

        final skeleton = provider.createSkeleton(listViewWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListViewSkeleton), findsOneWidget);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final skeletonItems = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.color == baseColor;
        }).toList();

        expect(skeletonItems.length, 3);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListView con diferentes tipos de contenido',
          (tester) async {
        final testCases = [
          {
            'description': 'Lista de texto simple',
            'widget': ListView(
              children: const [
                Text('Texto 1'),
                Text('Texto 2'),
                Text('Texto 3'),
              ],
            ),
          },
          {
            'description': 'Lista de cards',
            'widget': ListView(
              children: const [
                Card(child: ListTile(title: Text('Card 1'))),
                Card(child: ListTile(title: Text('Card 2'))),
              ],
            ),
          },
          {
            'description': 'Lista mixta',
            'widget': ListView(
              children: [
                const Text('Encabezado'),
                Container(height: 50, color: Colors.blue),
                const ListTile(title: Text('Item de lista')),
              ],
            ),
          },
        ];

        for (final testCase in testCases) {
          final description = testCase['description'] as String;
          final widget = testCase['widget'] as ListView;

          final skeleton = provider.createSkeleton(widget, baseColor);

          expect(skeleton, isA<ListViewSkeleton>(),
              reason: 'Falló para: $description');

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(ListViewSkeleton), findsOneWidget,
              reason: 'Falló para: $description');

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });
  });
}
