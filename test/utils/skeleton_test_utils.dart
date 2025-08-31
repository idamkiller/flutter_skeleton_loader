import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/skeleton_loader.dart';
import 'package:flutter_skeleton_loader/src/widgets/shimmer_effect.dart';

/// [SkeletonTestUtils]
/// Utility class to facilitate and standardize testing
/// of SkeletonLoader and its components.
///
class SkeletonTestUtils {
  /// [STANDARD TEST SETUP]
  /// Sets up a basic SkeletonLoader for testing
  static Future<void> pumpSkeletonLoader(
    WidgetTester tester, {
    required Widget child,
    bool isLoading = true,
    Color? baseColor,
    Color? highlightColor,
    Duration? shimmerDuration,
    Duration? transitionDuration,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SkeletonLoader(
            isLoading: isLoading,
            baseColor: baseColor ?? Colors.grey,
            highlightColor: highlightColor ?? Colors.white,
            shimmerDuration:
                shimmerDuration ?? const Duration(milliseconds: 1500),
            transitionDuration:
                transitionDuration ?? const Duration(milliseconds: 300),
            child: child,
          ),
        ),
      ),
    );
  }

  /// [SKELETON VISIBLE CHECK]
  /// Verifies that the skeleton is being shown
  static void expectSkeletonVisible(WidgetTester tester) {
    expect(find.byType(ShimmerEffect), findsOneWidget);
    expect(find.byType(SkeletonLoader), findsOneWidget);
  }

  /// [CONTENT VISIBLE CHECK]
  /// Verifies that the real content is being shown
  static void expectContentVisible(WidgetTester tester, Widget originalChild) {
    expect(find.byWidget(originalChild), findsOneWidget);
    expect(find.byType(ShimmerEffect), findsNothing);
  }

  /// [TRANSITION CHECK]
  /// Simulates and verifies the transition from skeleton to content
  static Future<void> verifyTransition(
    WidgetTester tester, {
    required Widget child,
    Duration? transitionDuration,
  }) async {
    // Configurar con skeleton visible
    await pumpSkeletonLoader(
      tester,
      child: child,
      isLoading: true,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
    );

    // Verify skeleton is visible
    expectSkeletonVisible(tester);

    // Change to real content
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SkeletonLoader(
            isLoading: false,
            transitionDuration:
                transitionDuration ?? const Duration(milliseconds: 300),
            child: child,
          ),
        ),
      ),
    );

    // Advance the transition animation
    await tester.pumpAndSettle();

    // Verify content is visible
    expectContentVisible(tester, child);
  }

  /// [COLOR CHECK]
  /// Verifies that the skeleton colors are correct
  static void expectSkeletonColors(
    WidgetTester tester, {
    required Color expectedBaseColor,
    required Color expectedHighlightColor,
  }) {
    final skeletonLoader = tester.widget<SkeletonLoader>(
      find.byType(SkeletonLoader),
    );

    expect(skeletonLoader.baseColor, equals(expectedBaseColor));
    expect(skeletonLoader.highlightColor, equals(expectedHighlightColor));
  }

  /// [ANIMATION DURATION CHECK]
  /// Verifies that the animation durations are correct
  static void expectAnimationDurations(
    WidgetTester tester, {
    Duration? expectedShimmerDuration,
    Duration? expectedTransitionDuration,
  }) {
    final skeletonLoader = tester.widget<SkeletonLoader>(
      find.byType(SkeletonLoader),
    );

    if (expectedShimmerDuration != null) {
      expect(skeletonLoader.shimmerDuration, equals(expectedShimmerDuration));
    }

    if (expectedTransitionDuration != null) {
      expect(skeletonLoader.transitionDuration,
          equals(expectedTransitionDuration));
    }
  }

  /// [HELPER FOR COMPLEX WIDGETS]
  /// Creates a complex test widget to verify hierarchy handling
  static Widget createComplexTestWidget() {
    return Column(
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
        const ListTile(
          leading: Icon(Icons.person),
          title: Text('List Item'),
          subtitle: Text('Subtitle'),
        ),
      ],
    );
  }

  /// [NO RENDERING ERRORS CHECK]
  /// Verifies that there are no rendering errors
  static void expectNoRenderingErrors(WidgetTester tester) {
    expect(tester.takeException(), isNull);
  }

  /// [PERFORMANCE CHECK]
  /// Verifies that there are no unnecessary widgets in the tree
  static void expectOptimalWidgetTree(WidgetTester tester) {
    // Verify that there are RepaintBoundary for optimization
    expect(find.byType(RepaintBoundary), findsWidgets);

    // Verify that there are no rendering errors
    expectNoRenderingErrors(tester);
  }

  /// [LOAD SIMULATION]
  /// Simulates a complete loading cycle (skeleton -> content)
  static Future<void> simulateLoadingCycle(
    WidgetTester tester, {
    required Widget child,
    Duration loadingDuration = const Duration(milliseconds: 1000),
    Duration? transitionDuration,
  }) async {
    // Start with loading
    await pumpSkeletonLoader(
      tester,
      child: child,
      isLoading: true,
      transitionDuration: transitionDuration,
    );

    expectSkeletonVisible(tester);

    // Simulate loading time
    await tester.pump(loadingDuration);

    // Change to loaded content
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SkeletonLoader(
            isLoading: false,
            transitionDuration:
                transitionDuration ?? const Duration(milliseconds: 300),
            child: child,
          ),
        ),
      ),
    );

    // Complete transition
    await tester.pumpAndSettle();

    expectContentVisible(tester, child);
    expectNoRenderingErrors(tester);
  }
}
