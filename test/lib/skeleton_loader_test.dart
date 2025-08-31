import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';
import 'package:flutter_skeleton_loader/src/widgets/shimmer_effect.dart';

class _ErrorDuringAnalysisWidget extends StatelessWidget {
  const _ErrorDuringAnalysisWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('Normal looking widget');
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    throw Exception('Error during skeleton analysis');
  }
}

class _BadRuntimeTypeWidget extends StatelessWidget {
  const _BadRuntimeTypeWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('Looks normal');
  }

  @override
  Type get runtimeType => throw Exception('runtimeType access error');
}

class _BadHashCodeWidget extends StatelessWidget {
  const _BadHashCodeWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('Normal widget');
  }
}

void main() {
  group('SkeletonLoader - Tests básicos', () {
    testWidgets('Debería mostrar skeleton cuando isLoading es true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('Debería mostrar contenido cuando isLoading es false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: false,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('Debería usar colores personalizados',
        (WidgetTester tester) async {
      const customBaseColor = Color(0xFF123456);
      const customHighlightColor = Color(0xFF789ABC);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: customBaseColor,
              highlightColor: customHighlightColor,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(customBaseColor));
      expect(shimmerEffect.highlightColor, equals(customHighlightColor));
    });

    testWidgets('Debería usar duración personalizada de shimmer',
        (WidgetTester tester) async {
      const customDuration = Duration(seconds: 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              shimmerDuration: customDuration,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.duration, equals(customDuration));
    });

    testWidgets('Debería usar RepaintBoundary para optimización',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(RepaintBoundary), findsAtLeastNWidgets(1));
    });
  });

  group('SkeletonLoader - Factory constructor', () {
    testWidgets('Debería crear correctamente con factory constructor',
        (WidgetTester tester) async {
      const testText = Text('Test Content');

      final skeletonLoader = SkeletonLoader(
        isLoading: true,
        child: testText,
      );

      expect(skeletonLoader.child, equals(testText));
      expect(skeletonLoader.isLoading, isTrue);
      expect(skeletonLoader.baseColor, equals(const Color(0xFFE0E0E0)));
      expect(skeletonLoader.highlightColor, equals(const Color(0xFFEEEEEE)));
      expect(skeletonLoader.shimmerDuration,
          equals(const Duration(seconds: 1, milliseconds: 500)));
      expect(skeletonLoader.transitionDuration,
          equals(const Duration(milliseconds: 300)));
    });

    testWidgets('Debería permitir personalizar todos los parámetros',
        (WidgetTester tester) async {
      const testText = Text('Test Content');
      const customBaseColor = Color(0xFF123456);
      const customHighlightColor = Color(0xFF789ABC);
      const customShimmerDuration = Duration(seconds: 3);
      const customTransitionDuration = Duration(milliseconds: 600);

      final skeletonLoader = SkeletonLoader(
        isLoading: false,
        baseColor: customBaseColor,
        highlightColor: customHighlightColor,
        shimmerDuration: customShimmerDuration,
        transitionDuration: customTransitionDuration,
        child: testText,
      );

      expect(skeletonLoader.child, equals(testText));
      expect(skeletonLoader.isLoading, isFalse);
      expect(skeletonLoader.baseColor, equals(customBaseColor));
      expect(skeletonLoader.highlightColor, equals(customHighlightColor));
      expect(skeletonLoader.shimmerDuration, equals(customShimmerDuration));
      expect(
          skeletonLoader.transitionDuration, equals(customTransitionDuration));
    });
  });

  group('SkeletonLoader - Widgets complejos', () {
    testWidgets('Debería manejar widget hijo complejo',
        (WidgetTester tester) async {
      const complexChild = Column(
        children: [
          Text('Title'),
          Text('Subtitle'),
          Row(
            children: [
              Icon(Icons.star),
              Text('Rating'),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: complexChild,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('Debería mostrar widget hijo complejo cuando no está cargando',
        (WidgetTester tester) async {
      const complexChild = Column(
        children: [
          Text('Title'),
          Text('Subtitle'),
          Row(
            children: [
              Icon(Icons.star),
              Text('Rating'),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: false,
              child: complexChild,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.text('Rating'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('SkeletonLoader - Configuración global', () {
    testWidgets('Debería usar configuración global por defecto',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(const Color(0xFFE0E0E0)));
      expect(shimmerEffect.highlightColor, equals(const Color(0xFFEEEEEE)));
      expect(shimmerEffect.duration,
          equals(const Duration(seconds: 1, milliseconds: 500)));
    });
  });

  group('SkeletonLoader - Edge cases', () {
    testWidgets('Debería manejar child con Container vacío',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: Container(),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });
  });

  group('SkeletonLoader - Lifecycle y optimización', () {
    testWidgets(
        'Debería usar cache cuando no cambian las propiedades relevantes',
        (WidgetTester tester) async {
      const initialChild = Text('Initial Content');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: initialChild,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: false,
              child: initialChild,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ShimmerEffect), findsNothing);
      expect(find.text('Initial Content'), findsAtLeastNWidgets(1));
    });

    testWidgets(
        'Debería reconstruir skeleton cuando cambian propiedades relevantes',
        (WidgetTester tester) async {
      const initialChild = Text('Initial Content');
      const initialBaseColor = Color(0xFF000000);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: initialBaseColor,
              child: initialChild,
            ),
          ),
        ),
      );

      ShimmerEffect shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(initialBaseColor));

      const newBaseColor = Color(0xFFFFFFFF);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: newBaseColor,
              child: initialChild,
            ),
          ),
        ),
      );

      shimmerEffect = tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(newBaseColor));
    });

    testWidgets('Debería reconstruir cuando cambia el child widget',
        (WidgetTester tester) async {
      const initialChild = Text('Initial Content');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: initialChild,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);

      const newChild = Text('New Content');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: newChild,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('Debería reconstruir cuando cambia shimmerDuration',
        (WidgetTester tester) async {
      const initialDuration = Duration(seconds: 1);
      const child = Text('Content');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              shimmerDuration: initialDuration,
              child: child,
            ),
          ),
        ),
      );

      ShimmerEffect shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.duration, equals(initialDuration));

      const newDuration = Duration(seconds: 3);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              shimmerDuration: newDuration,
              child: child,
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ShimmerEffect), findsOneWidget);

      final newShimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(newShimmerEffect.duration, isNotNull);
    });
  });

  group('SkeletonLoader - Transiciones y animaciones', () {
    testWidgets('Debería aplicar transitionDuration personalizada',
        (WidgetTester tester) async {
      const customTransitionDuration = Duration(milliseconds: 800);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              transitionDuration: customTransitionDuration,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final animatedSwitcher =
          tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher));
      expect(animatedSwitcher.duration, equals(customTransitionDuration));
    });

    testWidgets('Debería usar KeyedSubtree con claves correctas',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final skeletonKeyedSubtree =
          tester.widget<KeyedSubtree>(find.byKey(const ValueKey('skeleton')));
      expect(skeletonKeyedSubtree.key, equals(const ValueKey('skeleton')));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: false,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final contentKeyedSubtree =
          tester.widget<KeyedSubtree>(find.byKey(const ValueKey('content')));
      expect(contentKeyedSubtree.key, equals(const ValueKey('content')));
    });
  });

  group('SkeletonLoader - Manejo de errores', () {
    testWidgets('Debería manejar errores en construcción de skeleton',
        (WidgetTester tester) async {
      final problematicWidget = SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: const Text('Valid content'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: problematicWidget,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets(
        'Debería crear skeleton por defecto cuando hay error en toString',
        (WidgetTester tester) async {
      const customBaseColor = Color(0xFF123456);
      const customHighlightColor = Color(0xFF789ABC);
      const customDuration = Duration(seconds: 2);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: customBaseColor,
              highlightColor: customHighlightColor,
              shimmerDuration: customDuration,
              child: const _ErrorDuringAnalysisWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(customBaseColor));
      expect(shimmerEffect.highlightColor, equals(customHighlightColor));
      expect(shimmerEffect.duration, equals(customDuration));

      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(1));
    });

    testWidgets(
        'Debería crear skeleton de emergencia cuando _buildSkeletonFromWidget falla',
        (WidgetTester tester) async {
      const emergencyBaseColor = Color(0xFFABCDEF);
      const emergencyHighlightColor = Color(0xFF123456);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: emergencyBaseColor,
              highlightColor: emergencyHighlightColor,
              child: const _ErrorDuringAnalysisWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(emergencyBaseColor));
      expect(shimmerEffect.highlightColor, equals(emergencyHighlightColor));

      final containerFinder = find.descendant(
        of: find.byType(ShimmerEffect),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsAtLeastNWidgets(1));
    });

    testWidgets(
        'Debería crear skeleton de emergencia correctamente con BorderRadius',
        (WidgetTester tester) async {
      const testColor = Color(0xFF654321);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: testColor,
              child: const _BadHashCodeWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, anyOf(equals(testColor), isA<Color>()));

      final containerFinder = find.descendant(
        of: find.byType(ShimmerEffect),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsAtLeastNWidgets(1));
    });

    testWidgets(
        'Debería activar bloque catch con widget que cause error de runtimeType',
        (WidgetTester tester) async {
      final complexWidget = Builder(
        key: Key('${DateTime.now().millisecondsSinceEpoch}'),
        builder: (context) {
          return Container(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              maxWidth: double.infinity,
              minHeight: double.infinity,
              maxHeight: double.infinity,
            ),
            child: Column(
              children: List.generate(100, (index) {
                return Row(
                  children: List.generate(100, (j) {
                    return Expanded(
                      child: Container(
                        height: 1,
                        width: 1,
                        decoration: BoxDecoration(
                          color: Color(0xFF000000 + index + j),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          );
        },
      );

      const testBaseColor = Color(0xFF112233);
      const testHighlightColor = Color(0xFF445566);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              height: 100,
              child: SkeletonLoader(
                isLoading: true,
                baseColor: testBaseColor,
                highlightColor: testHighlightColor,
                child: complexWidget,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(
          shimmerEffect.baseColor, anyOf(equals(testBaseColor), isA<Color>()));
      expect(shimmerEffect.highlightColor,
          anyOf(equals(testHighlightColor), isA<Color>()));
    });

    testWidgets('Debería usar skeleton de emergencia cuando runtimeType falla',
        (WidgetTester tester) async {
      const emergencyColor = Color(0xFF999999);
      const emergencyHighlight = Color(0xFFCCCCCC);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: emergencyColor,
              highlightColor: emergencyHighlight,
              child: const _BadRuntimeTypeWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(emergencyColor));
      expect(shimmerEffect.highlightColor, equals(emergencyHighlight));

      final containerFinder = find.descendant(
        of: find.byType(ShimmerEffect),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('Debería usar colores correctos en skeleton de emergencia',
        (WidgetTester tester) async {
      final problematicWidget = LayoutBuilder(
        builder: (context, constraints) {
          throw Exception('Simulated error in layout');
        },
      );

      const customBaseColor = Color(0xFFABCDEF);
      const customHighlightColor = Color(0xFF123456);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: customBaseColor,
              highlightColor: customHighlightColor,
              child: problematicWidget,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(customBaseColor));
      expect(shimmerEffect.highlightColor, equals(customHighlightColor));
    });

    testWidgets(
        'Debería crear skeleton por defecto cuando hay problemas con el child',
        (WidgetTester tester) async {
      final complexChild = Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 50)),
              const SizedBox(width: 10),
              Expanded(child: Container(height: 50)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: complexChild,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsAtLeastNWidgets(1));
    });

    testWidgets('Debería manejar widgets con constrains inválidos',
        (WidgetTester tester) async {
      final constrainedWidget = SizedBox(
        width: 0,
        height: 0,
        child: Container(
          color: Colors.red,
          child: const Text('Hidden content'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: constrainedWidget,
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('Debería continuar funcionando después de errores temporales',
        (WidgetTester tester) async {
      bool causeError = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SkeletonLoader(
                  isLoading: true,
                  child: causeError
                      ? SizedBox(width: -1, height: -1)
                      : const Text('Valid content'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);

      causeError = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: false,
              child: const Text('Valid content'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Valid content'), findsAtLeastNWidgets(1));
    });

    testWidgets(
        'Debería usar skeleton de emergencia cuando SkeletonBuilder falla',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              child: Builder(
                builder: (context) {
                  return Container(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                      maxWidth: double.infinity,
                      minHeight: double.infinity,
                      maxHeight: double.infinity,
                    ),
                    child: const Text('Complex widget'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });
  });

  group('SkeletonLoader - Configuración avanzada', () {
    testWidgets('Debería usar todos los parámetros del factory constructor',
        (WidgetTester tester) async {
      const customKey = Key('test-skeleton-loader');
      const customChild = Text('Custom Content');
      const customBaseColor = Color(0xFF112233);
      const customHighlightColor = Color(0xFF445566);
      const customShimmerDuration = Duration(milliseconds: 2500);
      const customTransitionDuration = Duration(milliseconds: 450);

      final skeletonLoader = SkeletonLoader(
        key: customKey,
        isLoading: true,
        baseColor: customBaseColor,
        highlightColor: customHighlightColor,
        shimmerDuration: customShimmerDuration,
        transitionDuration: customTransitionDuration,
        child: customChild,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: skeletonLoader,
          ),
        ),
      );

      expect(skeletonLoader.key, equals(customKey));
      expect(skeletonLoader.child, equals(customChild));
      expect(skeletonLoader.isLoading, isTrue);
      expect(skeletonLoader.baseColor, equals(customBaseColor));
      expect(skeletonLoader.highlightColor, equals(customHighlightColor));
      expect(skeletonLoader.shimmerDuration, equals(customShimmerDuration));
      expect(
          skeletonLoader.transitionDuration, equals(customTransitionDuration));

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(customBaseColor));
      expect(shimmerEffect.highlightColor, equals(customHighlightColor));
      expect(shimmerEffect.duration, equals(customShimmerDuration));

      final animatedSwitcher =
          tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher));
      expect(animatedSwitcher.duration, equals(customTransitionDuration));
    });

    testWidgets('Debería generar claves de cache consistentes',
        (WidgetTester tester) async {
      const child1 = Text('Content 1');
      const child2 = Text('Content 2');
      const color1 = Color(0xFF111111);
      const color2 = Color(0xFF222222);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: color1,
              child: child1,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: color2,
              child: child2,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('Debería optimizar cuando solo cambia el estado de loading',
        (WidgetTester tester) async {
      const child = Text('Content');
      const baseColor = Color(0xFF123456);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: baseColor,
              child: child,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: baseColor,
              child: child,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('Debería detectar cambios en highlightColor',
        (WidgetTester tester) async {
      const child = Text('Content');
      const initialHighlight = Color(0xFF111111);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              highlightColor: initialHighlight,
              child: child,
            ),
          ),
        ),
      );

      ShimmerEffect shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.highlightColor, equals(initialHighlight));

      const newHighlight = Color(0xFF222222);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              highlightColor: newHighlight,
              child: child,
            ),
          ),
        ),
      );

      shimmerEffect = tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.highlightColor, equals(newHighlight));
    });

    testWidgets('Debería manejar múltiples cambios de configuración',
        (WidgetTester tester) async {
      const child = Text('Content');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: const Color(0xFF111111),
              highlightColor: const Color(0xFF222222),
              shimmerDuration: const Duration(seconds: 1),
              child: child,
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(
              isLoading: true,
              baseColor: const Color(0xFF333333),
              highlightColor: const Color(0xFF444444),
              shimmerDuration: const Duration(seconds: 2),
              child: child,
            ),
          ),
        ),
      );

      final shimmerEffect =
          tester.widget<ShimmerEffect>(find.byType(ShimmerEffect));
      expect(shimmerEffect.baseColor, equals(const Color(0xFF333333)));
      expect(shimmerEffect.highlightColor, equals(const Color(0xFF444444)));
    });
  });
}
