import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeleton_builder.dart';

void main() {
  group('SkeletonBuilder', () {
    const baseColor = Color(0xFFE0E0E0);

    test('Debe crearse con el color base requerido', () {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      expect(builder.baseColor, equals(baseColor));
    });

    testWidgets('Debería crear esqueletos para los widgets de texto.',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);
      final originalWidget = const Text('Test Text');
      final skeletonWidget = builder.buildSkeleton(originalWidget);

      expect(skeletonWidget, isA<Widget>());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets(
        'Debería construir esqueletos apropiados para los widgets de contenedor',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      final containerWidget = Container(
        width: 100,
        height: 50,
        color: Colors.blue,
      );

      final containerSkeleton = builder.buildSkeleton(containerWidget);

      expect(containerSkeleton, isA<Widget>());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: containerSkeleton,
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);

      final containers = tester.widgetList<Container>(find.byType(Container));
      bool foundOriginalBlueContainer = false;
      for (final container in containers) {
        if (container.color == Colors.blue) {
          foundOriginalBlueContainer = true;
          break;
        }
      }

      expect(foundOriginalBlueContainer, isFalse);
    });

    testWidgets('Debería pasar el color base a los esqueletos generados',
        (WidgetTester tester) async {
      const customColor = Color(0xFF112233);
      final builder = const SkeletonBuilder(baseColor: customColor);

      await tester.pumpWidget(
        MaterialApp(
          home: builder.buildSkeleton(const Text('Test')),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar jerarquías de widgets complejas',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      final complexWidget = Column(
        children: [
          const Text('Title'),
          Row(
            children: [
              const Icon(Icons.star),
              const Text('4.5'),
              Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button'),
          ),
        ],
      );

      final skeletonWidget = builder.buildSkeleton(complexWidget);

      expect(skeletonWidget, isA<Widget>());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar widgets SizedBox correctamente',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      const sizedBoxWidget = SizedBox(
        width: 200,
        height: 100,
        child: Text('Inside SizedBox'),
      );

      final skeletonWidget = builder.buildSkeleton(sizedBoxWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.any((box) => box.width == 200 && box.height == 100),
          isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar widgets Padding correctamente',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      const paddingWidget = Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Padded Text'),
      );

      final skeletonWidget = builder.buildSkeleton(paddingWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar widgets GestureDetector correctamente',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      final gestureWidget = GestureDetector(
        onTap: () {},
        child: const Text('Tappable Text'),
      );

      final skeletonWidget = builder.buildSkeleton(gestureWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(find.text('Tappable Text'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar correctamente el contenedor con hijo',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      final containerWithChild = Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(color: Colors.red),
        child: const Text('Container Child'),
      );

      final skeletonWidget = builder.buildSkeleton(containerWithChild);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.text('Container Child'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar correctamente los widgets Row y Column',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      const rowWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('First'),
          Text('Second'),
          Text('Third'),
        ],
      );

      final skeletonWidget = builder.buildSkeleton(rowWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar correctamente los widgets Icon',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      const iconWidget = Icon(Icons.star, size: 32);

      final skeletonWidget = builder.buildSkeleton(iconWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(skeletonWidget, isA<Widget>());
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar correctamente los widgets ListView',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      final listViewWidget = ListView(
        children: const [
          Text('Item 1'),
          Text('Item 2'),
          Text('Item 3'),
        ],
      );

      final skeletonWidget = builder.buildSkeleton(listViewWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(skeletonWidget, isA<Widget>());
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar correctamente los widgets Form',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      final formWidget = Form(
        child: Column(
          children: const [
            TextField(decoration: InputDecoration(labelText: 'Name')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
          ],
        ),
      );

      final skeletonWidget = builder.buildSkeleton(formWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(skeletonWidget, isA<Widget>());
      expect(tester.takeException(), isNull);
    });

    testWidgets('Debería manejar correctamente los widgets Card',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      const cardWidget = Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Card Content'),
        ),
      );

      final skeletonWidget = builder.buildSkeleton(cardWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Debería usar el esqueleto predeterminado para widgets desconocidos',
        (WidgetTester tester) async {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      final customWidget = const CustomTestWidget();

      final skeletonWidget = builder.buildSkeleton(customWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonWidget,
          ),
        ),
      );

      expect(skeletonWidget, isA<Widget>());
      expect(tester.takeException(), isNull);
    });

    test(
        'Debería manejar múltiples construcciones de esqueleto con los mismos parámetros',
        () {
      final builder = const SkeletonBuilder(baseColor: baseColor);
      const textWidget = Text('Test');

      final skeleton1 = builder.buildSkeleton(textWidget);
      final skeleton2 = builder.buildSkeleton(textWidget);

      expect(skeleton1, isA<Widget>());
      expect(skeleton2, isA<Widget>());
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
