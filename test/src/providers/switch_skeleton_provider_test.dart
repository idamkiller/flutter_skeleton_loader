import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/switch_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/switch_skeleton.dart';

void main() {
  group('SwitchSkeletonProvider', () {
    late SwitchSkeletonProvider provider;
    late Color baseColor;

    setUp(() {
      provider = SwitchSkeletonProvider();
      baseColor = const Color(0xFF9E9E9E);
    });

    group('canHandle', () {
      test('Debería aceptar widgets Switch', () {
        const switchWidget = Switch(value: true, onChanged: null);
        expect(provider.canHandle(switchWidget), isTrue);
      });

      test('Debería aceptar Switch con diferentes configuraciones', () {
        final switches = [
          const Switch(value: false, onChanged: null),
          const Switch(value: true, onChanged: null),
          Switch(value: false, onChanged: (value) {}),
          const Switch.adaptive(value: true, onChanged: null),
        ];

        for (final switchWidget in switches) {
          expect(provider.canHandle(switchWidget), isTrue);
        }
      });

      test('Debería rechazar widgets que no son Switch', () {
        final widgets = [
          const Text('Test'),
          Container(),
          const Icon(Icons.star),
          const ElevatedButton(onPressed: null, child: Text('Button')),
          const Checkbox(value: false, onChanged: null),
          const Slider(value: 0.5, onChanged: null),
          const SizedBox(),
        ];

        for (final widget in widgets) {
          expect(provider.canHandle(widget), isFalse);
        }
      });
    });

    group('priority', () {
      test('Debería tener prioridad 6', () {
        expect(provider.priority, 6);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear SwitchSkeleton básico', (tester) async {
        const switchWidget = Switch(value: true, onChanged: null);

        final skeleton = provider.createSkeleton(switchWidget, baseColor);

        expect(skeleton, isA<SwitchSkeleton>());

        final switchSkeleton = skeleton as SwitchSkeleton;
        expect(switchSkeleton.baseColor, baseColor);
        expect(switchSkeleton.width, 56.0);
        expect(switchSkeleton.height, 32.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería usar dimensiones fijas independientemente del valor',
          (tester) async {
        const testCases = [
          {'value': true},
          {'value': false},
        ];

        for (final testCase in testCases) {
          final switchWidget = Switch(
            value: testCase['value'] as bool,
            onChanged: null,
          );

          final skeleton = provider.createSkeleton(switchWidget, baseColor);
          final switchSkeleton = skeleton as SwitchSkeleton;

          expect(switchSkeleton.width, 56.0);
          expect(switchSkeleton.height, 32.0);
        }
      });

      testWidgets('Debería preservar el color base correctamente',
          (tester) async {
        const colors = [
          Color(0xFF000000),
          Color(0xFFFFFFFF),
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0x80808080),
        ];

        for (final color in colors) {
          const switchWidget = Switch(value: true, onChanged: null);
          final skeleton = provider.createSkeleton(switchWidget, color);
          final switchSkeleton = skeleton as SwitchSkeleton;

          expect(switchSkeleton.baseColor, color);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final container = tester.widget<Container>(find.byType(Container));
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.color, color);

          await tester.pumpWidget(Container());
        }
      });

      testWidgets('Debería manejar Switch disabled', (tester) async {
        const switchWidget = Switch(
          value: false,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(switchWidget, baseColor);
        final switchSkeleton = skeleton as SwitchSkeleton;

        expect(switchSkeleton.width, 56.0);
        expect(switchSkeleton.height, 32.0);
        expect(switchSkeleton.baseColor, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Switch con callback', (tester) async {
        var currentValue = true;
        final switchWidget = Switch(
          value: currentValue,
          onChanged: (value) => currentValue = value,
        );

        final skeleton = provider.createSkeleton(switchWidget, baseColor);
        final switchSkeleton = skeleton as SwitchSkeleton;

        expect(switchSkeleton.width, 56.0);
        expect(switchSkeleton.height, 32.0);
        expect(switchSkeleton.baseColor, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Switch.adaptive', (tester) async {
        const switchWidget = Switch.adaptive(
          value: true,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(switchWidget, baseColor);
        final switchSkeleton = skeleton as SwitchSkeleton;

        expect(switchSkeleton.width, 56.0);
        expect(switchSkeleton.height, 32.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería aplicar sanitización correctamente', (tester) async {
        const switchWidget = Switch(value: false, onChanged: null);
        final skeleton = provider.createSkeleton(switchWidget, baseColor);
        final switchSkeleton = skeleton as SwitchSkeleton;

        expect(switchSkeleton.width, 56.0);
        expect(switchSkeleton.height, 32.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, 56.0);
        expect(container.constraints?.maxHeight, 32.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería renderizar correctamente en diferentes contextos',
          (tester) async {
        const switchWidget = Switch(value: true, onChanged: null);
        final skeleton = provider.createSkeleton(switchWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  skeleton,
                  const Text('Texto de prueba'),
                  skeleton,
                ],
              ),
            ),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsNWidgets(2));
        expect(find.text('Texto de prueba'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería verificar el borderRadius correcto en SwitchSkeleton',
          (tester) async {
        const switchWidget = Switch(value: true, onChanged: null);
        final skeleton = provider.createSkeleton(switchWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(12));
        expect(tester.takeException(), isNull);
      });
    });

    group('herencia de BaseSkeletonProvider', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<SwitchSkeletonProvider>());
      });

      test('Debería implementar todos los métodos requeridos', () {
        const switchWidget = Switch(value: true, onChanged: null);

        expect(() => provider.canHandle(switchWidget), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(switchWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar múltiples Switch con diferentes estados',
          (tester) async {
        final switches = [
          const Switch(value: true, onChanged: null),
          const Switch(value: false, onChanged: null),
          Switch(value: true, onChanged: (value) {}),
          const Switch.adaptive(value: false, onChanged: null),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: switches.asMap().entries.map((entry) {
                  final index = entry.key;
                  final switchWidget = entry.value;
                  final color = Color(0xFF000000 + (index * 0x333333));
                  return provider.createSkeleton(switchWidget, color);
                }).toList(),
              ),
            ),
          ),
        );

        final switchSkeletons = tester
            .widgetList<SwitchSkeleton>(find.byType(SwitchSkeleton))
            .toList();
        expect(switchSkeletons, hasLength(4));

        for (final skeleton in switchSkeletons) {
          expect(skeleton.width, 56.0);
          expect(skeleton.height, 32.0);
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Switch anidados en layouts complejos',
          (tester) async {
        const switchWidget = Switch(value: true, onChanged: null);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Text('Estado:'),
                          const SizedBox(width: 8),
                          provider.createSkeleton(switchWidget, baseColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsOneWidget);

        final switchSkeleton =
            tester.widget<SwitchSkeleton>(find.byType(SwitchSkeleton));
        expect(switchSkeleton.width, 56.0);
        expect(switchSkeleton.height, 32.0);
        expect(switchSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería mantener consistencia con diferentes instancias de provider',
          (tester) async {
        final provider1 = SwitchSkeletonProvider();
        final provider2 = SwitchSkeletonProvider();

        const switchWidget = Switch(value: false, onChanged: null);
        const testColor = Color(0xFF123456);

        final skeleton1 = provider1.createSkeleton(switchWidget, testColor);
        final skeleton2 = provider2.createSkeleton(switchWidget, testColor);

        expect(skeleton1.runtimeType, skeleton2.runtimeType);

        final switchSkeleton1 = skeleton1 as SwitchSkeleton;
        final switchSkeleton2 = skeleton2 as SwitchSkeleton;

        expect(switchSkeleton1.width, switchSkeleton2.width);
        expect(switchSkeleton1.height, switchSkeleton2.height);
        expect(switchSkeleton1.baseColor, switchSkeleton2.baseColor);
      });

      testWidgets('Debería ignorar propiedades específicas del Switch',
          (tester) async {
        const switches = [
          Switch(value: true, onChanged: null),
          Switch(value: false, onChanged: null),
          Switch.adaptive(value: true, onChanged: null),
        ];

        for (final switchWidget in switches) {
          final skeleton = provider.createSkeleton(switchWidget, baseColor);
          final switchSkeleton = skeleton as SwitchSkeleton;

          expect(switchSkeleton.width, 56.0);
          expect(switchSkeleton.height, 32.0);
          expect(switchSkeleton.baseColor, baseColor);
        }
      });
    });

    group('integración con Flutter framework', () {
      testWidgets('Debería funcionar correctamente en StatefulWidget',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestSwitchWidget(provider: provider, baseColor: baseColor),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsOneWidget);

        final switchSkeleton =
            tester.widget<SwitchSkeleton>(find.byType(SwitchSkeleton));
        expect(switchSkeleton.width, 56.0);
        expect(switchSkeleton.height, 32.0);
        expect(switchSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar cambios de estado correctamente',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestSwitchWidget(provider: provider, baseColor: baseColor),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.byType(SwitchSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería renderizar skeleton en lugar del widget original',
          (tester) async {
        const switchWidget = Switch(value: true, onChanged: null);
        final skeleton = provider.createSkeleton(switchWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SwitchSkeleton), findsOneWidget);
        expect(find.byType(Switch), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería verificar que SwitchSkeleton usa defaults cuando no se pasan dimensiones',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SwitchSkeleton(baseColor: baseColor),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, 40.0);
        expect(container.constraints?.maxHeight, 24.0);
        expect(tester.takeException(), isNull);
      });
    });

    group('sanitización', () {
      test('Debería aplicar sanitización a width', () {
        const switchWidget = Switch(value: true, onChanged: null);
        final skeleton = provider.createSkeleton(switchWidget, baseColor);
        final switchSkeleton = skeleton as SwitchSkeleton;

        expect(switchSkeleton.width, 56.0);
      });

      test('Debería aplicar sanitización a height', () {
        const switchWidget = Switch(value: false, onChanged: null);
        final skeleton = provider.createSkeleton(switchWidget, baseColor);
        final switchSkeleton = skeleton as SwitchSkeleton;

        expect(switchSkeleton.height, 32.0);
      });

      testWidgets('Debería mantener las dimensiones sanitizadas en renderizado',
          (tester) async {
        const switchWidget = Switch(value: true, onChanged: null);
        final skeleton = provider.createSkeleton(switchWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, 56.0);
        expect(container.constraints?.maxHeight, 32.0);
        expect(tester.takeException(), isNull);
      });
    });
  });
}

class _TestSwitchWidget extends StatefulWidget {
  final SwitchSkeletonProvider provider;
  final Color baseColor;

  const _TestSwitchWidget({
    required this.provider,
    required this.baseColor,
  });

  @override
  State<_TestSwitchWidget> createState() => _TestSwitchWidgetState();
}

class _TestSwitchWidgetState extends State<_TestSwitchWidget> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch(value: _switchValue, onChanged: null);
    final skeleton =
        widget.provider.createSkeleton(switchWidget, widget.baseColor);

    return Scaffold(
      body: Column(
        children: [
          skeleton,
          ElevatedButton(
            onPressed: () {
              setState(() {
                _switchValue = !_switchValue;
              });
            },
            child: const Text('Cambiar Estado'),
          ),
        ],
      ),
    );
  }
}
