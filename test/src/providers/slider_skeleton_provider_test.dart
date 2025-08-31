import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/slider_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/slider_skeleton.dart';

void main() {
  group('SliderSkeletonProvider', () {
    late SliderSkeletonProvider provider;
    late Color baseColor;

    setUp(() {
      provider = SliderSkeletonProvider();
      baseColor = const Color(0xFF9E9E9E);
    });

    group('canHandle', () {
      test('Debería aceptar widgets Slider', () {
        const slider = Slider(value: 0.5, onChanged: null);
        expect(provider.canHandle(slider), isTrue);
      });

      test('Debería aceptar Slider con diferentes configuraciones', () {
        const sliders = [
          Slider(value: 0.0, min: 0.0, max: 1.0, onChanged: null),
          Slider(value: 50.0, min: 0.0, max: 100.0, onChanged: null),
          Slider(value: 0.25, divisions: 4, onChanged: null),
          Slider(value: 0.7, label: 'Test', onChanged: null),
        ];

        for (final slider in sliders) {
          expect(provider.canHandle(slider), isTrue);
        }
      });

      test('Debería rechazar widgets que no son Slider', () {
        final widgets = [
          const Text('Test'),
          Container(),
          const Icon(Icons.star),
          const ElevatedButton(onPressed: null, child: Text('Button')),
          const Switch(value: false, onChanged: null),
          const Checkbox(value: false, onChanged: null),
          const SizedBox(),
        ];

        for (final widget in widgets) {
          expect(provider.canHandle(widget), isFalse);
        }
      });
    });

    group('priority', () {
      test('Debería tener prioridad 5', () {
        expect(provider.priority, 5);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear SliderSkeleton básico', (tester) async {
        const sliderWidget = Slider(value: 0.5, onChanged: null);

        final skeleton = provider.createSkeleton(sliderWidget, baseColor);

        expect(skeleton, isA<SliderSkeleton>());

        final sliderSkeleton = skeleton as SliderSkeleton;
        expect(sliderSkeleton.baseColor, baseColor);
        expect(sliderSkeleton.height, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SliderSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería ignorar las propiedades del Slider original',
          (tester) async {
        const sliderWidget = Slider(
          value: 75.0,
          min: 0.0,
          max: 100.0,
          divisions: 10,
          label: 'Valor: 75',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(sliderWidget, baseColor);
        final sliderSkeleton = skeleton as SliderSkeleton;

        expect(sliderSkeleton.height, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxHeight, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería usar altura fija de 20 independientemente del valor',
          (tester) async {
        const testCases = [
          {'value': 0.0, 'min': 0.0, 'max': 1.0},
          {'value': 1.0, 'min': 0.0, 'max': 1.0},
          {'value': 50.0, 'min': 0.0, 'max': 100.0},
          {'value': -10.0, 'min': -100.0, 'max': 100.0},
        ];

        for (final testCase in testCases) {
          final sliderWidget = Slider(
            value: testCase['value'] as double,
            min: testCase['min'] as double,
            max: testCase['max'] as double,
            onChanged: null,
          );

          final skeleton = provider.createSkeleton(sliderWidget, baseColor);
          final sliderSkeleton = skeleton as SliderSkeleton;

          expect(sliderSkeleton.height, 20.0);
        }
      });

      testWidgets('Debería usar altura fija independientemente de divisions',
          (tester) async {
        const testCases = [
          null,
          1,
          4,
          100,
        ];

        for (final divisions in testCases) {
          final sliderWidget = Slider(
            value: 0.5,
            divisions: divisions,
            onChanged: null,
          );

          final skeleton = provider.createSkeleton(sliderWidget, baseColor);
          final sliderSkeleton = skeleton as SliderSkeleton;

          expect(sliderSkeleton.height, 20.0);
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
          const sliderWidget = Slider(value: 0.5, onChanged: null);
          final skeleton = provider.createSkeleton(sliderWidget, color);
          final sliderSkeleton = skeleton as SliderSkeleton;

          expect(sliderSkeleton.baseColor, color);

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

      testWidgets('Debería manejar Slider disabled', (tester) async {
        const sliderWidget = Slider(
          value: 0.3,
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(sliderWidget, baseColor);
        final sliderSkeleton = skeleton as SliderSkeleton;

        expect(sliderSkeleton.height, 20.0);
        expect(sliderSkeleton.baseColor, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SliderSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Slider con callback', (tester) async {
        var currentValue = 0.5;
        final sliderWidget = Slider(
          value: currentValue,
          onChanged: (value) => currentValue = value,
        );

        final skeleton = provider.createSkeleton(sliderWidget, baseColor);
        final sliderSkeleton = skeleton as SliderSkeleton;

        expect(sliderSkeleton.height, 20.0);
        expect(sliderSkeleton.baseColor, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SliderSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Slider con label', (tester) async {
        const sliderWidget = Slider(
          value: 0.8,
          label: 'Volumen: 80%',
          onChanged: null,
        );

        final skeleton = provider.createSkeleton(sliderWidget, baseColor);
        final sliderSkeleton = skeleton as SliderSkeleton;

        expect(sliderSkeleton.height, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SliderSkeleton), findsOneWidget);
        expect(find.text('Volumen: 80%'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería renderizar correctamente en diferentes contextos',
          (tester) async {
        const sliderWidget = Slider(value: 0.5, onChanged: null);
        final skeleton = provider.createSkeleton(sliderWidget, baseColor);

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

        expect(find.byType(SliderSkeleton), findsNWidgets(2));
        expect(find.text('Texto de prueba'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('herencia de BaseSkeletonProvider', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<SliderSkeletonProvider>());
      });

      test('Debería implementar todos los métodos requeridos', () {
        const slider = Slider(value: 0.5, onChanged: null);

        expect(() => provider.canHandle(slider), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(
            () => provider.createSkeleton(slider, baseColor), returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar valores de slider extremos', (tester) async {
        const extremeValues = [
          {'value': 0.0, 'min': 0.0, 'max': 1.0},
          {'value': 1.0, 'min': 0.0, 'max': 1.0},
          {'value': -999999.0, 'min': -999999.0, 'max': 999999.0},
          {'value': 999999.0, 'min': -999999.0, 'max': 999999.0},
          {'value': 0.000001, 'min': 0.0, 'max': 0.000002},
        ];

        for (final testCase in extremeValues) {
          final sliderWidget = Slider(
            value: testCase['value'] as double,
            min: testCase['min'] as double,
            max: testCase['max'] as double,
            onChanged: null,
          );

          final skeleton = provider.createSkeleton(sliderWidget, baseColor);

          expect(skeleton, isA<SliderSkeleton>());

          final sliderSkeleton = skeleton as SliderSkeleton;
          expect(sliderSkeleton.height, 20.0);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(SliderSkeleton), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tester.pumpWidget(Container());
        }
      });

      testWidgets(
          'Debería manejar múltiples Slider con diferentes configuraciones',
          (tester) async {
        final sliders = [
          const Slider(value: 0.2, onChanged: null),
          const Slider(value: 0.5, min: 0.0, max: 10.0, onChanged: null),
          const Slider(value: 1.0, divisions: 5, onChanged: null),
          const Slider(value: 0.8, label: 'Test', onChanged: null),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: sliders.asMap().entries.map((entry) {
                  final index = entry.key;
                  final slider = entry.value;
                  final color = Color(0xFF000000 + (index * 0x222222));
                  return provider.createSkeleton(slider, color);
                }).toList(),
              ),
            ),
          ),
        );

        final sliderSkeletons = tester
            .widgetList<SliderSkeleton>(find.byType(SliderSkeleton))
            .toList();
        expect(sliderSkeletons, hasLength(4));

        for (final skeleton in sliderSkeletons) {
          expect(skeleton.height, 20.0);
        }

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Slider anidados en layouts complejos',
          (tester) async {
        const sliderWidget = Slider(value: 0.6, onChanged: null);

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
                          Expanded(
                            child: provider.createSkeleton(
                                sliderWidget, baseColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SliderSkeleton), findsOneWidget);

        final sliderSkeleton =
            tester.widget<SliderSkeleton>(find.byType(SliderSkeleton));
        expect(sliderSkeleton.height, 20.0);
        expect(sliderSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería mantener consistencia con diferentes instancias de provider',
          (tester) async {
        final provider1 = SliderSkeletonProvider();
        final provider2 = SliderSkeletonProvider();

        const sliderWidget = Slider(value: 0.4, onChanged: null);
        const testColor = Color(0xFF123456);

        final skeleton1 = provider1.createSkeleton(sliderWidget, testColor);
        final skeleton2 = provider2.createSkeleton(sliderWidget, testColor);

        expect(skeleton1.runtimeType, skeleton2.runtimeType);

        final sliderSkeleton1 = skeleton1 as SliderSkeleton;
        final sliderSkeleton2 = skeleton2 as SliderSkeleton;

        expect(sliderSkeleton1.height, sliderSkeleton2.height);
        expect(sliderSkeleton1.baseColor, sliderSkeleton2.baseColor);
      });
    });

    group('integración con Flutter framework', () {
      testWidgets('Debería funcionar correctamente en StatefulWidget',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestSliderWidget(provider: provider, baseColor: baseColor),
          ),
        );

        expect(find.byType(SliderSkeleton), findsOneWidget);

        final sliderSkeleton =
            tester.widget<SliderSkeleton>(find.byType(SliderSkeleton));
        expect(sliderSkeleton.height, 20.0);
        expect(sliderSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar cambios de estado correctamente',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestSliderWidget(provider: provider, baseColor: baseColor),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.byType(SliderSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería renderizar skeleton en lugar del widget original',
          (tester) async {
        const sliderWidget = Slider(value: 0.5, onChanged: null);
        final skeleton = provider.createSkeleton(sliderWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(SliderSkeleton), findsOneWidget);
        expect(find.byType(Slider), findsNothing);
        expect(tester.takeException(), isNull);
      });
    });
  });
}

class _TestSliderWidget extends StatefulWidget {
  final SliderSkeletonProvider provider;
  final Color baseColor;

  const _TestSliderWidget({
    required this.provider,
    required this.baseColor,
  });

  @override
  State<_TestSliderWidget> createState() => _TestSliderWidgetState();
}

class _TestSliderWidgetState extends State<_TestSliderWidget> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    const sliderWidget = Slider(value: 0.5, onChanged: null);
    final skeleton =
        widget.provider.createSkeleton(sliderWidget, widget.baseColor);

    return Scaffold(
      body: Column(
        children: [
          skeleton,
          ElevatedButton(
            onPressed: () {
              setState(() {
                _sliderValue = _sliderValue == 0.5 ? 0.8 : 0.5;
              });
            },
            child: const Text('Cambiar Estado'),
          ),
        ],
      ),
    );
  }
}
