import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/text_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/text_skeleton.dart';

void main() {
  group('TextSkeletonProvider', () {
    late TextSkeletonProvider provider;
    late Color baseColor;

    setUp(() {
      provider = TextSkeletonProvider();
      baseColor = const Color(0xFF9E9E9E);
    });

    group('canHandle', () {
      test('Debería aceptar widgets Text', () {
        const text = Text('Hola Mundo');
        expect(provider.canHandle(text), isTrue);
      });

      test('Debería aceptar Text con diferentes configuraciones', () {
        const texts = [
          Text('Texto simple'),
          Text(''),
          Text('Texto', style: TextStyle(fontSize: 16)),
          Text('Texto', textAlign: TextAlign.center),
          Text('Texto', overflow: TextOverflow.ellipsis),
          Text('Texto', maxLines: 2),
        ];

        for (final text in texts) {
          expect(provider.canHandle(text), isTrue);
        }
      });

      test('Debería rechazar widgets que no son Text', () {
        final widgets = [
          Container(),
          const Icon(Icons.star),
          const ElevatedButton(onPressed: null, child: Text('Button')),
          const TextField(),
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
      test('Debería tener prioridad 10', () {
        expect(provider.priority, 10);
      });
    });

    group('createSkeleton', () {
      group('Text con contenido', () {
        testWidgets('Debería crear TextSkeleton con texto simple',
            (tester) async {
          const textWidget = Text('Hola Mundo');

          final skeleton = provider.createSkeleton(textWidget, baseColor);

          expect(skeleton, isA<TextSkeleton>());

          final textSkeleton = skeleton as TextSkeleton;
          expect(textSkeleton.baseColor, baseColor);
          expect(textSkeleton.text, 'Hola Mundo');

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(TextSkeleton), findsOneWidget);
          expect(find.text('Hola Mundo'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería preservar texto largo', (tester) async {
          const longText =
              'Este es un texto muy largo que debería ser preservado completamente en el skeleton';
          const textWidget = Text(longText);

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, longText);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.text(longText), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería manejar texto con caracteres especiales',
            (tester) async {
          const specialText =
              'Héllø Wørld! 123 @#\$%^&*()_+-={}[]|\\:";\'<>?,./`~';
          const textWidget = Text(specialText);

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, specialText);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.text(specialText), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería manejar texto con saltos de línea',
            (tester) async {
          const multilineText = 'Primera línea\nSegunda línea\nTercera línea';
          const textWidget = Text(multilineText);

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, multilineText);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.text(multilineText), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      });

      group('Text vacío', () {
        testWidgets('Debería crear TextSkeleton sin texto para Text vacío',
            (tester) async {
          const textWidget = Text('');

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, isNull);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(TextSkeleton), findsOneWidget);
          expect(find.byType(Text), findsNothing);
          expect(tester.takeException(), isNull);
        });

        testWidgets(
            'Debería crear TextSkeleton sin texto para Text con data null',
            (tester) async {
          const textWidget = Text.rich(TextSpan(text: null));

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, isNull);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          expect(find.byType(TextSkeleton), findsOneWidget);
          expect(find.byType(Text), findsNothing);
          expect(tester.takeException(), isNull);
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
            const textWidget = Text('Test');
            final skeleton = provider.createSkeleton(textWidget, color);
            final textSkeleton = skeleton as TextSkeleton;

            expect(textSkeleton.baseColor, color);

            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(body: skeleton),
              ),
            );

            expect(find.byType(TextSkeleton), findsOneWidget);
            expect(tester.takeException(), isNull);

            await tester.pumpWidget(Container());
          }
        });
      });

      group('ignorar propiedades de Text', () {
        testWidgets('Debería ignorar propiedades de estilo del Text original',
            (tester) async {
          const textWidget = Text(
            'Texto con estilo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              decoration: TextDecoration.underline,
            ),
          );

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, 'Texto con estilo');
          expect(textSkeleton.baseColor, baseColor);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final textInSkeleton =
              tester.widget<Text>(find.text('Texto con estilo'));
          expect(textInSkeleton.style?.color, baseColor);
          expect(tester.takeException(), isNull);
        });

        testWidgets('Debería ignorar propiedades de alineación',
            (tester) async {
          const textWidget = Text(
            'Texto centrado',
            textAlign: TextAlign.center,
          );

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, 'Texto centrado');
        });

        testWidgets('Debería ignorar maxLines', (tester) async {
          const textWidget = Text(
            'Texto con maxLines',
            maxLines: 3,
          );

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, 'Texto con maxLines');
        });

        testWidgets('Debería ignorar overflow', (tester) async {
          const textWidget = Text(
            'Texto con overflow',
            overflow: TextOverflow.ellipsis,
          );

          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, 'Texto con overflow');
        });
      });
    });

    group('herencia de BaseSkeletonProvider', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<TextSkeletonProvider>());
      });

      test('Debería implementar todos los métodos requeridos', () {
        const textWidget = Text('Test');

        expect(() => provider.canHandle(textWidget), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(textWidget, baseColor),
            returnsNormally);
      });
    });

    group('casos extremos', () {
      testWidgets('Debería manejar texto muy largo', (tester) async {
        final veryLongText = 'A' * 1000; // 1000 caracteres
        final textWidget = Text(veryLongText);

        final skeleton = provider.createSkeleton(textWidget, baseColor);
        final textSkeleton = skeleton as TextSkeleton;

        expect(textSkeleton.text, veryLongText);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text(veryLongText), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar texto de un solo carácter', (tester) async {
        const textWidget = Text('A');

        final skeleton = provider.createSkeleton(textWidget, baseColor);
        final textSkeleton = skeleton as TextSkeleton;

        expect(textSkeleton.text, 'A');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('A'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar múltiples Text con diferentes contenidos',
          (tester) async {
        final texts = [
          const Text('Texto corto'),
          const Text('Texto mucho más largo para probar'),
          const Text(''),
          const Text('123'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: texts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final text = entry.value;
                  final color = Color(0xFF000000 + (index * 0x333333));
                  return provider.createSkeleton(text, color);
                }).toList(),
              ),
            ),
          ),
        );

        final textSkeletons =
            tester.widgetList<TextSkeleton>(find.byType(TextSkeleton)).toList();
        expect(textSkeletons, hasLength(4));

        expect(textSkeletons[0].text, 'Texto corto');
        expect(textSkeletons[1].text, 'Texto mucho más largo para probar');
        expect(textSkeletons[2].text, isNull);
        expect(textSkeletons[3].text, '123');

        expect(find.text('Texto corto'), findsOneWidget);
        expect(find.text('Texto mucho más largo para probar'), findsOneWidget);
        expect(find.text('123'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar Text anidados en layouts complejos',
          (tester) async {
        const textWidget = Text('Texto en layout complejo');

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
                            child:
                                provider.createSkeleton(textWidget, baseColor),
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

        expect(find.byType(TextSkeleton), findsOneWidget);
        expect(find.text('Texto en layout complejo'), findsOneWidget);

        final textSkeleton =
            tester.widget<TextSkeleton>(find.byType(TextSkeleton));
        expect(textSkeleton.text, 'Texto en layout complejo');
        expect(textSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería mantener consistencia con diferentes instancias de provider',
          (tester) async {
        final provider1 = TextSkeletonProvider();
        final provider2 = TextSkeletonProvider();

        const textWidget = Text('Texto de prueba');
        const testColor = Color(0xFF123456);

        final skeleton1 = provider1.createSkeleton(textWidget, testColor);
        final skeleton2 = provider2.createSkeleton(textWidget, testColor);

        expect(skeleton1.runtimeType, skeleton2.runtimeType);

        final textSkeleton1 = skeleton1 as TextSkeleton;
        final textSkeleton2 = skeleton2 as TextSkeleton;

        expect(textSkeleton1.text, textSkeleton2.text);
        expect(textSkeleton1.baseColor, textSkeleton2.baseColor);
      });
    });

    group('integración con Flutter framework', () {
      testWidgets('Debería funcionar correctamente en StatefulWidget',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestTextWidget(provider: provider, baseColor: baseColor),
          ),
        );

        expect(find.byType(TextSkeleton), findsOneWidget);
        expect(find.text('Texto inicial'), findsOneWidget);

        final textSkeleton =
            tester.widget<TextSkeleton>(find.byType(TextSkeleton));
        expect(textSkeleton.text, 'Texto inicial');
        expect(textSkeleton.baseColor, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar cambios de estado correctamente',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: _TestTextWidget(provider: provider, baseColor: baseColor),
          ),
        );

        expect(find.text('Texto inicial'), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.byType(TextSkeleton), findsOneWidget);
        expect(find.text('Texto cambiado'), findsOneWidget);
        expect(find.text('Texto inicial'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería renderizar skeleton en lugar del widget original',
          (tester) async {
        const textWidget = Text('Texto original');
        final skeleton = provider.createSkeleton(textWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(TextSkeleton), findsOneWidget);
        expect(find.text('Texto original'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('extracción de datos', () {
      group('data vs rich text', () {
        test('Debería extraer data de Text simple', () {
          const textWidget = Text('Texto simple');
          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, 'Texto simple');
        });

        test('Debería manejar Text.rich sin data', () {
          const textWidget = Text.rich(TextSpan(text: 'Texto rich'));
          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, isNull);
        });
      });

      group('lógica de texto vacío', () {
        test('Debería convertir string vacío a null', () {
          const textWidget = Text('');
          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, isNull);
        });

        test('Debería preservar string con espacios', () {
          const textWidget = Text('   ');
          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, '   ');
        });

        test('Debería preservar string con salto de línea', () {
          const textWidget = Text('\n');
          final skeleton = provider.createSkeleton(textWidget, baseColor);
          final textSkeleton = skeleton as TextSkeleton;

          expect(textSkeleton.text, '\n');
        });
      });
    });

    group('comportamiento de TextSkeleton', () {
      testWidgets(
          'Debería verificar que TextSkeleton renderiza texto cuando se proporciona',
          (tester) async {
        const textWidget = Text('Texto visible');
        final skeleton = provider.createSkeleton(textWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('Texto visible'), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);

        final textWidgetInSkeleton =
            tester.widget<Text>(find.text('Texto visible'));
        expect(textWidgetInSkeleton.style?.color, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería verificar que TextSkeleton renderiza container cuando no hay texto',
          (tester) async {
        const textWidget = Text('');
        final skeleton = provider.createSkeleton(textWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(Text), findsNothing);
        expect(find.byType(Container), findsOneWidget);

        final containerSize = tester.getSize(find.byType(Container));
        expect(containerSize.height, 20);
        expect(tester.takeException(), isNull);
      });
    });
  });
}

class _TestTextWidget extends StatefulWidget {
  final TextSkeletonProvider provider;
  final Color baseColor;

  const _TestTextWidget({
    required this.provider,
    required this.baseColor,
  });

  @override
  State<_TestTextWidget> createState() => _TestTextWidgetState();
}

class _TestTextWidgetState extends State<_TestTextWidget> {
  String _currentText = 'Texto inicial';

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(_currentText);
    final skeleton =
        widget.provider.createSkeleton(textWidget, widget.baseColor);

    return Scaffold(
      body: Column(
        children: [
          skeleton,
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentText = _currentText == 'Texto inicial'
                    ? 'Texto cambiado'
                    : 'Texto inicial';
              });
            },
            child: const Text('Cambiar Texto'),
          ),
        ],
      ),
    );
  }
}
