import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/text_field_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_field_skeleton.dart';

void main() {
  group('TextFieldSkeletonProvider', () {
    late TextFieldSkeletonProvider provider;
    late Color baseColor;

    setUp(() {
      provider = TextFieldSkeletonProvider();
      baseColor = const Color(0xFF9E9E9E);
    });

    group('canHandle', () {
      test('Debería aceptar widgets TextField', () {
        const textField = TextField();
        expect(provider.canHandle(textField), isTrue);
      });

      test('Debería aceptar widgets TextFormField', () {
        final textFormField = TextFormField();
        expect(provider.canHandle(textFormField), isTrue);
      });

      test('Debería aceptar TextField con diferentes configuraciones', () {
        final textFields = [
          const TextField(),
          const TextField(maxLines: 1),
          const TextField(maxLines: 3),
          const TextField(decoration: InputDecoration(labelText: 'Label')),
          TextField(decoration: InputDecoration.collapsed(hintText: null)),
        ];

        for (final textField in textFields) {
          expect(provider.canHandle(textField), isTrue);
        }
      });

      test('Debería aceptar TextFormField con diferentes configuraciones', () {
        final textFormFields = [
          TextFormField(),
          TextFormField(validator: (value) => null),
          TextFormField(decoration: const InputDecoration(labelText: 'Label')),
        ];

        for (final textFormField in textFormFields) {
          expect(provider.canHandle(textFormField), isTrue);
        }
      });

      test('Debería rechazar widgets que no son TextField ni TextFormField',
          () {
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
      test('Debería tener prioridad 9', () {
        expect(provider.priority, 9);
      });
    });

    group('createSkeleton', () {
      group('TextField', () {
        testWidgets('Debería crear TextFieldSkeleton básico para TextField',
            (tester) async {
          const textField = TextField();

          final skeleton = provider.createSkeleton(textField, baseColor);

          expect(skeleton, isA<TextFieldSkeleton>());

          final textFieldSkeleton = skeleton as TextFieldSkeleton;
          expect(textFieldSkeleton.baseColor, baseColor);
          expect(textFieldSkeleton.width, 250.0);
          expect(textFieldSkeleton.height, 56.0);
          expect(textFieldSkeleton.isMultiline, isFalse);
          expect(textFieldSkeleton.hasDecoration, isTrue);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(TextFieldSkeleton), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería detectar TextField multiline correctamente',
            (tester) async {
          const textField = TextField(maxLines: 3);

          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 300.0);
          expect(textFieldSkeleton.height, 120.0);
          expect(textFieldSkeleton.isMultiline, isTrue);
          expect(textFieldSkeleton.hasDecoration, isTrue);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(TextFieldSkeleton), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets(
            'Debería detectar TextField con maxLines null como single line',
            (tester) async {
          const textField = TextField(maxLines: null);

          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 250.0);
          expect(textFieldSkeleton.height, 56.0);
          expect(textFieldSkeleton.isMultiline, isFalse);
          expect(textFieldSkeleton.hasDecoration, isTrue);
        });

        testWidgets('Debería detectar TextField con decoration collapsed',
            (tester) async {
          final textField =
              TextField(decoration: InputDecoration.collapsed(hintText: null));

          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 250.0);
          expect(textFieldSkeleton.height, 56.0);
          expect(textFieldSkeleton.isMultiline, isFalse);
          expect(textFieldSkeleton.hasDecoration, isFalse);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(TextFieldSkeleton), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería manejar TextField con decoration normal',
            (tester) async {
          const textField =
              TextField(decoration: InputDecoration(labelText: 'Label'));

          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.hasDecoration, isTrue);
        });

        testWidgets(
            'Debería manejar TextField multiline con decoration collapsed',
            (tester) async {
          final textField = TextField(
            maxLines: 4,
            decoration: InputDecoration.collapsed(hintText: null),
          );

          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 300.0);
          expect(textFieldSkeleton.height, 120.0);
          expect(textFieldSkeleton.isMultiline, isTrue);
          expect(textFieldSkeleton.hasDecoration, isFalse);
        });
      });

      group('TextFormField', () {
        testWidgets('Debería crear TextFieldSkeleton básico para TextFormField',
            (tester) async {
          final textFormField = TextFormField();

          final skeleton = provider.createSkeleton(textFormField, baseColor);

          expect(skeleton, isA<TextFieldSkeleton>());

          final textFieldSkeleton = skeleton as TextFieldSkeleton;
          expect(textFieldSkeleton.baseColor, baseColor);
          expect(textFieldSkeleton.width, 250.0);
          expect(textFieldSkeleton.height, 56.0);
          expect(textFieldSkeleton.isMultiline, isFalse);
          expect(textFieldSkeleton.hasDecoration, isTrue);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(TextFieldSkeleton), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería tratar TextFormField siempre como single line',
            (tester) async {
          final textFormField = TextFormField();

          final skeleton = provider.createSkeleton(textFormField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 250.0);
          expect(textFieldSkeleton.height, 56.0);
          expect(textFieldSkeleton.isMultiline, isFalse);
          expect(textFieldSkeleton.hasDecoration, isTrue);
        });

        testWidgets('Debería tratar TextFormField siempre con decoration',
            (tester) async {
          final textFormField = TextFormField();

          final skeleton = provider.createSkeleton(textFormField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.hasDecoration, isTrue);
        });
      });

      group('dimensiones y sanitización', () {
        testWidgets('Debería aplicar sanitización a dimensiones',
            (tester) async {
          const textField = TextField();
          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 250.0);
          expect(textFieldSkeleton.height, 56.0);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final textFieldSkeletonWidget =
              tester.widget<TextFieldSkeleton>(find.byType(TextFieldSkeleton));
          expect(textFieldSkeletonWidget.width, 250.0);
          expect(textFieldSkeletonWidget.height, 56.0);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería usar dimensiones correctas para multiline',
            (tester) async {
          const textField = TextField(maxLines: 5);
          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 300.0);
          expect(textFieldSkeleton.height, 120.0);
        });

        test('Debería usar defaults correctos en sanitización', () {
          const textField = TextField();
          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.width, 250.0);
          expect(textFieldSkeleton.height, 56.0);
        });
      });

      group('preservación de color', () {
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
            const textField = TextField();
            final skeleton = provider.createSkeleton(textField, color);
            final textFieldSkeleton = skeleton as TextFieldSkeleton;

            expect(textFieldSkeleton.baseColor, color);

            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: skeleton),
              ),
            );

            expect(find.byType(TextFieldSkeleton), findsOneWidget);
            expect(tester.takeException(), isNull);

            await tester.pumpWidget(Container());
          }
        });
      });
    });

    group('herencia de BaseSkeletonProvider', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<TextFieldSkeletonProvider>());
      });

      test('Debería implementar todos los métodos requeridos', () {
        const textField = TextField();

        expect(() => provider.canHandle(textField), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(textField, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar TextField con maxLines extremos',
          (tester) async {
        const testCases = [
          {'maxLines': 1, 'expectedMultiline': false},
          {'maxLines': 2, 'expectedMultiline': true},
          {'maxLines': 10, 'expectedMultiline': true},
          {'maxLines': 100, 'expectedMultiline': true},
        ];

        for (final testCase in testCases) {
          final textField = TextField(maxLines: testCase['maxLines'] as int);
          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;

          expect(textFieldSkeleton.isMultiline, testCase['expectedMultiline']);

          if (testCase['expectedMultiline'] as bool) {
            expect(textFieldSkeleton.width, 300.0);
            expect(textFieldSkeleton.height, 120.0);
          } else {
            expect(textFieldSkeleton.width, 250.0);
            expect(textFieldSkeleton.height, 56.0);
          }
        }
      });

      testWidgets(
          'Debería manejar múltiples TextField con diferentes configuraciones',
          (tester) async {
        final textFields = [
          const TextField(),
          const TextField(maxLines: 3),
          TextField(decoration: InputDecoration.collapsed(hintText: null)),
          TextFormField(),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: textFields.asMap().entries.map((entry) {
                  final index = entry.key;
                  final textField = entry.value;
                  final color = Color(0xFF000000 + (index * 0x222222));
                  return provider.createSkeleton(textField, color);
                }).toList(),
              ),
            ),
          ),
        );

        final textFieldSkeletons = tester
            .widgetList<TextFieldSkeleton>(find.byType(TextFieldSkeleton))
            .toList();
        expect(textFieldSkeletons, hasLength(4));

        expect(textFieldSkeletons[0].isMultiline, isFalse);
        expect(textFieldSkeletons[0].hasDecoration, isTrue);

        expect(textFieldSkeletons[1].isMultiline, isTrue);
        expect(textFieldSkeletons[1].hasDecoration, isTrue);

        expect(textFieldSkeletons[2].isMultiline, isFalse);
        expect(textFieldSkeletons[2].hasDecoration, isFalse);

        expect(textFieldSkeletons[3].isMultiline, isFalse);
        expect(textFieldSkeletons[3].hasDecoration, isTrue);

        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar TextField anidados en layouts complejos',
          (tester) async {
        const textField = TextField();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: provider.createSkeleton(textField, baseColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(TextFieldSkeleton), findsOneWidget);

        final textFieldSkeleton =
            tester.widget<TextFieldSkeleton>(find.byType(TextFieldSkeleton));
        expect(textFieldSkeleton.width, 250.0);
        expect(textFieldSkeleton.height, 56.0);
        expect(textFieldSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería mantener consistencia con diferentes instancias de provider',
          (tester) async {
        final provider1 = TextFieldSkeletonProvider();
        final provider2 = TextFieldSkeletonProvider();

        const textField = TextField();
        const testColor = Color(0xFF123456);

        final skeleton1 = provider1.createSkeleton(textField, testColor);
        final skeleton2 = provider2.createSkeleton(textField, testColor);

        expect(skeleton1.runtimeType, skeleton2.runtimeType);

        final textFieldSkeleton1 = skeleton1 as TextFieldSkeleton;
        final textFieldSkeleton2 = skeleton2 as TextFieldSkeleton;

        expect(textFieldSkeleton1.width, textFieldSkeleton2.width);
        expect(textFieldSkeleton1.height, textFieldSkeleton2.height);
        expect(textFieldSkeleton1.isMultiline, textFieldSkeleton2.isMultiline);
        expect(
            textFieldSkeleton1.hasDecoration, textFieldSkeleton2.hasDecoration);
        expect(textFieldSkeleton1.baseColor, textFieldSkeleton2.baseColor);
      });
    });

    group('integración con Flutter framework', () {
      testWidgets('Debería funcionar correctamente en StatefulWidget',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home:
                _TestTextFieldWidget(provider: provider, baseColor: baseColor),
          ),
        );

        expect(find.byType(TextFieldSkeleton), findsOneWidget);

        final textFieldSkeleton =
            tester.widget<TextFieldSkeleton>(find.byType(TextFieldSkeleton));
        expect(textFieldSkeleton.width, 250.0);
        expect(textFieldSkeleton.height, 56.0);
        expect(textFieldSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar cambios de estado correctamente',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home:
                _TestTextFieldWidget(provider: provider, baseColor: baseColor),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.byType(TextFieldSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería renderizar skeleton en lugar del widget original',
          (tester) async {
        const textField = TextField();
        final skeleton = provider.createSkeleton(textField, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(TextFieldSkeleton), findsOneWidget);
        expect(find.byType(TextField), findsNothing);
        expect(tester.takeException(), isNull);
      });
    });

    group('análisis de propiedades específicas', () {
      group('detección de isMultiline', () {
        test('Debería detectar correctamente single line', () {
          const testCases = [
            TextField(),
            TextField(maxLines: 1),
            TextField(maxLines: null),
          ];

          for (final textField in testCases) {
            final skeleton = provider.createSkeleton(textField, baseColor);
            final textFieldSkeleton = skeleton as TextFieldSkeleton;
            expect(textFieldSkeleton.isMultiline, isFalse);
          }
        });

        test('Debería detectar correctamente multiline', () {
          const testCases = [
            TextField(maxLines: 2),
            TextField(maxLines: 3),
            TextField(maxLines: 10),
          ];

          for (final textField in testCases) {
            final skeleton = provider.createSkeleton(textField, baseColor);
            final textFieldSkeleton = skeleton as TextFieldSkeleton;
            expect(textFieldSkeleton.isMultiline, isTrue);
          }
        });

        test('Debería tratar TextFormField siempre como single line', () {
          final textFormField = TextFormField();
          final skeleton = provider.createSkeleton(textFormField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;
          expect(textFieldSkeleton.isMultiline, isFalse);
        });
      });

      group('detección de hasDecoration', () {
        test('Debería detectar decoration normal en TextField', () {
          const textFields = [
            TextField(),
            TextField(decoration: InputDecoration(labelText: 'Label')),
            TextField(decoration: InputDecoration(hintText: 'Hint')),
          ];

          for (final textField in textFields) {
            final skeleton = provider.createSkeleton(textField, baseColor);
            final textFieldSkeleton = skeleton as TextFieldSkeleton;
            expect(textFieldSkeleton.hasDecoration, isTrue);
          }
        });

        test('Debería detectar decoration collapsed en TextField', () {
          final textField =
              TextField(decoration: InputDecoration.collapsed(hintText: null));
          final skeleton = provider.createSkeleton(textField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;
          expect(textFieldSkeleton.hasDecoration, isFalse);
        });

        test('Debería tratar TextFormField siempre con decoration', () {
          final textFormField = TextFormField();
          final skeleton = provider.createSkeleton(textFormField, baseColor);
          final textFieldSkeleton = skeleton as TextFieldSkeleton;
          expect(textFieldSkeleton.hasDecoration, isTrue);
        });
      });
    });
  });
}

class _TestTextFieldWidget extends StatefulWidget {
  final TextFieldSkeletonProvider provider;
  final Color baseColor;

  const _TestTextFieldWidget({
    required this.provider,
    required this.baseColor,
  });

  @override
  State<_TestTextFieldWidget> createState() => _TestTextFieldWidgetState();
}

class _TestTextFieldWidgetState extends State<_TestTextFieldWidget> {
  bool _isMultiline = false;

  @override
  Widget build(BuildContext context) {
    final textField = TextField(maxLines: _isMultiline ? 3 : 1);
    final skeleton =
        widget.provider.createSkeleton(textField, widget.baseColor);

    return Scaffold(
      body: Column(
        children: [
          skeleton,
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isMultiline = !_isMultiline;
              });
            },
            child: const Text('Cambiar Tipo'),
          ),
        ],
      ),
    );
  }
}
