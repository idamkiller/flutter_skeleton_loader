import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/list_tile_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/list_tile_skeleton.dart';

void main() {
  group('ListTileSkeletonProvider', () {
    late ListTileSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = ListTileSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget ListTile', () {
        const listTileWidget = ListTile(
          title: Text('Título'),
        );

        expect(provider.canHandle(listTileWidget), isTrue);
      });

      test('Debería retornar true para ListTile con leading', () {
        const listTileWidget = ListTile(
          leading: Icon(Icons.person),
          title: Text('Título'),
        );

        expect(provider.canHandle(listTileWidget), isTrue);
      });

      test('Debería retornar true para ListTile con trailing', () {
        const listTileWidget = ListTile(
          title: Text('Título'),
          trailing: Icon(Icons.arrow_forward),
        );

        expect(provider.canHandle(listTileWidget), isTrue);
      });

      test('Debería retornar true para ListTile completo', () {
        const listTileWidget = ListTile(
          leading: Icon(Icons.person),
          title: Text('Título'),
          subtitle: Text('Subtítulo'),
          trailing: Icon(Icons.arrow_forward),
        );

        expect(provider.canHandle(listTileWidget), isTrue);
      });

      test('Debería retornar true para ListTile con propiedades personalizadas',
          () {
        const listTileWidget = ListTile(
          leading: CircleAvatar(child: Text('A')),
          title: Text('Título personalizado'),
          subtitle: Text('Subtítulo personalizado'),
          trailing: Icon(Icons.more_vert),
          dense: true,
          contentPadding: EdgeInsets.all(16),
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(),
          style: ListTileStyle.list,
          selectedColor: Colors.blue,
          iconColor: Colors.red,
          textColor: Colors.black,
          tileColor: Colors.grey,
          selectedTileColor: Colors.lightBlue,
          enableFeedback: true,
          horizontalTitleGap: 8,
          minVerticalPadding: 4,
          minLeadingWidth: 40,
        );

        expect(provider.canHandle(listTileWidget), isTrue);
      });

      test('Debería retornar true para ListTile con gestos', () {
        final listTileWidget = ListTile(
          title: const Text('Título con gestos'),
          onTap: () {},
          onLongPress: () {},
        );

        expect(provider.canHandle(listTileWidget), isTrue);
      });

      test('Debería retornar true para ListTile solo con subtitle', () {
        const listTileWidget = ListTile(
          subtitle: Text('Solo subtítulo'),
        );

        expect(provider.canHandle(listTileWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son ListTile', () {
        const textWidget = Text('No es un ListTile');
        final containerWidget = Container();
        const iconWidget = Icon(Icons.list);
        final cardWidget = Card(child: Container());
        const elevatedButtonWidget =
            ElevatedButton(onPressed: null, child: Text('Botón'));

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
        expect(provider.canHandle(cardWidget), isFalse);
        expect(provider.canHandle(elevatedButtonWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 8', () {
        expect(provider.priority, 8);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear ListTileSkeleton para ListTile básico',
          (tester) async {
        const listTileWidget = ListTile(
          title: Text('Título básico'),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        expect(skeleton, isA<ListTileSkeleton>());

        final listTileSkeleton = skeleton as ListTileSkeleton;
        expect(listTileSkeleton.baseColor, baseColor);

        expect(listTileSkeleton.showLeading, isFalse);
        expect(listTileSkeleton.showTrailing, isFalse);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListTileSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ListTileSkeleton con leading', (tester) async {
        const listTileWidget = ListTile(
          leading: Icon(Icons.person),
          title: Text('Título con leading'),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        expect(skeleton, isA<ListTileSkeleton>());

        final listTileSkeleton = skeleton as ListTileSkeleton;
        expect(listTileSkeleton.baseColor, baseColor);
        expect(listTileSkeleton.showLeading, isTrue);
        expect(listTileSkeleton.showTrailing, isFalse);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(
            find.byKey(const Key('list_tile_skeleton_trailing')), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ListTileSkeleton con trailing',
          (tester) async {
        const listTileWidget = ListTile(
          title: Text('Título con trailing'),
          trailing: Icon(Icons.arrow_forward),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        expect(skeleton, isA<ListTileSkeleton>());

        final listTileSkeleton = skeleton as ListTileSkeleton;
        expect(listTileSkeleton.baseColor, baseColor);
        expect(listTileSkeleton.showLeading, isFalse);
        expect(listTileSkeleton.showTrailing, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(
            find.byKey(const Key('list_tile_skeleton_leading')), findsNothing);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear ListTileSkeleton completo con leading y trailing',
          (tester) async {
        const listTileWidget = ListTile(
          leading: Icon(Icons.person),
          title: Text('Título completo'),
          subtitle: Text('Subtítulo'),
          trailing: Icon(Icons.arrow_forward),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        expect(skeleton, isA<ListTileSkeleton>());

        final listTileSkeleton = skeleton as ListTileSkeleton;
        expect(listTileSkeleton.baseColor, baseColor);
        expect(listTileSkeleton.showLeading, isTrue);
        expect(listTileSkeleton.showTrailing, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(
            find.byKey(const Key('list_tile_skeleton_title')), findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_subtitle')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ListTileSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        const listTileWidget = ListTile(
          leading: Icon(Icons.star, color: Colors.red),
          title: Text('Título', style: TextStyle(color: Colors.green)),
          trailing: Icon(Icons.favorite, color: Colors.purple),
        );

        final skeleton = provider.createSkeleton(listTileWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final leadingContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_leading')));
        final titleContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_title')));
        final subtitleContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_subtitle')));
        final trailingContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_trailing')));

        final leadingDecoration = leadingContainer.decoration as BoxDecoration;
        final titleDecoration = titleContainer.decoration as BoxDecoration;
        final subtitleDecoration =
            subtitleContainer.decoration as BoxDecoration;
        final trailingDecoration =
            trailingContainer.decoration as BoxDecoration;

        expect(leadingDecoration.color, customColor);
        expect(titleDecoration.color, customColor);
        expect(subtitleDecoration.color, customColor);
        expect(trailingDecoration.color, customColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear ListTileSkeleton con las formas correctas',
          (tester) async {
        const listTileWidget = ListTile(
          leading: CircleAvatar(child: Text('A')),
          title: Text('Título'),
          subtitle: Text('Subtítulo'),
          trailing: Icon(Icons.more_vert),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final leadingContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_leading')));
        final titleContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_title')));
        final subtitleContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_subtitle')));
        final trailingContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_trailing')));

        final leadingDecoration = leadingContainer.decoration as BoxDecoration;
        final titleDecoration = titleContainer.decoration as BoxDecoration;
        final subtitleDecoration =
            subtitleContainer.decoration as BoxDecoration;
        final trailingDecoration =
            trailingContainer.decoration as BoxDecoration;

        expect(leadingDecoration.shape, BoxShape.circle);

        expect(titleDecoration.borderRadius, BorderRadius.circular(4));
        expect(subtitleDecoration.borderRadius, BorderRadius.circular(4));
        expect(trailingDecoration.borderRadius, BorderRadius.circular(4));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListTile con diferentes tipos de leading',
          (tester) async {
        final testCases = [
          {
            'widget': const ListTile(
              leading: Icon(Icons.person),
              title: Text('Con Icon'),
            ),
            'hasLeading': true,
          },
          {
            'widget': const ListTile(
              leading: CircleAvatar(child: Text('A')),
              title: Text('Con CircleAvatar'),
            ),
            'hasLeading': true,
          },
          {
            'widget': const ListTile(
              leading: FlutterLogo(),
              title: Text('Con FlutterLogo'),
            ),
            'hasLeading': true,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as ListTile;
          final hasLeading = testCase['hasLeading'] as bool;

          final skeleton = provider.createSkeleton(widget, baseColor);

          expect(skeleton, isA<ListTileSkeleton>());

          final listTileSkeleton = skeleton as ListTileSkeleton;
          expect(listTileSkeleton.showLeading, hasLeading);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          if (hasLeading) {
            expect(find.byKey(const Key('list_tile_skeleton_leading')),
                findsOneWidget);
          } else {
            expect(find.byKey(const Key('list_tile_skeleton_leading')),
                findsNothing);
          }

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListTile con diferentes tipos de trailing',
          (tester) async {
        final testCases = [
          {
            'widget': const ListTile(
              title: Text('Con Icon trailing'),
              trailing: Icon(Icons.arrow_forward),
            ),
            'hasTrailing': true,
          },
          {
            'widget': const ListTile(
              title: Text('Con Text trailing'),
              trailing: Text('>'),
            ),
            'hasTrailing': true,
          },
          {
            'widget': const ListTile(
              title: Text('Con Switch trailing'),
              trailing: Switch(value: true, onChanged: null),
            ),
            'hasTrailing': true,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as ListTile;
          final hasTrailing = testCase['hasTrailing'] as bool;

          final skeleton = provider.createSkeleton(widget, baseColor);

          expect(skeleton, isA<ListTileSkeleton>());

          final listTileSkeleton = skeleton as ListTileSkeleton;
          expect(listTileSkeleton.showTrailing, hasTrailing);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          if (hasTrailing) {
            expect(find.byKey(const Key('list_tile_skeleton_trailing')),
                findsOneWidget);
          } else {
            expect(find.byKey(const Key('list_tile_skeleton_trailing')),
                findsNothing);
          }

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería ignorar propiedades de diseño personalizadas',
          (tester) async {
        const listTileWidget = ListTile(
          leading: Icon(Icons.person),
          title: Text('Título personalizado'),
          subtitle: Text('Subtítulo personalizado'),
          trailing: Icon(Icons.arrow_forward),
          dense: true,
          contentPadding: EdgeInsets.all(32),
          visualDensity: VisualDensity.comfortable,
          shape: RoundedRectangleBorder(),
          tileColor: Colors.red,
          selectedTileColor: Colors.blue,
          textColor: Colors.green,
          iconColor: Colors.purple,
          horizontalTitleGap: 24,
          minVerticalPadding: 16,
          minLeadingWidth: 60,
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final skeletonWidget =
            tester.widget<ListTileSkeleton>(find.byType(ListTileSkeleton));
        expect(skeletonWidget.baseColor, baseColor);

        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListTile con gestos', (tester) async {
        final listTileWidget = ListTile(
          leading: const Icon(Icons.touch_app),
          title: const Text('ListTile con gestos'),
          trailing: const Icon(Icons.gesture),
          onTap: () {},
          onLongPress: () {},
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        expect(skeleton, isA<ListTileSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListTileSkeleton), findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('detección de elementos', () {
      test('Debería detectar correctamente la presencia de leading', () {
        final testCases = [
          {
            'widget': const ListTile(title: Text('Sin leading')),
            'expectedLeading': false,
          },
          {
            'widget': const ListTile(
              leading: Icon(Icons.person),
              title: Text('Con leading'),
            ),
            'expectedLeading': true,
          },
          {
            'widget': const ListTile(
              leading: CircleAvatar(child: Text('A')),
              title: Text('Con CircleAvatar'),
            ),
            'expectedLeading': true,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as ListTile;
          final expectedLeading = testCase['expectedLeading'] as bool;

          final skeleton = provider.createSkeleton(widget, baseColor);
          final listTileSkeleton = skeleton as ListTileSkeleton;

          expect(listTileSkeleton.showLeading, expectedLeading);
        }
      });

      test('Debería detectar correctamente la presencia de trailing', () {
        final testCases = [
          {
            'widget': const ListTile(title: Text('Sin trailing')),
            'expectedTrailing': false,
          },
          {
            'widget': const ListTile(
              title: Text('Con trailing'),
              trailing: Icon(Icons.arrow_forward),
            ),
            'expectedTrailing': true,
          },
          {
            'widget': const ListTile(
              title: Text('Con Text trailing'),
              trailing: Text('>>'),
            ),
            'expectedTrailing': true,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as ListTile;
          final expectedTrailing = testCase['expectedTrailing'] as bool;

          final skeleton = provider.createSkeleton(widget, baseColor);
          final listTileSkeleton = skeleton as ListTileSkeleton;

          expect(listTileSkeleton.showTrailing, expectedTrailing);
        }
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<ListTileSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        const listTileWidget = ListTile(title: Text('Test'));

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(listTileWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar ListTile vacío', (tester) async {
        const listTileWidget = ListTile();

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListTileSkeleton), findsOneWidget);
        expect(
            find.byKey(const Key('list_tile_skeleton_leading')), findsNothing);
        expect(
            find.byKey(const Key('list_tile_skeleton_trailing')), findsNothing);
        expect(
            find.byKey(const Key('list_tile_skeleton_title')), findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_subtitle')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy oscuro', (tester) async {
        const darkColor = Color(0xFF000000);
        const listTileWidget = ListTile(
          leading: Icon(Icons.dark_mode),
          title: Text('Modo oscuro'),
        );

        final skeleton = provider.createSkeleton(listTileWidget, darkColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final leadingContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_leading')));
        final titleContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_title')));

        final leadingDecoration = leadingContainer.decoration as BoxDecoration;
        final titleDecoration = titleContainer.decoration as BoxDecoration;

        expect(leadingDecoration.color, darkColor);
        expect(titleDecoration.color, darkColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy claro', (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        const listTileWidget = ListTile(
          leading: Icon(Icons.light_mode),
          title: Text('Modo claro'),
        );

        final skeleton = provider.createSkeleton(listTileWidget, lightColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final leadingContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_leading')));
        final titleContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_title')));

        final leadingDecoration = leadingContainer.decoration as BoxDecoration;
        final titleDecoration = titleContainer.decoration as BoxDecoration;

        expect(leadingDecoration.color, lightColor);
        expect(titleDecoration.color, lightColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar ListTile con widgets complejos en leading y trailing',
          (tester) async {
        final listTileWidget = ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.rectangle,
            ),
            child: const Icon(Icons.settings),
          ),
          title: const Text('Widget complejo'),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.star),
              Text('Rating'),
            ],
          ),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        expect(skeleton, isA<ListTileSkeleton>());

        final listTileSkeleton = skeleton as ListTileSkeleton;
        expect(listTileSkeleton.showLeading, isTrue);
        expect(listTileSkeleton.showTrailing, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListTile con selected y enabled',
          (tester) async {
        const listTileWidget = ListTile(
          leading: Icon(Icons.check),
          title: Text('Item seleccionado'),
          trailing: Icon(Icons.check_circle),
          selected: true,
          enabled: false,
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListTileSkeleton), findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de ListTile', () {
      testWidgets('Debería manejar ListTile en ListView', (tester) async {
        const listTileWidget = ListTile(
          leading: Icon(Icons.list),
          title: Text('Item de lista'),
          subtitle: Text('Descripción del item'),
          trailing: Icon(Icons.keyboard_arrow_right),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [skeleton],
              ),
            ),
          ),
        );

        expect(find.byType(ListTileSkeleton), findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListTile de contacto', (tester) async {
        const listTileWidget = ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
          ),
          title: Text('Juan Pérez'),
          subtitle: Text('+1 234 567 8900'),
          trailing: Icon(Icons.call),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListTileSkeleton), findsOneWidget);

        final leadingContainer = tester.widget<Container>(
            find.byKey(const Key('list_tile_skeleton_leading')));
        final leadingDecoration = leadingContainer.decoration as BoxDecoration;
        expect(leadingDecoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListTile de configuración', (tester) async {
        const listTileWidget = ListTile(
          leading: Icon(Icons.settings),
          title: Text('Configuración'),
          subtitle: Text('Ajustes de la aplicación'),
          trailing: Switch(value: true, onChanged: null),
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ListTileSkeleton), findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_leading')),
            findsOneWidget);
        expect(find.byKey(const Key('list_tile_skeleton_trailing')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar ListTile de notificación', (tester) async {
        const listTileWidget = ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Nueva notificación'),
          subtitle: Text('Hace 2 minutos'),
          trailing: Icon(Icons.more_vert),
          dense: true,
        );

        final skeleton = provider.createSkeleton(listTileWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final skeletonWidget =
            tester.widget<ListTileSkeleton>(find.byType(ListTileSkeleton));
        expect(skeletonWidget.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar múltiples ListTile con diferentes configuraciones',
          (tester) async {
        final testCases = [
          {
            'widget': const ListTile(
              title: Text('Solo título'),
            ),
            'expectedLeading': false,
            'expectedTrailing': false,
          },
          {
            'widget': const ListTile(
              leading: Icon(Icons.person),
              title: Text('Con leading'),
            ),
            'expectedLeading': true,
            'expectedTrailing': false,
          },
          {
            'widget': const ListTile(
              title: Text('Con trailing'),
              trailing: Icon(Icons.arrow_forward),
            ),
            'expectedLeading': false,
            'expectedTrailing': true,
          },
          {
            'widget': const ListTile(
              leading: Icon(Icons.star),
              title: Text('Completo'),
              subtitle: Text('Con todo'),
              trailing: Icon(Icons.favorite),
            ),
            'expectedLeading': true,
            'expectedTrailing': true,
          },
        ];

        for (final testCase in testCases) {
          final widget = testCase['widget'] as ListTile;
          final expectedLeading = testCase['expectedLeading'] as bool;
          final expectedTrailing = testCase['expectedTrailing'] as bool;

          final skeleton = provider.createSkeleton(widget, baseColor);

          expect(skeleton, isA<ListTileSkeleton>());

          final listTileSkeleton = skeleton as ListTileSkeleton;
          expect(listTileSkeleton.showLeading, expectedLeading);
          expect(listTileSkeleton.showTrailing, expectedTrailing);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(ListTileSkeleton), findsOneWidget);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });
  });
}
