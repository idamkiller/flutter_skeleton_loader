import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/checkbox_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/checkbox_skeleton.dart';

void main() {
  group('CheckboxSkeletonProvider', () {
    late CheckboxSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = CheckboxSkeletonProvider();
    });

    group('canHandle', () {
      test('Debe devolver verdadero para el widget Casilla de verificación.',
          () {
        const checkboxWidget = Checkbox(
          value: true,
          onChanged: null,
        );

        expect(provider.canHandle(checkboxWidget), isTrue);
      });

      test('Debe devolver verdadero para Checkbox con valor falso', () {
        const checkboxWidget = Checkbox(
          value: false,
          onChanged: null,
        );

        expect(provider.canHandle(checkboxWidget), isTrue);
      });

      test('Debe devolver verdadero para Checkbox con valor nulo', () {
        final checkboxWidget = Checkbox(
          value: null,
          tristate: true,
          onChanged: null,
        );

        expect(provider.canHandle(checkboxWidget), isTrue);
      });

      test('Debe devolver verdadero para Checkbox con valor nulo', () {
        final checkboxWidget = Checkbox(
          value: null,
          tristate: true,
          onChanged: null,
        );

        expect(provider.canHandle(checkboxWidget), isTrue);
      });

      test(
          'Debe devolver verdadero para Checkbox con propiedades personalizadas',
          () {
        const checkboxWidget = Checkbox(
          value: true,
          activeColor: Colors.blue,
          checkColor: Colors.white,
          focusColor: Colors.grey,
          hoverColor: Colors.lightBlue,
          onChanged: null,
        );

        expect(provider.canHandle(checkboxWidget), isTrue);
      });

      test('Debe devolver falso para widgets que no son Checkbox', () {
        const textWidget = Text('Not a checkbox');
        final containerWidget = Container();
        const buttonWidget =
            ElevatedButton(onPressed: null, child: Text('Button'));

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(buttonWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería devolver prioridad 6', () {
        expect(provider.priority, 6);
      });
    });

    group('createSkeleton', () {
      testWidgets(
          'Debería crear CheckboxSkeleton para la casilla de verificación básica.',
          (tester) async {
        const checkboxWidget = Checkbox(
          value: true,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);

        expect(skeleton, isA<CheckboxSkeleton>());

        final checkboxSkeleton = skeleton as CheckboxSkeleton;
        expect(checkboxSkeleton.baseColor, baseColor);
        expect(checkboxSkeleton.width, 18.0);
        expect(checkboxSkeleton.height, 18.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(CheckboxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear CheckboxSkeleton con las dimensiones correctas',
          (tester) async {
        const checkboxWidget = Checkbox(
          value: false,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        expect(containerWidget.constraints, isNotNull);

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 18.0);
        expect(size.height, 18.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear CheckboxSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        final checkboxWidget = Checkbox(
          value: null,
          tristate: true,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(checkboxWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, customColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear CheckboxSkeleton con el radio de borde correcto',
          (tester) async {
        const checkboxWidget = Checkbox(
          value: true,
          activeColor: Colors.green,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(4));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Checkbox con colores personalizados',
          (tester) async {
        const checkboxWidget = Checkbox(
          value: true,
          activeColor: Colors.red,
          checkColor: Colors.yellow,
          focusColor: Colors.purple,
          hoverColor: Colors.orange,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);

        expect(skeleton, isA<CheckboxSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Checkbox deshabilitada', (tester) async {
        const checkboxWidget = Checkbox(
          value: false,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);

        expect(skeleton, isA<CheckboxSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(CheckboxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar la casilla de verificación habilitada.',
          (tester) async {
        final checkboxWidget = Checkbox(
          value: true,
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);

        expect(skeleton, isA<CheckboxSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(CheckboxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Checkbox con diferentes estados',
          (tester) async {
        const checkedWidget = Checkbox(value: true, onChanged: null);
        final checkedSkeleton =
            provider.createSkeleton(checkedWidget, baseColor);

        const uncheckedWidget = Checkbox(value: false, onChanged: null);
        final uncheckedSkeleton =
            provider.createSkeleton(uncheckedWidget, baseColor);

        final indeterminateWidget =
            Checkbox(value: null, tristate: true, onChanged: null);
        final indeterminateSkeleton =
            provider.createSkeleton(indeterminateWidget, baseColor);

        expect(checkedSkeleton, isA<CheckboxSkeleton>());
        expect(uncheckedSkeleton, isA<CheckboxSkeleton>());
        expect(indeterminateSkeleton, isA<CheckboxSkeleton>());

        final checkedSk = checkedSkeleton as CheckboxSkeleton;
        final uncheckedSk = uncheckedSkeleton as CheckboxSkeleton;
        final indeterminateSk = indeterminateSkeleton as CheckboxSkeleton;

        expect(checkedSk.width, 18.0);
        expect(checkedSk.height, 18.0);
        expect(uncheckedSk.width, 18.0);
        expect(uncheckedSk.height, 18.0);
        expect(indeterminateSk.width, 18.0);
        expect(indeterminateSk.height, 18.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  checkedSkeleton,
                  uncheckedSkeleton,
                  indeterminateSkeleton
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CheckboxSkeleton), findsNWidgets(3));
        expect(tester.takeException(), isNull);
      });
    });

    group('dimension sanitization', () {
      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        const checkboxWidget = Checkbox(value: true, onChanged: null);

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);
        final checkboxSkeleton = skeleton as CheckboxSkeleton;

        expect(checkboxSkeleton.width, 18.0);
        expect(checkboxSkeleton.height, 18.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 18.0);
        expect(size.height, 18.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('Herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<CheckboxSkeletonProvider>());
      });

      test('Debería implementar métodos requeridos', () {
        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(
            () => provider.createSkeleton(
                const Checkbox(value: true, onChanged: null), baseColor),
            returnsNormally);
      });
    });

    group('Casos de borde', () {
      testWidgets('Debería manejar colores base muy oscuros', (tester) async {
        const darkColor = Color(0xFF000000);
        const checkboxWidget = Checkbox(value: true, onChanged: null);

        final skeleton = provider.createSkeleton(checkboxWidget, darkColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, darkColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar colores base muy claros', (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        const checkboxWidget = Checkbox(value: false, onChanged: null);

        final skeleton = provider.createSkeleton(checkboxWidget, lightColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, lightColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Checkbox con MaterialTapTargetSize',
          (tester) async {
        const checkboxWidget = Checkbox(
          value: true,
          onChanged: null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );

        final skeleton = provider.createSkeleton(checkboxWidget, baseColor);

        expect(skeleton, isA<CheckboxSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(CheckboxSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
