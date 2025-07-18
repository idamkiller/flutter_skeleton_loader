import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/shimmer_effect.dart';

void main() {
  group('ShimmerEffect', () {
    testWidgets('should render child widget correctly',
        (WidgetTester tester) async {
      // Arrange
      const testKey = Key('test_child');
      const testChild = Text('Test Child', key: testKey);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFEEEEEE),
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('should apply custom colors', (WidgetTester tester) async {
      // Arrange
      const baseColor = Color(0xFF111111);
      const highlightColor = Color(0xFF999999);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: SizedBox(height: 100, width: 100),
            ),
          ),
        ),
      );

      // Assert
      final shimmerWidget = tester.widget<ShimmerEffect>(
        find.byType(ShimmerEffect),
      );

      expect(shimmerWidget.baseColor, equals(baseColor));
      expect(shimmerWidget.highlightColor, equals(highlightColor));
    });

    testWidgets('should apply custom duration', (WidgetTester tester) async {
      // Arrange
      const customDuration = Duration(milliseconds: 2500);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFEEEEEE),
              duration: customDuration,
              child: SizedBox(height: 100, width: 100),
            ),
          ),
        ),
      );

      // Assert
      final shimmerWidget = tester.widget<ShimmerEffect>(
        find.byType(ShimmerEffect),
      );

      expect(shimmerWidget.duration, equals(customDuration));
    });

    testWidgets('should have continuous animation effect',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFEEEEEE),
              child: SizedBox(height: 100, width: 100),
            ),
          ),
        ),
      );

      // Verify shader mask exists initially
      final initialShaderMaskCount = find.byType(ShaderMask).evaluate().length;
      expect(initialShaderMaskCount, 1);

      // Act - Advance animation
      await tester.pump(const Duration(milliseconds: 100));

      // Verify shader mask still exists after animation frame
      final updatedShaderMaskCount = find.byType(ShaderMask).evaluate().length;
      expect(updatedShaderMaskCount, 1);

      // We can't directly test private animation values, but we can verify
      // that the widget tree contains a ShaderMask and that animation continues running
      expect(find.byType(ShaderMask), findsOneWidget);

      // Pump more frames to ensure animation continues
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('should use RepaintBoundary for optimization',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFEEEEEE),
              child: SizedBox(height: 100, width: 100),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('should use ShaderMask for gradient effect',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFEEEEEE),
              child: SizedBox(height: 100, width: 100),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('should handle widget rebuild with new properties',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: Color(0xFFE0E0E0),
              highlightColor: Color(0xFFEEEEEE),
              duration: Duration(milliseconds: 1500),
              child: SizedBox(height: 100, width: 100),
            ),
          ),
        ),
      );

      // Act - Update widget with new properties
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerEffect(
              baseColor: Color(0xFF111111),
              highlightColor: Color(0xFF999999),
              duration: Duration(milliseconds: 2500),
              child: SizedBox(height: 200, width: 200),
            ),
          ),
        ),
      );

      // Assert
      final shimmerWidget = tester.widget<ShimmerEffect>(
        find.byType(ShimmerEffect),
      );

      expect(shimmerWidget.baseColor, equals(const Color(0xFF111111)));
      expect(shimmerWidget.highlightColor, equals(const Color(0xFF999999)));
      expect(
          shimmerWidget.duration, equals(const Duration(milliseconds: 2500)));
    });
  });
}
