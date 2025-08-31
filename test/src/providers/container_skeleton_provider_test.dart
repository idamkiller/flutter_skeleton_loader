import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/container_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/container_skeleton.dart';

void main() {
  group('ContainerSkeletonProvider', () {
    late ContainerSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = ContainerSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería devolver verdadero para el widget Container', () {
        final containerWidget = Container(
          width: 100,
          height: 50,
          color: Colors.blue,
        );

        expect(provider.canHandle(containerWidget), isTrue);
      });

      test('Debería devolver verdadero para Container con child', () {
        final containerWidget = Container(
          color: Colors.green,
          width: 200,
          height: 100,
          child: const Text('Content'),
        );

        expect(provider.canHandle(containerWidget), isTrue);
      });

      test('Debería devolver verdadero para Container con decoration', () {
        final containerWidget = Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: const Text('Decorated'),
        );

        expect(provider.canHandle(containerWidget), isTrue);
      });

      test('Debería devolver verdadero para Container con constraints', () {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            minWidth: 50,
            maxWidth: 200,
            minHeight: 30,
            maxHeight: 150,
          ),
        );

        expect(provider.canHandle(containerWidget), isTrue);
      });

      test('Debería devolver verdadero para Container vacío', () {
        final containerWidget = Container();

        expect(provider.canHandle(containerWidget), isTrue);
      });

      test('Debería devolver falso para widgets que no son Container', () {
        const textWidget = Text('Not a container');
        const iconWidget = Icon(Icons.home);
        const buttonWidget =
            ElevatedButton(onPressed: null, child: Text('Button'));

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
        expect(provider.canHandle(buttonWidget), isFalse);
      });
    });

    group('priority', () {
      test('Debería devolver prioridad 8', () {
        expect(provider.priority, 8);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear ContainerSkeleton para Container básico',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 150,
            maxHeight: 75,
          ),
          color: Colors.blue,
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.baseColor, baseColor);
        expect(containerSkeleton.width, 150.0);
        expect(containerSkeleton.height, 75.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ContainerSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear ContainerSkeleton con dimensiones predeterminadas para Container vacío',
          (tester) async {
        final containerWidget = Container();

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.baseColor, baseColor);
        expect(containerSkeleton.width, 100.0);
        expect(containerSkeleton.height, 100.0);

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

      testWidgets('Debería crear ContainerSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.red;
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 100,
            maxHeight: 100,
          ),
          color: Colors.blue,
        );

        final skeleton = provider.createSkeleton(containerWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidgets =
            tester.widgetList<Container>(find.byType(Container));
        final skeletonContainer = containerWidgets.last;
        final decoration = skeletonContainer.decoration as BoxDecoration;
        expect(decoration.color, customColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar Container con constraints - maxWidth y maxHeight',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 200,
            maxHeight: 150,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.width, 200.0);
        expect(containerSkeleton.height, 150.0);

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

      testWidgets(
          'Debería manejar Container con constraints - minWidth y minHeight cuando max es infinito',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            minWidth: 80,
            minHeight: 60,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.width, 80.0);
        expect(containerSkeleton.height, 60.0);

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

      testWidgets('Debería manejar Container con constraints mixtas',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            minWidth: 50,
            maxWidth: 300,
            minHeight: 40,
            maxHeight: 200,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.width, 300.0);
        expect(containerSkeleton.height, 200.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Container con constraints infinitas',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.width, 100.0);
        expect(containerSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar Container con constraints de cero o negativas',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 0,
            maxHeight: 0,
            minWidth: 0,
            minHeight: 0,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.width, 100.0);
        expect(containerSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Container con widget hijo', (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 120,
            maxHeight: 80,
          ),
          child: const Column(
            children: [
              Text('Title'),
              Text('Content'),
            ],
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('Title'), findsNothing);
        expect(find.text('Content'), findsNothing);
        expect(find.byType(ContainerSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Container con decoración compleja',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 100,
            maxHeight: 100,
          ),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.green],
            ),
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidgets =
            tester.widgetList<Container>(find.byType(Container));
        final skeletonContainer = containerWidgets.last;
        final decoration = skeletonContainer.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(decoration.border, isNull);
        expect(decoration.boxShadow, isNull);
        expect(decoration.gradient, isNull);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Container con padding y margin',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 150,
            maxHeight: 100,
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: const Text('Padded Content'),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<ContainerSkeleton>());

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.width, 150.0);
        expect(containerSkeleton.height, 100.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('Padded Content'), findsNothing);
        expect(find.byType(ContainerSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('sanitización de dimensiones', () {
      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 200,
            maxHeight: 150,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);
        final containerSkeleton = skeleton as ContainerSkeleton;

        expect(containerSkeleton.width, 200.0);
        expect(containerSkeleton.height, 150.0);

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

      testWidgets('Debería usar default cuando no hay dimensiones válidas',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            minWidth: 0,
            minHeight: 0,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);
        final containerSkeleton = skeleton as ContainerSkeleton;

        expect(containerSkeleton.width, 100.0);
        expect(containerSkeleton.height, 100.0);

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
        expect(provider, isA<ContainerSkeletonProvider>());
      });

      test('Debería implementar métodos requeridos', () {
        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(Container(), baseColor),
            returnsNormally);
      });
    });

    group('casos límite', () {
      testWidgets('Debería manejar dimensiones muy pequeñas', (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 1,
            maxHeight: 1,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ContainerSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar dimensiones muy grandes', (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 1000,
            maxHeight: 800,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        final containerSkeleton = skeleton as ContainerSkeleton;
        expect(containerSkeleton.width, 1000.0);
        expect(containerSkeleton.height, 800.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ContainerSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar muy oscuro color base', (tester) async {
        const darkColor = Color(0xFF000000);
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 100,
            maxHeight: 100,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, darkColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidgets =
            tester.widgetList<Container>(find.byType(Container));
        final skeletonContainer = containerWidgets.last;
        final decoration = skeletonContainer.decoration as BoxDecoration;
        expect(decoration.color, darkColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar muy claro color base', (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 80,
            maxHeight: 60,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, lightColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidgets =
            tester.widgetList<Container>(find.byType(Container));
        final skeletonContainer = containerWidgets.last;
        final decoration = skeletonContainer.decoration as BoxDecoration;
        expect(decoration.color, lightColor);
        expect(tester.takeException(), isNull);
      });
    });

    group('Escenarios específicos de Container', () {
      testWidgets('Debería manejar Container usado como tarjeta',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
            maxHeight: 200,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Card Title'),
                Text('Card Content'),
              ],
            ),
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('Card Title'), findsNothing);
        expect(find.text('Card Content'), findsNothing);
        expect(find.byType(ContainerSkeleton), findsOneWidget);

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 300.0);
        expect(size.height, 200.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Container usado como espaciador',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 20,
            maxHeight: 20,
          ),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(ContainerSkeleton), findsOneWidget);

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 20.0);
        expect(size.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Container con comportamiento de ClipRRect',
          (tester) async {
        final containerWidget = Container(
          constraints: const BoxConstraints(
            maxWidth: 150,
            maxHeight: 150,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(75),
            color: Colors.blue,
          ),
          child: const Icon(Icons.person, size: 100),
        );

        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(Icon), findsNothing);
        expect(find.byType(ContainerSkeleton), findsOneWidget);

        final containerWidgets =
            tester.widgetList<Container>(find.byType(Container));
        final skeletonContainer = containerWidgets.last;
        final decoration = skeletonContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });
    });
  });
}
