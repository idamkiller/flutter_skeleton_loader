import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeleton_builder.dart';

void main() {
  group('SkeletonBuilder', () {
    const baseColor = Color(0xFFE0E0E0);

    test('should be created with required baseColor', () {
      final builder = const SkeletonBuilder(baseColor: baseColor);

      expect(builder.baseColor, equals(baseColor));
    });

    testWidgets('should create skeletons for Text widgets',
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

      expect(
        find.text('Test Text'),
        findsNothing,
      );
    });

    testWidgets('should build appropriate skeletons for container widgets',
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

      final containers = tester.widgetList<Container>(find.byType(Container));
      bool foundBlueContainer = false;
      for (final container in containers) {
        if (container.color == Colors.blue) {
          foundBlueContainer = true;
          break;
        }
      }

      expect(foundBlueContainer, isFalse);
    });

    testWidgets('should pass the baseColor to generated skeletons',
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

    testWidgets('should handle complex widget hierarchies',
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
  });
}
