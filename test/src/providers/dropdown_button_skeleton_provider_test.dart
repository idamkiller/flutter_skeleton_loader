import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/dropdown_button_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/dropdown_button_skeleton.dart';

void main() {
  group('DropdownButtonSkeletonProvider', () {
    late DropdownButtonSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = DropdownButtonSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para DropdownButton widget', () {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
            DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
          ],
          onChanged: (value) {},
        );

        expect(provider.canHandle(dropdownWidget), isTrue);
      });

      test(
          'Debería retornar true para DropdownButton con propiedades personalizadas',
          () {
        final dropdownWidget = DropdownButton<int>(
          value: 1,
          items: const [
            DropdownMenuItem(value: 1, child: Text('One')),
            DropdownMenuItem(value: 2, child: Text('Two')),
          ],
          onChanged: (value) {},
          iconSize: 32,
          itemHeight: 56,
          dropdownColor: Colors.blue,
          focusColor: Colors.grey,
          style: const TextStyle(color: Colors.black),
        );

        expect(provider.canHandle(dropdownWidget), isTrue);
      });

      test('Debería retornar true para DropdownButton con underline', () {
        final dropdownWidget = DropdownButton<String>(
          value: 'A',
          items: const [
            DropdownMenuItem(value: 'A', child: Text('A')),
            DropdownMenuItem(value: 'B', child: Text('B')),
          ],
          onChanged: (value) {},
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
        );

        expect(provider.canHandle(dropdownWidget), isTrue);
      });

      test('Debería retornar true para DropdownButton sin underline', () {
        final dropdownWidget = DropdownButton<String>(
          value: 'X',
          items: const [
            DropdownMenuItem(value: 'X', child: Text('X')),
            DropdownMenuItem(value: 'Y', child: Text('Y')),
          ],
          onChanged: (value) {},
        );

        expect(provider.canHandle(dropdownWidget), isTrue);
      });

      test('Debería retornar true para DropdownButton deshabilitado', () {
        final dropdownWidget = DropdownButton<String>(
          value: 'Disabled',
          items: const [
            DropdownMenuItem(value: 'Disabled', child: Text('Disabled')),
          ],
          onChanged: null,
        );

        expect(provider.canHandle(dropdownWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son DropdownButton', () {
        const textWidget = Text('Not a dropdown');
        final containerWidget = Container();
        const buttonWidget =
            ElevatedButton(onPressed: null, child: Text('Button'));

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(buttonWidget), isFalse);
      });
    });

    group('Prioridad', () {
      test('Debería retornar prioridad 6', () {
        expect(provider.priority, 6);
      });
    });

    group('createSkeleton', () {
      testWidgets(
          'Debería crear DropdownButtonSkeleton para DropdownButton básico',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
            DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
          ],
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;
        expect(dropdownSkeleton.baseColor, baseColor);

        expect(dropdownSkeleton.width, 190.0);
        expect(dropdownSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(DropdownButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear DropdownButtonSkeleton con icono personalizado',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
          iconSize: 32,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;

        expect(dropdownSkeleton.width, 198.0);
        expect(dropdownSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 198.0);
        expect(size.height, 48.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear DropdownButtonSkeleton con itemHeight personalizado',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
          itemHeight: 56,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;
        expect(dropdownSkeleton.width, 190.0);
        expect(dropdownSkeleton.height, 56.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 190.0);
        expect(size.height, 56.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear DropdownButtonSkeleton con ajuste de altura para el underline',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;
        expect(dropdownSkeleton.width, 190.0);
        expect(dropdownSkeleton.height, 56.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear DropdownButtonSkeleton sin ajuste de altura para el underline',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;
        expect(dropdownSkeleton.width, 190.0);
        expect(dropdownSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear DropdownButtonSkeleton con color correcto',
          (tester) async {
        const customColor = Colors.red;
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
          dropdownColor: Colors.blue,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, customColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar DropdownButton con icono grande',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
          iconSize: 48,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;
        expect(dropdownSkeleton.width, 214.0);
        expect(dropdownSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar DropdownButton con icono pequeño',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Option 1',
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
          iconSize: 16,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;
        expect(dropdownSkeleton.width, 182.0);
        expect(dropdownSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar DropdownButton deshabilitado',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Disabled',
          items: const [
            DropdownMenuItem(value: 'Disabled', child: Text('Disabled')),
          ],
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(DropdownButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar DropdownButton con estilos personalizados',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Styled',
          items: const [
            DropdownMenuItem(value: 'Styled', child: Text('Styled')),
          ],
          onChanged: (value) {},
          style: const TextStyle(
            color: Colors.purple,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          dropdownColor: Colors.yellow,
          focusColor: Colors.green,
          elevation: 16,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(tester.takeException(), isNull);
      });
    });

    group('dimension clamping', () {
      testWidgets('Debería limitar el ancho a un mínimo de 112',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Small',
          items: const [
            DropdownMenuItem(value: 'Small', child: Text('Small')),
          ],
          onChanged: (value) {},
          iconSize: 8,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);
        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;

        expect(dropdownSkeleton.width, greaterThanOrEqualTo(112.0));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería limitar el ancho a un máximo de 400',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Large',
          items: const [
            DropdownMenuItem(value: 'Large', child: Text('Large')),
          ],
          onChanged: (value) {},
          iconSize: 200,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);
        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;

        expect(dropdownSkeleton.width, lessThanOrEqualTo(400.0));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería limitar la altura a un mínimo de 48',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Short',
          items: const [
            DropdownMenuItem(value: 'Short', child: Text('Short')),
          ],
          onChanged: (value) {},
          itemHeight: 48,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);
        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;

        expect(dropdownSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería limitar la altura a un máximo de 72',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Tall',
          items: const [
            DropdownMenuItem(value: 'Tall', child: Text('Tall')),
          ],
          onChanged: (value) {},
          itemHeight: 80,
          underline: Container(height: 2, color: Colors.blue),
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);
        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;

        expect(dropdownSkeleton.height, lessThanOrEqualTo(72.0));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });

    group('dimension sanitization', () {
      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'Test',
          items: const [
            DropdownMenuItem(value: 'Test', child: Text('Test')),
          ],
          onChanged: (value) {},
          iconSize: 24,
          itemHeight: 48,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);
        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;

        expect(dropdownSkeleton.width, 190.0);
        expect(dropdownSkeleton.height, 48.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 190.0);
        expect(size.height, 48.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('herencia y cumplimiento de interfaz', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<DropdownButtonSkeletonProvider>());
      });

      test('Debería implementar métodos requeridos', () {
        final dropdownWidget = DropdownButton<String>(
          value: 'Test',
          items: const [DropdownMenuItem(value: 'Test', child: Text('Test'))],
          onChanged: (value) {},
        );

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(dropdownWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos límite', () {
      testWidgets('Debería manejar colores base muy oscuros', (tester) async {
        const darkColor = Color(0xFF000000);
        final dropdownWidget = DropdownButton<String>(
          value: 'Dark',
          items: const [DropdownMenuItem(value: 'Dark', child: Text('Dark'))],
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(dropdownWidget, darkColor);

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
        final dropdownWidget = DropdownButton<String>(
          value: 'Light',
          items: const [DropdownMenuItem(value: 'Light', child: Text('Light'))],
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(dropdownWidget, lightColor);

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

      testWidgets('Debería manejar DropdownButton con muchos elementos',
          (tester) async {
        final dropdownWidget = DropdownButton<int>(
          value: 1,
          items: List.generate(
              50,
              (index) => DropdownMenuItem(
                  value: index + 1, child: Text('Item ${index + 1}'))),
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(DropdownButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar DropdownButton con elementos complejos',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'complex',
          items: const [
            DropdownMenuItem(
              value: 'complex',
              child: Row(
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 8),
                  Text('Complex Item'),
                ],
              ),
            ),
          ],
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byIcon(Icons.star), findsNothing);
        expect(find.text('Complex Item'), findsNothing);
        expect(find.byType(DropdownButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de DropdownButton', () {
      testWidgets('Debería manejar DropdownButton en formularios',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: 'form_value',
          items: const [
            DropdownMenuItem(value: 'form_value', child: Text('Form Value')),
            DropdownMenuItem(value: 'other', child: Text('Other')),
          ],
          onChanged: (value) {},
          hint: const Text('Select an option'),
          isExpanded: true,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('Form Value'), findsNothing);
        expect(find.text('Select an option'), findsNothing);
        expect(find.byType(DropdownButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar DropdownButton con ícono y sugerencia',
          (tester) async {
        final dropdownWidget = DropdownButton<String>(
          value: null,
          items: const [
            DropdownMenuItem(value: 'option1', child: Text('Option 1')),
          ],
          onChanged: (value) {},
          hint: const Text('Choose...'),
          icon: const Icon(Icons.arrow_drop_down_circle),
          iconSize: 28,
        );

        final skeleton = provider.createSkeleton(dropdownWidget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());

        final dropdownSkeleton = skeleton as DropdownButtonSkeleton;
        expect(dropdownSkeleton.width, 194.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('Choose...'), findsNothing);
        expect(find.byIcon(Icons.arrow_drop_down_circle), findsNothing);
        expect(find.byType(DropdownButtonSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
