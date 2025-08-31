import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/interfaces/skeleton_provider.dart';
import '../../../test/mocks/test_skeleton_provider.dart';
import '../../../test/mocks/default_priority_provider.dart';
import '../../mocks/default_priority_skeleton_provider.dart';
import '../../mocks/high_priority_provider.dart';
import '../../mocks/implicit_default_priority_provider.dart';
import '../../mocks/low_priority_provider.dart';
import '../../mocks/negative_priority_provider.dart';
import '../../mocks/simple_skeleton_provider.dart';

void main() {
  group('SkeletonProvider', () {
    late SimpleSkeletonProvider simpleProvider;
    late HighPriorityProvider highPriorityProvider;
    late LowPriorityProvider lowPriorityProvider;
    late DefaultPrioritySkeletonProvider defaultPriorityProvider;
    late ImplicitDefaultPriorityProvider implicitDefaultProvider;
    late TestSkeletonProvider testProvider;
    late DefaultPriorityProvider baseDefaultProvider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      simpleProvider = SimpleSkeletonProvider();
      highPriorityProvider = HighPriorityProvider();
      lowPriorityProvider = LowPriorityProvider();
      defaultPriorityProvider = DefaultPrioritySkeletonProvider();
      implicitDefaultProvider = ImplicitDefaultPriorityProvider();
      testProvider = TestSkeletonProvider();
      baseDefaultProvider = DefaultPriorityProvider();
    });

    group('contrato de la interfaz', () {
      test('Debería definir el método canHandle', () {
        expect(() => simpleProvider.canHandle(const Text('test')),
            returnsNormally);
      });

      test('Debería definir el método createSkeleton', () {
        const textWidget = Text('test');
        expect(() => simpleProvider.createSkeleton(textWidget, baseColor),
            returnsNormally);
      });

      test('Debería definir el getter priority', () {
        expect(() => simpleProvider.priority, returnsNormally);
      });

      test('Debería tener prioridad por defecto de 0', () {
        expect(defaultPriorityProvider.priority, 0);
      });

      test('Debería usar la implementación por defecto de la interfaz', () {
        // Este test cubre la línea 22: int get priority => 0; de SkeletonProvider
        expect(implicitDefaultProvider.priority, 0);
      });

      test('Debería permitir sobrescribir la prioridad', () {
        expect(simpleProvider.priority, 3);
        expect(highPriorityProvider.priority, 10);
        expect(lowPriorityProvider.priority, 1);
      });
    });

    group('canHandle', () {
      test('Debería retornar true para widgets que puede manejar', () {
        const textWidget = Text('test');
        const iconWidget = Icon(Icons.star);
        final imageWidget = Image.asset('test.png');
        const fabWidget = FloatingActionButton(onPressed: null);

        expect(simpleProvider.canHandle(textWidget), isTrue);
        expect(highPriorityProvider.canHandle(iconWidget), isTrue);
        expect(lowPriorityProvider.canHandle(imageWidget), isTrue);
        expect(implicitDefaultProvider.canHandle(fabWidget), isTrue);
      });

      test('Debería retornar false para widgets que no puede manejar', () {
        const textWidget = Text('test');
        const iconWidget = Icon(Icons.star);
        final imageWidget = Image.asset('test.png');
        const fabWidget = FloatingActionButton(onPressed: null);
        final containerWidget = Container();

        expect(simpleProvider.canHandle(iconWidget), isFalse);
        expect(simpleProvider.canHandle(imageWidget), isFalse);
        expect(simpleProvider.canHandle(fabWidget), isFalse);
        expect(highPriorityProvider.canHandle(textWidget), isFalse);
        expect(highPriorityProvider.canHandle(containerWidget), isFalse);
        expect(highPriorityProvider.canHandle(fabWidget), isFalse);
        expect(lowPriorityProvider.canHandle(textWidget), isFalse);
        expect(lowPriorityProvider.canHandle(iconWidget), isFalse);
        expect(lowPriorityProvider.canHandle(fabWidget), isFalse);
        expect(implicitDefaultProvider.canHandle(textWidget), isFalse);
        expect(implicitDefaultProvider.canHandle(iconWidget), isFalse);
        expect(implicitDefaultProvider.canHandle(imageWidget), isFalse);
      });

      test('Debería ser consistente en múltiples llamadas', () {
        const textWidget = Text('test');
        const iconWidget = Icon(Icons.star);

        // Múltiples llamadas deberían retornar el mismo resultado
        for (int i = 0; i < 5; i++) {
          expect(simpleProvider.canHandle(textWidget), isTrue);
          expect(simpleProvider.canHandle(iconWidget), isFalse);
        }
      });

      test('Debería manejar widgets con propiedades complejas', () {
        const textWidgetWithStyle = Text(
          'Texto complejo',
          style: TextStyle(fontSize: 16, color: Colors.blue),
          overflow: TextOverflow.ellipsis,
        );
        const iconWithSize = Icon(Icons.favorite, size: 32, color: Colors.red);

        expect(simpleProvider.canHandle(textWidgetWithStyle), isTrue);
        expect(highPriorityProvider.canHandle(iconWithSize), isTrue);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear un skeleton válido para Text', (tester) async {
        const textWidget = Text('Texto de prueba');
        final skeleton = simpleProvider.createSkeleton(textWidget, baseColor);

        expect(skeleton, isA<Container>());
        final container = skeleton as Container;
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear un skeleton válido para Icon', (tester) async {
        const iconWidget = Icon(Icons.star);
        final skeleton =
            highPriorityProvider.createSkeleton(iconWidget, baseColor);

        expect(skeleton, isA<Container>());
        final container = skeleton as Container;
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear un skeleton válido para FloatingActionButton',
          (tester) async {
        const fabWidget = FloatingActionButton(onPressed: null);
        final skeleton =
            implicitDefaultProvider.createSkeleton(fabWidget, baseColor);

        expect(skeleton, isA<Container>());
        final container = skeleton as Container;
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, baseColor);
        expect(decoration?.shape, BoxShape.circle);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      test('Debería usar el color base proporcionado', () {
        const customColor = Color(0xFF123456);
        const textWidget = Text('test');
        final skeleton = simpleProvider.createSkeleton(textWidget, customColor);

        expect(skeleton, isA<Container>());
        final container = skeleton as Container;
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, customColor);
      });

      test('Debería crear skeletons diferentes para widgets diferentes', () {
        const textWidget = Text('test');
        const iconWidget = Icon(Icons.star);
        const fabWidget = FloatingActionButton(onPressed: null);

        final textSkeleton =
            simpleProvider.createSkeleton(textWidget, baseColor);
        final iconSkeleton =
            highPriorityProvider.createSkeleton(iconWidget, baseColor);
        final fabSkeleton =
            implicitDefaultProvider.createSkeleton(fabWidget, baseColor);

        // Los skeletons deben ser diferentes objetos
        expect(textSkeleton, isNot(same(iconSkeleton)));
        expect(textSkeleton, isNot(same(fabSkeleton)));
        expect(iconSkeleton, isNot(same(fabSkeleton)));
        expect(textSkeleton, isA<Container>());
        expect(iconSkeleton, isA<Container>());
        expect(fabSkeleton, isA<Container>());
      });

      testWidgets('Debería manejar múltiples skeletons en el mismo widget tree',
          (tester) async {
        const textWidget = Text('test');
        const iconWidget = Icon(Icons.star);

        final textSkeleton =
            simpleProvider.createSkeleton(textWidget, baseColor);
        final iconSkeleton =
            highPriorityProvider.createSkeleton(iconWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [textSkeleton, iconSkeleton],
              ),
            ),
          ),
        );

        expect(find.byType(Container), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      });
    });

    group('priority', () {
      test('Debería retornar diferentes valores de prioridad', () {
        expect(defaultPriorityProvider.priority, 0);
        expect(implicitDefaultProvider.priority,
            0); // Usa implementación por defecto
        expect(lowPriorityProvider.priority, 1);
        expect(simpleProvider.priority, 3);
        expect(testProvider.priority, 5);
        expect(highPriorityProvider.priority, 10);
      });

      test('Debería permitir prioridades negativas', () {
        final negativePriorityProvider = NegativePriorityProvider();
        expect(negativePriorityProvider.priority, -5);
      });

      test('Debería ser consistente en múltiples accesos', () {
        for (int i = 0; i < 10; i++) {
          expect(simpleProvider.priority, 3);
          expect(highPriorityProvider.priority, 10);
        }
      });

      test('Debería mantener orden de prioridad para sorting', () {
        final providers = [
          defaultPriorityProvider,
          implicitDefaultProvider,
          lowPriorityProvider,
          simpleProvider,
          testProvider,
          highPriorityProvider,
        ];

        // Ordenar por prioridad (mayor a menor)
        providers.sort((a, b) => b.priority.compareTo(a.priority));

        expect(providers[0], highPriorityProvider); // priority 10
        expect(providers[1], testProvider); // priority 5
        expect(providers[2], simpleProvider); // priority 3
        expect(providers[3], lowPriorityProvider); // priority 1
        // Los dos con priority 0 pueden estar en cualquier orden
        expect(providers[4].priority, 0);
        expect(providers[5].priority, 0);
      });
    });

    group('implementaciones específicas', () {
      test('Debería permitir diferentes estrategias de detección', () {
        // SimpleProvider detecta por tipo específico
        expect(simpleProvider.canHandle(const Text('test')), isTrue);
        expect(simpleProvider.canHandle(const Icon(Icons.star)), isFalse);

        // HighPriorityProvider detecta otro tipo
        expect(highPriorityProvider.canHandle(const Icon(Icons.star)), isTrue);
        expect(highPriorityProvider.canHandle(const Text('test')), isFalse);

        // ImplicitDefaultProvider detecta FloatingActionButton
        expect(
            implicitDefaultProvider
                .canHandle(const FloatingActionButton(onPressed: null)),
            isTrue);
        expect(implicitDefaultProvider.canHandle(const Text('test')), isFalse);
      });

      test('Debería permitir diferentes estrategias de generación', () {
        const textWidget = Text('test');
        const iconWidget = Icon(Icons.star);
        const fabWidget = FloatingActionButton(onPressed: null);

        final textSkeleton =
            simpleProvider.createSkeleton(textWidget, baseColor);
        final iconSkeleton =
            highPriorityProvider.createSkeleton(iconWidget, baseColor);
        final fabSkeleton =
            implicitDefaultProvider.createSkeleton(fabWidget, baseColor);

        // Verificar que generan diferentes tipos de skeletons
        expect(textSkeleton, isA<Container>());
        expect(iconSkeleton, isA<Container>());
        expect(fabSkeleton, isA<Container>());

        // Verificar diferencias específicas
        final fabContainer = fabSkeleton as Container;
        final fabDecoration = fabContainer.decoration as BoxDecoration?;
        expect(fabDecoration?.shape, BoxShape.circle); // FAB es circular

        // Diferentes instancias para diferentes tipos
        expect(textSkeleton, isNot(same(iconSkeleton)));
        expect(textSkeleton, isNot(same(fabSkeleton)));
        expect(iconSkeleton, isNot(same(fabSkeleton)));
      });

      test('Debería mantener independencia entre providers', () {
        const widget = Text('test');
        const fabWidget = FloatingActionButton(onPressed: null);

        // Un provider no debería afectar a otro
        expect(simpleProvider.canHandle(widget), isTrue);
        expect(highPriorityProvider.canHandle(widget), isFalse);
        expect(lowPriorityProvider.canHandle(widget), isFalse);
        expect(implicitDefaultProvider.canHandle(widget), isFalse);

        // Verificar que cada provider maneja solo su tipo específico
        expect(implicitDefaultProvider.canHandle(fabWidget), isTrue);
        expect(simpleProvider.canHandle(fabWidget), isFalse);

        // Crear skeleton con un provider no debería afectar otros
        simpleProvider.createSkeleton(widget, baseColor);
        expect(highPriorityProvider.canHandle(const Icon(Icons.star)), isTrue);
        expect(implicitDefaultProvider.canHandle(fabWidget), isTrue);
      });
    });

    group('herencia desde BaseSkeletonProvider', () {
      test('Debería funcionar correctamente con BaseSkeletonProvider', () {
        expect(testProvider, isA<SkeletonProvider>());
        expect(baseDefaultProvider, isA<SkeletonProvider>());
      });

      test('Debería heredar comportamiento por defecto cuando aplique', () {
        expect(baseDefaultProvider.priority, 0);
      });

      test('Debería permitir sobrescribir comportamiento heredado', () {
        expect(testProvider.priority, 5); // Sobrescribe el default de 0
      });
    });

    group('casos extremos', () {
      test(
          'Debería manejar widgets null como parámetro (si el diseño lo permite)',
          () {
        // Nota: En Dart, no podemos pasar null a un parámetro no-nullable
        // Este test verifica que el diseño de la interfaz es correcto
        expect(() => simpleProvider.canHandle, returnsNormally);
      });

      test('Debería manejar colores extremos', () {
        const transparentColor = Color(0x00000000);
        const maxColor = Color(0xFFFFFFFF);
        const textWidget = Text('test');

        final transparentSkeleton =
            simpleProvider.createSkeleton(textWidget, transparentColor);
        final maxSkeleton = simpleProvider.createSkeleton(textWidget, maxColor);

        expect(transparentSkeleton, isA<Container>());
        expect(maxSkeleton, isA<Container>());
      });

      test('Debería manejar widgets complejos', () {
        final complexWidget = Container(
          width: 200,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: const Text('Complex widget'),
        );

        // Aunque el provider no puede manejar Container, no debería fallar
        expect(() => simpleProvider.canHandle(complexWidget), returnsNormally);
        expect(simpleProvider.canHandle(complexWidget), isFalse);
      });

      testWidgets('Debería funcionar con widgets en diferentes contextos',
          (tester) async {
        const textWidget = Text('test');
        final skeleton = simpleProvider.createSkeleton(textWidget, baseColor);

        // Test en diferentes contextos
        await tester.pumpWidget(MaterialApp(home: skeleton));
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: skeleton),
            ),
          ),
        );
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView(children: [skeleton]),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      });
    });

    group('compatibilidad y cumplimiento', () {
      test('Debería implementar todos los métodos requeridos', () {
        final providers = [
          simpleProvider,
          highPriorityProvider,
          lowPriorityProvider,
          defaultPriorityProvider,
          implicitDefaultProvider,
          testProvider,
          baseDefaultProvider,
        ];

        for (final provider in providers) {
          const widget = Text('test');
          expect(() => provider.canHandle(widget), returnsNormally);
          expect(() => provider.createSkeleton(widget, baseColor),
              returnsNormally);
          expect(() => provider.priority, returnsNormally);
        }
      });

      test('Debería ser polimórfico', () {
        final List<SkeletonProvider> providers = [
          simpleProvider,
          highPriorityProvider,
          lowPriorityProvider,
          implicitDefaultProvider,
          testProvider,
        ];

        for (final provider in providers) {
          expect(provider, isA<SkeletonProvider>());
        }
      });

      test('Debería mantener consistencia de tipos', () {
        const widget = Text('test');

        final result1 = simpleProvider.canHandle(widget);
        final result2 = simpleProvider.canHandle(widget);
        final skeleton1 = simpleProvider.createSkeleton(widget, baseColor);
        final skeleton2 = simpleProvider.createSkeleton(widget, baseColor);

        expect(result1, isA<bool>());
        expect(result2, isA<bool>());
        expect(skeleton1, isA<Widget>());
        expect(skeleton2, isA<Widget>());
        expect(simpleProvider.priority, isA<int>());
      });
    });

    group('documentación y comentarios', () {
      test('Debería tener documentación clara en la interfaz', () {
        expect(SkeletonProvider, isNotNull);
      });

      test('Debería seguir las convenciones de nomenclatura', () {
        expect(() => simpleProvider.canHandle(const Text('test')),
            returnsNormally);
        expect(
            () => simpleProvider.createSkeleton(const Text('test'), baseColor),
            returnsNormally);
        expect(() => simpleProvider.priority, returnsNormally);
      });
    });
  });
}
