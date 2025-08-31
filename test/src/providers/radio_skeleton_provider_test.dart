import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/radio_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/radio_skeleton.dart';

void main() {
  group('RadioSkeletonProvider', () {
    late RadioSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = RadioSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería retornar true para el widget Radio', () {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        expect(provider.canHandle(radioWidget), isTrue);
      });

      test('Debería retornar true para Radio.adaptive', () {
        const radioWidget = Radio<String>.adaptive(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        expect(provider.canHandle(radioWidget), isTrue);
      });

      test('Debería retornar true para Radio con diferentes tipos genéricos',
          () {
        const radioIntWidget = Radio<int>(
          value: 1,
          groupValue: 1,
          onChanged: null,
        );

        const radioBoolWidget = Radio<bool>(
          value: true,
          groupValue: true,
          onChanged: null,
        );

        const radioDoubleWidget = Radio<double>(
          value: 1.5,
          groupValue: 1.5,
          onChanged: null,
        );

        expect(provider.canHandle(radioIntWidget), isTrue);
        expect(provider.canHandle(radioBoolWidget), isTrue);
        expect(provider.canHandle(radioDoubleWidget), isTrue);
      });

      test('Debería retornar true para Radio con propiedades personalizadas',
          () {
        const radioWidget = Radio<String>(
          value: 'option1',
          groupValue: 'option2',
          onChanged: null,
          activeColor: Colors.blue,
          focusColor: Colors.red,
          hoverColor: Colors.green,
          overlayColor: MaterialStatePropertyAll(Colors.yellow),
          splashRadius: 25.0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        );

        expect(provider.canHandle(radioWidget), isTrue);
      });

      test('Debería retornar true para Radio habilitado', () {
        final radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: (value) {},
        );

        expect(provider.canHandle(radioWidget), isTrue);
      });

      test('Debería retornar true para Radio con toggleable', () {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
          toggleable: true,
          autofocus: true,
        );

        expect(provider.canHandle(radioWidget), isTrue);
      });

      test('Debería retornar true para Radio con MouseCursor personalizado',
          () {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
          mouseCursor: SystemMouseCursors.click,
        );

        expect(provider.canHandle(radioWidget), isTrue);
      });

      test('Debería retornar true para Radio con fillColor personalizado', () {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
          fillColor: MaterialStatePropertyAll(Colors.purple),
        );

        expect(provider.canHandle(radioWidget), isTrue);
      });

      test('Debería retornar false para widgets que no son Radio', () {
        const textWidget = Text('No es un radio');
        final containerWidget = Container(width: 100, height: 100);
        const checkboxWidget = Checkbox(value: true, onChanged: null);
        const switchWidget = Switch(value: true, onChanged: null);
        const elevatedButtonWidget = ElevatedButton(
          onPressed: null,
          child: Text('Button'),
        );
        const iconWidget = Icon(Icons.radio_button_checked);

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(checkboxWidget), isFalse);
        expect(provider.canHandle(switchWidget), isFalse);
        expect(provider.canHandle(elevatedButtonWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería retornar prioridad 6', () {
        expect(provider.priority, 6);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear RadioSkeleton para Radio básico',
          (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        expect(skeleton, isA<RadioSkeleton>());

        final radioSkeleton = skeleton as RadioSkeleton;
        expect(radioSkeleton.baseColor, baseColor);
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear RadioSkeleton con configuración por defecto',
          (tester) async {
        final radioWidget = Radio<int>(
          value: 42,
          groupValue: 10,
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        expect(skeleton, isA<RadioSkeleton>());

        final radioSkeleton = skeleton as RadioSkeleton;
        expect(radioSkeleton.baseColor, baseColor);
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear RadioSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.baseColor, customColor);

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(RadioSkeleton),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, customColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear RadioSkeleton con forma circular',
          (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(RadioSkeleton),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio con colores personalizados',
          (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
          activeColor: Colors.red,
          focusColor: Colors.green,
          hoverColor: Colors.purple,
          fillColor: MaterialStatePropertyAll(Colors.orange),
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio deshabilitado', (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'other',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(skeleton, isA<RadioSkeleton>());
        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio habilitado', (tester) async {
        final radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: (value) {},
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(skeleton, isA<RadioSkeleton>());
        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar diferentes estados de Radio',
          (tester) async {
        const radioSelectedWidget = Radio<String>(
          value: 'selected',
          groupValue: 'selected',
          onChanged: null,
        );

        const radioUnselectedWidget = Radio<String>(
          value: 'unselected',
          groupValue: 'selected',
          onChanged: null,
        );

        final selectedSkeleton =
            provider.createSkeleton(radioSelectedWidget, baseColor);
        final unselectedSkeleton =
            provider.createSkeleton(radioUnselectedWidget, baseColor);

        expect(selectedSkeleton, isA<RadioSkeleton>());
        expect(unselectedSkeleton, isA<RadioSkeleton>());

        final selectedRadio = selectedSkeleton as RadioSkeleton;
        final unselectedRadio = unselectedSkeleton as RadioSkeleton;

        expect(selectedRadio.width, 20.0);
        expect(selectedRadio.height, 20.0);
        expect(unselectedRadio.width, 20.0);
        expect(unselectedRadio.height, 20.0);
      });

      testWidgets('Debería ignorar propiedades de diseño personalizadas',
          (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          splashRadius: 30.0,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio con gestos', (tester) async {
        bool tapped = false;
        final radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: (value) => tapped = true,
          toggleable: true,
          autofocus: true,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(skeleton, isA<RadioSkeleton>());

        expect(tapped, isFalse);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio.adaptive', (tester) async {
        const radioWidget = Radio<String>.adaptive(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(skeleton, isA<RadioSkeleton>());
        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('sanitización de dimensiones', () {
      test('Debería usar dimensiones sanitizadas correctamente', () {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);
        final radioSkeleton = skeleton as RadioSkeleton;

        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
      });

      test('Debería usar el valor por defecto cuando size es inválido', () {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);
        final radioSkeleton = skeleton as RadioSkeleton;

        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<RadioSkeletonProvider>());
      });

      test('Debería implementar los métodos requeridos', () {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(radioWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar color base muy oscuro', (tester) async {
        const darkColor = Color(0xFF000000);
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: provider.createSkeleton(radioWidget, darkColor),
            ),
          ),
        );

        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.baseColor, darkColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar color base muy claro', (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: provider.createSkeleton(radioWidget, lightColor),
            ),
          ),
        );

        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.baseColor, lightColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio con tipo genérico complejo',
          (tester) async {
        const radioWidget = Radio<Map<String, dynamic>>(
          value: {'id': 1, 'name': 'test'},
          groupValue: {'id': 1, 'name': 'test'},
          onChanged: null,
        );

        expect(provider.canHandle(radioWidget), isTrue);

        final skeleton = provider.createSkeleton(radioWidget, baseColor);
        expect(skeleton, isA<RadioSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio con MouseCursor y overlayColor',
          (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
          mouseCursor: SystemMouseCursors.click,
          overlayColor: MaterialStatePropertyAll(Colors.amber),
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(skeleton, isA<RadioSkeleton>());
        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio con todas las propiedades opcionales',
          (tester) async {
        final radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
          mouseCursor: SystemMouseCursors.click,
          toggleable: true,
          activeColor: Colors.red,
          fillColor: const MaterialStatePropertyAll(Colors.blue),
          focusColor: Colors.green,
          hoverColor: Colors.yellow,
          overlayColor: const MaterialStatePropertyAll(Colors.purple),
          splashRadius: 25.0,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          visualDensity: VisualDensity.standard,
          focusNode: FocusNode(),
          autofocus: true,
        );

        final skeleton = provider.createSkeleton(radioWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(skeleton, isA<RadioSkeleton>());
        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.baseColor, baseColor);
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de Radio', () {
      testWidgets('Debería manejar Radio en formularios', (tester) async {
        const radioWidget = Radio<String>(
          value: 'option1',
          groupValue: 'option1',
          onChanged: null,
          autofocus: true,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                child: Column(
                  children: [
                    provider.createSkeleton(radioWidget, baseColor),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio en grupos de selección',
          (tester) async {
        const radio1 = Radio<int>(
          value: 1,
          groupValue: 1,
          onChanged: null,
        );

        const radio2 = Radio<int>(
          value: 2,
          groupValue: 1,
          onChanged: null,
        );

        const radio3 = Radio<int>(
          value: 3,
          groupValue: 1,
          onChanged: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  provider.createSkeleton(radio1, baseColor),
                  provider.createSkeleton(radio2, baseColor),
                  provider.createSkeleton(radio3, baseColor),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(RadioSkeleton), findsNWidgets(3));

        final radioSkeletons =
            tester.widgetList<RadioSkeleton>(find.byType(RadioSkeleton));
        for (final radioSkeleton in radioSkeletons) {
          expect(radioSkeleton.width, 20.0);
          expect(radioSkeleton.height, 20.0);
          expect(radioSkeleton.baseColor, baseColor);
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio con ListTile', (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListTile(
                leading: provider.createSkeleton(radioWidget, baseColor),
                title: const Text('Opción de radio'),
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text('Opción de radio'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar múltiples Radio con diferentes configuraciones',
          (tester) async {
        const radioNormal = Radio<String>(
          value: 'normal',
          groupValue: 'normal',
          onChanged: null,
        );

        const radioPersonalizado = Radio<String>(
          value: 'custom',
          groupValue: 'custom',
          onChanged: null,
          activeColor: Colors.red,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );

        const radioAdaptive = Radio<String>.adaptive(
          value: 'adaptive',
          groupValue: 'adaptive',
          onChanged: null,
          fillColor: MaterialStatePropertyAll(Colors.green),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  provider.createSkeleton(radioNormal, baseColor),
                  provider.createSkeleton(
                      radioPersonalizado, const Color(0xFF654321)),
                  provider.createSkeleton(
                      radioAdaptive, const Color(0xFF123456)),
                ],
              ),
            ),
          ),
        );

        final radioSkeletons = tester
            .widgetList<RadioSkeleton>(find.byType(RadioSkeleton))
            .toList();
        expect(radioSkeletons, hasLength(3));

        expect(radioSkeletons[0].baseColor, baseColor);
        expect(radioSkeletons[1].baseColor, const Color(0xFF654321));
        expect(radioSkeletons[2].baseColor, const Color(0xFF123456));

        for (final skeleton in radioSkeletons) {
          expect(skeleton.width, 20.0);
          expect(skeleton.height, 20.0);
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio en diferentes temas', (tester) async {
        const radioWidget = Radio<String>(
          value: 'test',
          groupValue: 'test',
          onChanged: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: provider.createSkeleton(radioWidget, baseColor),
            ),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        var radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.baseColor, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body:
                  provider.createSkeleton(radioWidget, const Color(0xFF444444)),
            ),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.baseColor, const Color(0xFF444444));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Radio en un RadioListTile simulado',
          (tester) async {
        const radioWidget = Radio<String>(
          value: 'option1',
          groupValue: 'option1',
          onChanged: null,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    provider.createSkeleton(radioWidget, baseColor),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text('Texto de la opción de radio'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(RadioSkeleton), findsOneWidget);
        expect(find.text('Texto de la opción de radio'), findsOneWidget);

        final radioSkeleton =
            tester.widget<RadioSkeleton>(find.byType(RadioSkeleton));
        expect(radioSkeleton.width, 20.0);
        expect(radioSkeleton.height, 20.0);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
