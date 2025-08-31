import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/builders/skeleton_loader_builder.dart';
import 'package:flutter_skeleton_loader/src/config/skeleton_config.dart';
import 'package:flutter_skeleton_loader/skeleton_loader.dart';
import '../../utils/skeleton_test_utils.dart';

void main() {
  group('SkeletonLoaderBuilder', () {
    late Widget testChild;

    setUp(() {
      testChild = const Text('Test Child');
      SkeletonConfig.configure(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFEEEEEE),
        shimmerDuration: const Duration(milliseconds: 1500),
        transitionDuration: const Duration(milliseconds: 300),
      );
    });

    group('Configuración básica', () {
      test('Debe construirse con los parámetros requeridos', () {
        final skeletonLoader =
            SkeletonLoaderBuilder().child(testChild).loading(true).build();

        expect(skeletonLoader, isA<SkeletonLoader>());
        expect(skeletonLoader.child, equals(testChild));
        expect(skeletonLoader.isLoading, isTrue);
      });

      test('Debe lanzar un error cuando no se proporciona un hijo', () {
        expect(
          () => SkeletonLoaderBuilder().loading(true).build(),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Child widget is required'),
          )),
        );
      });

      test('Debe lanzar un error cuando no se proporciona el estado de carga',
          () {
        expect(
          () => SkeletonLoaderBuilder().child(testChild).build(),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Loading state is required'),
          )),
        );
      });

      test(
          'Debe usar la configuración global como valores predeterminados cuando no se especifique',
          () {
        final skeletonLoader =
            SkeletonLoaderBuilder().child(testChild).loading(true).build();

        final config = SkeletonConfig.instance;
        expect(skeletonLoader.baseColor, equals(config.defaultBaseColor));
        expect(skeletonLoader.highlightColor,
            equals(config.defaultHighlightColor));
        expect(skeletonLoader.shimmerDuration,
            equals(config.defaultShimmerDuration));
        expect(skeletonLoader.transitionDuration,
            equals(config.defaultTransitionDuration));
      });
    });

    group('Configuración de Color', () {
      test('Debe establecer el color base correctamente', () {
        const customBaseColor = Colors.red;
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .baseColor(customBaseColor)
            .build();

        expect(skeletonLoader.baseColor, equals(customBaseColor));
      });

      test('Debe establecer el color de resaltado correctamente', () {
        const customHighlightColor = Colors.blue;
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .highlightColor(customHighlightColor)
            .build();

        expect(skeletonLoader.highlightColor, equals(customHighlightColor));
      });

      test('Debe establecer ambos colores correctamente', () {
        const customBaseColor = Colors.red;
        const customHighlightColor = Colors.blue;
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .baseColor(customBaseColor)
            .highlightColor(customHighlightColor)
            .build();

        expect(skeletonLoader.baseColor, equals(customBaseColor));
        expect(skeletonLoader.highlightColor, equals(customHighlightColor));
      });
    });

    group('Configuración de Duración', () {
      test('Debe establecer la duración del brillo correctamente', () {
        const customDuration = Duration(milliseconds: 2000);
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .shimmerDuration(customDuration)
            .build();

        expect(skeletonLoader.shimmerDuration, equals(customDuration));
      });

      test('Debe establecer la duración de la transición correctamente', () {
        const customDuration = Duration(milliseconds: 500);
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .transitionDuration(customDuration)
            .build();

        expect(skeletonLoader.transitionDuration, equals(customDuration));
      });

      test('Debe establecer ambas duraciones correctamente', () {
        const customShimmerDuration = Duration(milliseconds: 2000);
        const customTransitionDuration = Duration(milliseconds: 500);
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .shimmerDuration(customShimmerDuration)
            .transitionDuration(customTransitionDuration)
            .build();

        expect(skeletonLoader.shimmerDuration, equals(customShimmerDuration));
        expect(skeletonLoader.transitionDuration,
            equals(customTransitionDuration));
      });
    });

    group('Configuración de Tema', () {
      test('Debe aplicar el tema claro correctamente', () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .lightTheme()
            .build();

        expect(skeletonLoader.baseColor, equals(const Color(0xFFE0E0E0)));
        expect(skeletonLoader.highlightColor, equals(const Color(0xFFF5F5F5)));
      });

      test('Debe aplicar el tema oscuro correctamente', () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .darkTheme()
            .build();

        expect(skeletonLoader.baseColor, equals(const Color(0xFF424242)));
        expect(skeletonLoader.highlightColor, equals(const Color(0xFF616161)));
      });

      test('Debe anular el tema con colores personalizados', () {
        const customBaseColor = Colors.green;
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .lightTheme()
            .baseColor(customBaseColor)
            .build();

        expect(skeletonLoader.baseColor, equals(customBaseColor));
        expect(skeletonLoader.highlightColor, equals(const Color(0xFFF5F5F5)));
      });
    });

    group('Configuración de Animación', () {
      test('Debe aplicar la animación rápida correctamente', () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .fastAnimation()
            .build();

        expect(skeletonLoader.shimmerDuration,
            equals(const Duration(milliseconds: 800)));
        expect(skeletonLoader.transitionDuration,
            equals(const Duration(milliseconds: 200)));
      });

      test('Debe aplicar la animación lenta correctamente', () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .slowAnimation()
            .build();

        expect(skeletonLoader.shimmerDuration,
            equals(const Duration(milliseconds: 2500)));
        expect(skeletonLoader.transitionDuration,
            equals(const Duration(milliseconds: 500)));
      });

      test('Debe anular la animación con duraciones personalizadas', () {
        const customShimmerDuration = Duration(milliseconds: 1000);
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .fastAnimation()
            .shimmerDuration(customShimmerDuration)
            .build();

        expect(skeletonLoader.shimmerDuration, equals(customShimmerDuration));
        expect(skeletonLoader.transitionDuration,
            equals(const Duration(milliseconds: 200)));
      });
    });

    group('Encadenamiento de Métodos', () {
      test('Debe devolver la misma instancia para el encadenamiento de métodos',
          () {
        final builder = SkeletonLoaderBuilder();

        expect(builder.child(testChild), same(builder));
        expect(builder.loading(true), same(builder));
        expect(builder.baseColor(Colors.red), same(builder));
        expect(builder.highlightColor(Colors.blue), same(builder));
        expect(builder.shimmerDuration(const Duration(milliseconds: 1000)),
            same(builder));
        expect(builder.transitionDuration(const Duration(milliseconds: 300)),
            same(builder));
        expect(builder.lightTheme(), same(builder));
        expect(builder.darkTheme(), same(builder));
        expect(builder.fastAnimation(), same(builder));
        expect(builder.slowAnimation(), same(builder));
      });

      test('Debe soportar el encadenamiento de métodos complejo', () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .darkTheme()
            .fastAnimation()
            .baseColor(Colors.purple)
            .build();

        expect(skeletonLoader.child, equals(testChild));
        expect(skeletonLoader.isLoading, isTrue);
        expect(skeletonLoader.baseColor, equals(Colors.purple));
        expect(skeletonLoader.highlightColor, equals(const Color(0xFF616161)));
        expect(skeletonLoader.shimmerDuration,
            equals(const Duration(milliseconds: 800)));
        expect(skeletonLoader.transitionDuration,
            equals(const Duration(milliseconds: 200)));
      });
    });

    group('Métodos de Utilidad Estáticos', () {
      test(
          'Debe crear un cargador de esqueleto rápido con valores predeterminados',
          () {
        final skeletonLoader = SkeletonLoaderBuilder.quick(
          child: testChild,
          isLoading: true,
        );

        expect(skeletonLoader.child, equals(testChild));
        expect(skeletonLoader.isLoading, isTrue);
        expect(skeletonLoader.baseColor,
            equals(SkeletonConfig.instance.defaultBaseColor));
        expect(skeletonLoader.highlightColor,
            equals(SkeletonConfig.instance.defaultHighlightColor));
      });

      test(
          'Debe crear un cargador de esqueleto rápido con colores personalizados',
          () {
        const customBaseColor = Colors.red;
        const customHighlightColor = Colors.blue;
        final skeletonLoader = SkeletonLoaderBuilder.quick(
          child: testChild,
          isLoading: true,
          baseColor: customBaseColor,
          highlightColor: customHighlightColor,
        );

        expect(skeletonLoader.baseColor, equals(customBaseColor));
        expect(skeletonLoader.highlightColor, equals(customHighlightColor));
      });

      test('Debe crear un cargador de esqueleto ligero', () {
        final skeletonLoader = SkeletonLoaderBuilder.light(
          child: testChild,
          isLoading: true,
        );

        expect(skeletonLoader.child, equals(testChild));
        expect(skeletonLoader.isLoading, isTrue);
        expect(skeletonLoader.baseColor, equals(const Color(0xFFE0E0E0)));
        expect(skeletonLoader.highlightColor, equals(const Color(0xFFF5F5F5)));
      });

      test('Debe crear un cargador de esqueleto oscuro', () {
        final skeletonLoader = SkeletonLoaderBuilder.dark(
          child: testChild,
          isLoading: true,
        );

        expect(skeletonLoader.child, equals(testChild));
        expect(skeletonLoader.isLoading, isTrue);
        expect(skeletonLoader.baseColor, equals(const Color(0xFF424242)));
        expect(skeletonLoader.highlightColor, equals(const Color(0xFF616161)));
      });
    });

    group('Integración con SkeletonConfig', () {
      test('Debe respetar la configuración global actualizada', () {
        const newBaseColor = Color(0xFF123456);
        const newHighlightColor = Color(0xFF654321);
        const newShimmerDuration = Duration(milliseconds: 999);
        const newTransitionDuration = Duration(milliseconds: 123);

        SkeletonConfig.configure(
          baseColor: newBaseColor,
          highlightColor: newHighlightColor,
          shimmerDuration: newShimmerDuration,
          transitionDuration: newTransitionDuration,
        );

        final skeletonLoader =
            SkeletonLoaderBuilder().child(testChild).loading(true).build();

        expect(skeletonLoader.baseColor, equals(newBaseColor));
        expect(skeletonLoader.highlightColor, equals(newHighlightColor));
        expect(skeletonLoader.shimmerDuration, equals(newShimmerDuration));
        expect(
            skeletonLoader.transitionDuration, equals(newTransitionDuration));
      });

      test('Debe sobrescribir la configuración global cuando se especifique',
          () {
        SkeletonConfig.configure(
          baseColor: Colors.red,
          highlightColor: Colors.blue,
        );

        const customBaseColor = Colors.green;
        const customHighlightColor = Colors.yellow;

        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .baseColor(customBaseColor)
            .highlightColor(customHighlightColor)
            .build();

        expect(skeletonLoader.baseColor, equals(customBaseColor));
        expect(skeletonLoader.highlightColor, equals(customHighlightColor));
      });
    });

    group('Casos Límite', () {
      test('Debe manejar múltiples llamadas al mismo método de configuración',
          () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .baseColor(Colors.red)
            .baseColor(Colors.blue)
            .build();

        expect(skeletonLoader.baseColor, equals(Colors.blue));
      });

      test(
          'Debe manejar cambios de tema después de configuraciones de color individuales',
          () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .baseColor(Colors.red)
            .lightTheme()
            .build();

        expect(skeletonLoader.baseColor, equals(const Color(0xFFE0E0E0)));
        expect(skeletonLoader.highlightColor, equals(const Color(0xFFF5F5F5)));
      });

      test(
          'Debe manejar cambios de animación después de configuraciones de duración individuales',
          () {
        final skeletonLoader = SkeletonLoaderBuilder()
            .child(testChild)
            .loading(true)
            .shimmerDuration(const Duration(milliseconds: 3000))
            .fastAnimation()
            .build();

        expect(skeletonLoader.shimmerDuration,
            equals(const Duration(milliseconds: 800)));
        expect(skeletonLoader.transitionDuration,
            equals(const Duration(milliseconds: 200)));
      });

      test(
          'Debe manejar parámetros nulos de manera adecuada en métodos estáticos',
          () {
        final skeletonLoader = SkeletonLoaderBuilder.quick(
          child: testChild,
          isLoading: true,
          baseColor: null,
          highlightColor: null,
        );

        expect(skeletonLoader.baseColor,
            equals(SkeletonConfig.instance.defaultBaseColor));
        expect(skeletonLoader.highlightColor,
            equals(SkeletonConfig.instance.defaultHighlightColor));
      });
    });
  });

  group('Integración con SkeletonLoaderBuilder Widget', () {
    late Widget testChild;

    setUp(() {
      testChild = const Text('Test Widget');
    });

    testWidgets('Debe renderizar el esqueleto correctamente con el constructor',
        (WidgetTester tester) async {
      final skeletonLoader =
          SkeletonLoaderBuilder().child(testChild).loading(true).build();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: skeletonLoader),
        ),
      );

      SkeletonTestUtils.expectSkeletonVisible(tester);
    });

    testWidgets(
        'Debe renderizar el contenido correctamente cuando no se está cargando',
        (WidgetTester tester) async {
      final skeletonLoader =
          SkeletonLoaderBuilder().child(testChild).loading(false).build();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: skeletonLoader),
        ),
      );

      SkeletonTestUtils.expectContentVisible(tester, testChild);
    });

    testWidgets('Debe respetar los colores personalizados',
        (WidgetTester tester) async {
      const customBaseColor = Colors.red;
      const customHighlightColor = Colors.blue;

      final skeletonLoader = SkeletonLoaderBuilder()
          .child(testChild)
          .loading(true)
          .baseColor(customBaseColor)
          .highlightColor(customHighlightColor)
          .build();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: skeletonLoader),
        ),
      );

      SkeletonTestUtils.expectSkeletonColors(
        tester,
        expectedBaseColor: customBaseColor,
        expectedHighlightColor: customHighlightColor,
      );
    });

    testWidgets('Debe respetar las duraciones personalizadas',
        (WidgetTester tester) async {
      const customShimmerDuration = Duration(milliseconds: 2000);
      const customTransitionDuration = Duration(milliseconds: 600);

      final skeletonLoader = SkeletonLoaderBuilder()
          .child(testChild)
          .loading(true)
          .shimmerDuration(customShimmerDuration)
          .transitionDuration(customTransitionDuration)
          .build();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: skeletonLoader),
        ),
      );

      SkeletonTestUtils.expectAnimationDurations(
        tester,
        expectedShimmerDuration: customShimmerDuration,
        expectedTransitionDuration: customTransitionDuration,
      );
    });

    testWidgets('Debe manejar la transición de esqueleto a contenido',
        (WidgetTester tester) async {
      await SkeletonTestUtils.verifyTransition(
        tester,
        child: testChild,
        transitionDuration: const Duration(milliseconds: 300),
      );
    });

    testWidgets('Debe funcionar con widgets complejos',
        (WidgetTester tester) async {
      final complexWidget = SkeletonTestUtils.createComplexTestWidget();

      final skeletonLoader = SkeletonLoaderBuilder()
          .child(complexWidget)
          .loading(true)
          .lightTheme()
          .fastAnimation()
          .build();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: skeletonLoader),
        ),
      );

      SkeletonTestUtils.expectSkeletonVisible(tester);
      SkeletonTestUtils.expectOptimalWidgetTree(tester);
    });

    testWidgets('Debe manejar métodos de utilidad estáticos correctamente',
        (WidgetTester tester) async {
      final quickLoader = SkeletonLoaderBuilder.quick(
        child: testChild,
        isLoading: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: quickLoader),
        ),
      );

      SkeletonTestUtils.expectSkeletonVisible(tester);
    });

    testWidgets('Debe manejar el método estático de tema claro',
        (WidgetTester tester) async {
      final lightLoader = SkeletonLoaderBuilder.light(
        child: testChild,
        isLoading: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: lightLoader),
        ),
      );

      SkeletonTestUtils.expectSkeletonVisible(tester);
      SkeletonTestUtils.expectSkeletonColors(
        tester,
        expectedBaseColor: const Color(0xFFE0E0E0),
        expectedHighlightColor: const Color(0xFFF5F5F5),
      );
    });

    testWidgets('Debe manejar el método estático de tema oscuro',
        (WidgetTester tester) async {
      final darkLoader = SkeletonLoaderBuilder.dark(
        child: testChild,
        isLoading: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: darkLoader),
        ),
      );

      SkeletonTestUtils.expectSkeletonVisible(tester);
      SkeletonTestUtils.expectSkeletonColors(
        tester,
        expectedBaseColor: const Color(0xFF424242),
        expectedHighlightColor: const Color(0xFF616161),
      );
    });
  });
}
