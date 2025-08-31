import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_field_skeleton.dart';

void main() {
  group('TextFieldSkeleton', () {
    testWidgets('debería renderizar con dimensiones por defecto', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFieldSkeleton(baseColor: baseColor)),
        ),
      );

      final textFieldSkeletonFinder = find.byType(TextFieldSkeleton);
      expect(textFieldSkeletonFinder, findsOneWidget);

      final size = tester.getSize(textFieldSkeletonFinder);
      expect(size.height, 48);

      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.length, greaterThan(0));

      final mainContainer = containers.first;
      final decoration = mainContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));

      final decorationColor = decoration.color!;
      expect(decorationColor.alpha, lessThan(255));
    });

    testWidgets('debería renderizar con dimensiones personalizadas', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      const width = 200.0;
      const height = 60.0;
      const borderRadius = 12.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFieldSkeleton(
              baseColor: baseColor,
              width: width,
              height: height,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      final textFieldSkeletonFinder = find.byType(TextFieldSkeleton);
      final size = tester.getSize(textFieldSkeletonFinder);
      expect(size.width, width);
      expect(size.height, height);

      final containers = tester.widgetList<Container>(find.byType(Container));
      final mainContainer = containers.first;
      final decoration = mainContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(borderRadius));
    });

    testWidgets('debería aplicar el color base correctamente', (tester) async {
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFieldSkeleton(baseColor: baseColor)),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final mainContainer = containers.first;
      final decoration = mainContainer.decoration as BoxDecoration;

      final decorationColor = decoration.color!;
      expect(decorationColor.red, baseColor.red);
      expect(decorationColor.green, baseColor.green);
      expect(decorationColor.blue, baseColor.blue);
      expect(decorationColor.alpha, lessThan(255));
    });

    testWidgets('debería usar el borderRadius por defecto de 8', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextFieldSkeleton(baseColor: baseColor)),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final mainContainer = containers.first;
      final decoration = mainContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('debería renderizar correctamente en modo multiline', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFieldSkeleton(
              baseColor: baseColor,
              isMultiline: true,
            ),
          ),
        ),
      );

      final textFieldSkeletonFinder = find.byType(TextFieldSkeleton);
      final size = tester.getSize(textFieldSkeletonFinder);
      expect(size.height, 120);
    });

    testWidgets(
        'debería renderizar sin decoración cuando hasDecoration es false', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFieldSkeleton(
              baseColor: baseColor,
              hasDecoration: false,
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final mainContainer = containers.first;
      final decoration = mainContainer.decoration as BoxDecoration;

      expect(decoration.border, isNull);
    });

    testWidgets('debería tener border cuando hasDecoration es true', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFieldSkeleton(
              baseColor: baseColor,
              hasDecoration: true,
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      final mainContainer = containers.first;
      final decoration = mainContainer.decoration as BoxDecoration;

      expect(decoration.border, isNotNull);
    });

    testWidgets('debería mostrar elementos internos correctamente', (
      tester,
    ) async {
      const baseColor = Colors.grey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFieldSkeleton(
              baseColor: baseColor,
              width: 200,
              height: 60,
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.length, greaterThan(1));

      expect(find.byType(Padding), findsWidgets);

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('debería heredar propiedades de BaseSkeleton', (tester) async {
      const baseColor = Colors.red;
      const textFieldSkeleton = TextFieldSkeleton(baseColor: baseColor);

      expect(textFieldSkeleton.baseColor, baseColor);
      expect(textFieldSkeleton.borderRadius, 8);
      expect(textFieldSkeleton.isMultiline, false);
      expect(textFieldSkeleton.hasDecoration, true);
    });
  });
}
