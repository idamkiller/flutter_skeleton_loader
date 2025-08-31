import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';
import 'package:flutter_skeleton_loader/src/widgets/shimmer_effect.dart';

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
}
