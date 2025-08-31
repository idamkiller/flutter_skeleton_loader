import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/utils/optimized_skeleton_registry.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/default_skeleton.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_skeleton.dart';
import 'package:flutter_skeleton_loader/src/interfaces/skeleton_provider.dart';

void main() {
  group('OptimizedSkeletonRegistry', () {
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      OptimizedSkeletonRegistry.clearCache();
    });

    group('buildSkeleton', () {
      testWidgets('Debería crear un esqueleto para el widget de texto.',
          (tester) async {
        const textWidget = Text('Test Text');
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget, baseColor);

        expect(skeleton, isA<TextSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear un esqueleto para el widget Container.',
          (tester) async {
        final containerWidget = Container(
          width: 100,
          height: 50,
          color: Colors.blue,
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<Widget>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear un esqueleto por defecto para un widget desconocido.',
          (tester) async {
        final unknownWidget = CustomTestWidget();
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(unknownWidget, baseColor);

        expect(skeleton, isA<DefaultSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar SizedBox con hijo', (tester) async {
        const sizedBoxWidget = SizedBox(
          width: 200,
          height: 100,
          child: Text('Child Text'),
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(sizedBoxWidget, baseColor);

        expect(skeleton, isA<SizedBox>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final sizedBoxWidgets =
            tester.widgetList<SizedBox>(find.byType(SizedBox));
        final renderedSizedBox =
            sizedBoxWidgets.firstWhere((widget) => widget.width == 200);
        expect(renderedSizedBox.width, 200);
        expect(renderedSizedBox.height, 100);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar GestureDetector con hijo', (tester) async {
        final gestureWidget = GestureDetector(
          onTap: () {},
          child: const Text('Tappable Text'),
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(gestureWidget, baseColor);

        expect(skeleton, isA<TextSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar GestureDetector sin hijo', (tester) async {
        final gestureWidget = GestureDetector(onTap: () {});
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(gestureWidget, baseColor);

        expect(skeleton, isA<DefaultSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Padding con hijo', (tester) async {
        const paddingWidget = Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Padded Text'),
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(paddingWidget, baseColor);

        expect(skeleton, isA<Padding>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
        final renderedPadding = paddingWidgets.firstWhere(
            (widget) => widget.padding == const EdgeInsets.all(16.0));
        expect(renderedPadding.padding, const EdgeInsets.all(16.0));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Padding sin hijo', (tester) async {
        const paddingWidget = Padding(padding: EdgeInsets.all(8.0));
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(paddingWidget, baseColor);

        expect(skeleton, isA<Padding>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Form con hijo', (tester) async {
        final formWidget = Form(
          child: Column(
            children: const [
              TextField(decoration: InputDecoration(labelText: 'Name')),
              TextField(decoration: InputDecoration(labelText: 'Email')),
            ],
          ),
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(formWidget, baseColor);

        expect(skeleton, isA<Column>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Container con hijo', (tester) async {
        final containerWithChild = Container(
          width: 200,
          height: 100,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(4.0),
          decoration: const BoxDecoration(color: Colors.red),
          child: const Text('Container Child'),
        );
        final skeleton = OptimizedSkeletonRegistry.buildSkeleton(
            containerWithChild, baseColor);

        expect(skeleton, isA<Container>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Row widget', (tester) async {
        const rowWidget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('First'),
            Text('Second'),
            Text('Third'),
          ],
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(rowWidget, baseColor);

        expect(skeleton, isA<Row>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final rowWidgets = tester.widgetList<Row>(find.byType(Row));
        final renderedRow = rowWidgets.firstWhere((widget) =>
            widget.mainAxisAlignment == MainAxisAlignment.spaceEvenly);
        expect(renderedRow.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
        expect(renderedRow.crossAxisAlignment, CrossAxisAlignment.center);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Column widget', (tester) async {
        const columnWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First'),
            Text('Second'),
            Text('Third'),
          ],
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(columnWidget, baseColor);

        expect(skeleton, isA<Column>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final columnWidgets = tester.widgetList<Column>(find.byType(Column));
        final renderedColumn = columnWidgets.firstWhere(
            (widget) => widget.mainAxisAlignment == MainAxisAlignment.center);
        expect(renderedColumn.mainAxisAlignment, MainAxisAlignment.center);
        expect(renderedColumn.crossAxisAlignment, CrossAxisAlignment.start);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Wrap widget', (tester) async {
        const wrapWidget = Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: [
            Text('First'),
            Text('Second'),
            Text('Third'),
          ],
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(wrapWidget, baseColor);

        expect(skeleton, isA<Wrap>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final wrapWidgets = tester.widgetList<Wrap>(find.byType(Wrap));
        final renderedWrap =
            wrapWidgets.firstWhere((widget) => widget.runSpacing == 4.0);
        expect(renderedWrap.runSpacing, 4.0);
        expect(renderedWrap.alignment, WrapAlignment.center);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Card widget', (tester) async {
        const cardWidget = Card(
          elevation: 4,
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Card Content'),
          ),
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(cardWidget, baseColor);

        expect(skeleton, isA<Card>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final cardWidgets = tester.widgetList<Card>(find.byType(Card));
        final renderedCard =
            cardWidgets.firstWhere((widget) => widget.elevation == 4);
        expect(renderedCard.elevation, 4);
        expect(renderedCard.margin, const EdgeInsets.all(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Expanded widget', (tester) async {
        final expandedWidget = Expanded(
          flex: 2,
          child: Container(color: Colors.blue),
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(expandedWidget, baseColor);

        expect(skeleton, isA<SizedBox>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final sizedBoxWidgets =
            tester.widgetList<SizedBox>(find.byType(SizedBox));
        final renderedSizedBox =
            sizedBoxWidgets.firstWhere((widget) => widget.height == 50);
        expect(renderedSizedBox.height, 50);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Flexible widget', (tester) async {
        final flexibleWidget = Flexible(
          flex: 1,
          child: Container(color: Colors.green),
        );
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(flexibleWidget, baseColor);

        expect(skeleton, isA<SizedBox>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final sizedBoxWidgets =
            tester.widgetList<SizedBox>(find.byType(SizedBox));
        final renderedSizedBox =
            sizedBoxWidgets.firstWhere((widget) => widget.height == 50);
        expect(renderedSizedBox.height, 50);
        expect(tester.takeException(), isNull);
      });
    });

    group('caching', () {
      test('Debería almacenar en caché los widgets de esqueleto', () {
        const textWidget = Text('Test Text');

        final skeleton1 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget, baseColor);

        final skeleton2 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget, baseColor);

        expect(identical(skeleton1, skeleton2), isTrue);
      });

      test('Debería generar claves de caché diferentes para widgets diferentes',
          () {
        const textWidget1 = Text('Text 1');
        const textWidget2 = Text('Text 2');

        final skeleton1 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget1, baseColor);
        final skeleton2 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget2, baseColor);

        expect(identical(skeleton1, skeleton2), isFalse);
      });

      test('Debería generar claves de caché diferentes para colores diferentes',
          () {
        const textWidget = Text('Test Text');
        const color1 = Colors.grey;
        const color2 = Colors.blue;

        final skeleton1 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget, color1);
        final skeleton2 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget, color2);

        expect(identical(skeleton1, skeleton2), isFalse);
      });

      test('Debería limpiar la caché correctamente', () {
        const textWidget = Text('Test Text');

        final skeleton1 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget, baseColor);

        OptimizedSkeletonRegistry.clearCache();

        final skeleton2 =
            OptimizedSkeletonRegistry.buildSkeleton(textWidget, baseColor);

        expect(identical(skeleton1, skeleton2), isFalse);
      });
    });

    group('registro de provider', () {
      test('Debería registrar un proveedor personalizado', () {
        final customProvider = CustomTestProvider();

        OptimizedSkeletonRegistry.registerProvider(customProvider);

        final debugInfo = OptimizedSkeletonRegistry.getDebugInfo();
        final providerTypes = debugInfo['provider_types'] as List<String>;

        expect(providerTypes, contains('CustomTestProvider'));
      });

      test('Debería manejar al proveedor personalizado con prioridad.', () {
        final highPriorityProvider = HighPriorityTestProvider();
        OptimizedSkeletonRegistry.registerProvider(highPriorityProvider);

        final customWidget = CustomTestWidget();
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(customWidget, baseColor);

        expect(skeleton, isA<Container>());
      });
    });

    group('error handling', () {
      testWidgets(
          'Debería manejar errores de manera elegante y devolver el esqueleto predeterminado',
          (tester) async {
        final errorWidget = ErrorTestWidget();
        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(errorWidget, baseColor);

        expect(skeleton, isA<DefaultSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });

    group('debug info', () {
      test('Debería proporcionar información de depuración', () {
        OptimizedSkeletonRegistry.clearCache();

        OptimizedSkeletonRegistry.buildSkeleton(
            const Text('Test 1'), baseColor);
        OptimizedSkeletonRegistry.buildSkeleton(
            const Text('Test 2'), baseColor);

        final debugInfo = OptimizedSkeletonRegistry.getDebugInfo();

        expect(debugInfo, isA<Map<String, dynamic>>());
        expect(debugInfo['cached_skeletons'], isA<int>());
        expect(debugInfo['registered_providers'], isA<int>());
        expect(debugInfo['provider_types'], isA<List>());

        expect(debugInfo['cached_skeletons'], greaterThan(0));
        expect(debugInfo['registered_providers'], greaterThan(0));
      });
    });

    group('jerarquías de widgets complejas', () {
      testWidgets('Debería manejar widgets anidados profundamente',
          (tester) async {
        final complexWidget = Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Title'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: const Text('Left'),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: const Text('Right'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
                child: Text('Bottom'),
              ),
            ],
          ),
        );

        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(complexWidget, baseColor);

        expect(skeleton, isA<Container>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería preservar las propiedades del widget correctamente',
          (tester) async {
        final complexCard = Card(
          elevation: 8,
          margin: const EdgeInsets.all(12),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Card Title'),
                SizedBox(height: 8),
                Text('Card Content'),
              ],
            ),
          ),
        );

        final skeleton =
            OptimizedSkeletonRegistry.buildSkeleton(complexCard, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final cardWidgets = tester.widgetList<Card>(find.byType(Card));
        final renderedCard =
            cardWidgets.firstWhere((widget) => widget.elevation == 8);
        expect(renderedCard.elevation, 8);
        expect(renderedCard.margin, const EdgeInsets.all(12));
        expect(renderedCard.color, Colors.white);

        expect(tester.takeException(), isNull);
      });
    });
  });
}

class CustomTestWidget extends StatelessWidget {
  const CustomTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.purple,
    );
  }
}

class ErrorTestWidget extends StatelessWidget {
  const ErrorTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    throw Exception('Test error widget');
  }
}

class CustomTestProvider implements SkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is CustomTestWidget;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return DefaultSkeleton(baseColor: baseColor, width: 50, height: 50);
  }

  @override
  int get priority => 1;
}

class HighPriorityTestProvider implements SkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is CustomTestWidget;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  int get priority => 100;
}
