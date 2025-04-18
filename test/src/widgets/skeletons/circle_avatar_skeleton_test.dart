import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/circle_avatar_skeleton.dart';

void main() {
  group('CircleAvatarSkeleton', () {
    testWidgets('debería renderizar con el radio por defecto', (tester) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CircleAvatarSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, 40);
      expect(constraints?.maxHeight, 40);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('debería renderizar con un radio personalizado', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const radius = 60.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleAvatarSkeleton(baseColor: baseColor, radius: radius),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, radius);
      expect(constraints?.maxHeight, radius);
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CircleAvatarSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, baseColor);
    });

    testWidgets('debería tener siempre forma circular', (tester) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CircleAvatarSkeleton(baseColor: baseColor)),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });
  });
}
