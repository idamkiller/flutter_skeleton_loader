import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/utils/widget_validator.dart';

void main() {
  group('WidgetValidator', () {
    group('isValidForSkeleton', () {
      test('Debe devolver verdadero para widgets básicos válidos', () {
        final validWidgets = [
          const Text('Test'),
          const Icon(Icons.star),
          Container(
            width: 100,
            height: 50,
            color: Colors.blue,
          ),
          const SizedBox(width: 100, height: 50),
        ];

        for (final widget in validWidgets) {
          expect(
            WidgetValidator.isValidForSkeleton(widget),
            isTrue,
          );
        }
      });

      test('Debe devolver falso para Container con restricciones problemáticas',
          () {
        final invalidContainer = Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            maxWidth: double.infinity,
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
        );

        expect(WidgetValidator.isValidForSkeleton(invalidContainer), isFalse);
      });

      test(
          'Debe devolver falso para Container con restricciones de altura infinitas',
          () {
        final invalidContainer = Container(
          constraints: const BoxConstraints(
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
        );

        expect(WidgetValidator.isValidForSkeleton(invalidContainer), isFalse);
      });

      test(
          'Debe devolver falso para Container con restricciones de ancho infinitas',
          () {
        final invalidContainer = Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            maxWidth: double.infinity,
          ),
        );

        expect(WidgetValidator.isValidForSkeleton(invalidContainer), isFalse);
      });

      test('Debe devolver verdadero para Container con restricciones finitas',
          () {
        final validContainer = Container(
          constraints: const BoxConstraints(
            minWidth: 0,
            maxWidth: 200,
            minHeight: 0,
            maxHeight: 100,
          ),
        );

        expect(WidgetValidator.isValidForSkeleton(validContainer), isTrue);
      });

      test('Debe devolver falso para SizedBox con dimensiones infinitas', () {
        final invalidSizedBoxes = [
          const SizedBox(width: double.infinity, height: 50),
          const SizedBox(width: 50, height: double.infinity),
          const SizedBox(width: double.infinity, height: double.infinity),
        ];

        for (final widget in invalidSizedBoxes) {
          expect(
            WidgetValidator.isValidForSkeleton(widget),
            isFalse,
          );
        }
      });

      test('Debe devolver verdadero para SizedBox con dimensiones finitas', () {
        final validSizedBoxes = [
          const SizedBox(width: 100, height: 50),
          const SizedBox(width: 100),
          const SizedBox(height: 50),
          const SizedBox(),
        ];

        for (final widget in validSizedBoxes) {
          expect(
            WidgetValidator.isValidForSkeleton(widget),
            isTrue,
          );
        }
      });

      test('Debe devolver falso para widgets Expanded', () {
        final expandedWidget = Expanded(
          child: Container(height: 50),
        );

        expect(WidgetValidator.isValidForSkeleton(expandedWidget), isFalse);
      });

      test('Debe devolver falso para widgets Flexible', () {
        final flexibleWidget = Flexible(
          child: Container(height: 50),
        );

        expect(WidgetValidator.isValidForSkeleton(flexibleWidget), isFalse);
      });

      test('Debe manejar el proceso de validación sin errores', () {
        final validWidget = SizedBox(
          width: 100,
          height: 50,
          child: const Text('Test'),
        );

        expect(
          () => WidgetValidator.isValidForSkeleton(validWidget),
          returnsNormally,
        );
        expect(WidgetValidator.isValidForSkeleton(validWidget), isTrue);
      });
    });

    group('sanitizeWidget', () {
      test('Debe sanitizar Container con restricciones problemáticas', () {
        final problematicContainer = Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            maxWidth: double.infinity,
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
        );

        final sanitized = WidgetValidator.sanitizeWidget(problematicContainer);

        expect(sanitized, isA<Container>());
        final sanitizedContainer = sanitized as Container;
        expect(sanitizedContainer.constraints!.minWidth, equals(0));
        expect(
            sanitizedContainer.constraints!.maxWidth, equals(double.infinity));
        expect(sanitizedContainer.constraints!.minHeight, equals(0));
        expect(sanitizedContainer.constraints!.maxHeight, equals(200));
        expect(sanitizedContainer.margin, equals(const EdgeInsets.all(8)));
        expect(sanitizedContainer.padding, equals(const EdgeInsets.all(16)));
      });

      test('Debe sanitizar SizedBox con ancho infinito', () {
        const problematicSizedBox = SizedBox(
          width: double.infinity,
          height: 50,
          child: Text('Test'),
        );

        final sanitized = WidgetValidator.sanitizeWidget(problematicSizedBox);

        expect(sanitized, isA<SizedBox>());
        final sanitizedSizedBox = sanitized as SizedBox;
        expect(sanitizedSizedBox.width, isNull);
        expect(sanitizedSizedBox.height, equals(50));
        expect(sanitizedSizedBox.child, isA<Text>());
      });

      test('Debe sanitizar SizedBox con altura infinita', () {
        const problematicSizedBox = SizedBox(
          width: 100,
          height: double.infinity,
          child: Text('Test'),
        );

        final sanitized = WidgetValidator.sanitizeWidget(problematicSizedBox);

        expect(sanitized, isA<SizedBox>());
        final sanitizedSizedBox = sanitized as SizedBox;
        expect(sanitizedSizedBox.width, equals(100));
        expect(sanitizedSizedBox.height, equals(100));
        expect(sanitizedSizedBox.child, isA<Text>());
      });

      test('Debe convertir Expanded a SizedBox', () {
        final expandedWidget = Expanded(
          flex: 2,
          child: Container(color: Colors.red),
        );

        final sanitized = WidgetValidator.sanitizeWidget(expandedWidget);

        expect(sanitized, isA<SizedBox>());
        final sanitizedSizedBox = sanitized as SizedBox;
        expect(sanitizedSizedBox.height, equals(50));
        expect(sanitizedSizedBox.child, isA<Container>());
      });

      test('Debe convertir Flexible a SizedBox', () {
        final flexibleWidget = Flexible(
          flex: 1,
          child: Container(color: Colors.blue),
        );

        final sanitized = WidgetValidator.sanitizeWidget(flexibleWidget);

        expect(sanitized, isA<SizedBox>());
        final sanitizedSizedBox = sanitized as SizedBox;
        expect(sanitizedSizedBox.height, equals(50));
        expect(sanitizedSizedBox.child, isA<Container>());
      });

      test('Debe sanitizar recursivamente los widgets hijos', () {
        final containerWithProblematicChild = Container(
          color: Colors.green,
          child: const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Text('Nested'),
          ),
        );

        final sanitized =
            WidgetValidator.sanitizeWidget(containerWithProblematicChild);

        expect(sanitized, isA<Container>());
        final sanitizedContainer = sanitized as Container;
        expect(sanitizedContainer.child, isA<SizedBox>());

        final childSizedBox = sanitizedContainer.child as SizedBox;
        expect(childSizedBox.width, isNull);
        expect(childSizedBox.height, equals(100));
      });

      test('Debe devolver el widget original si no se necesita sanitización',
          () {
        const validWidget = Text('Valid widget');

        final sanitized = WidgetValidator.sanitizeWidget(validWidget);

        expect(sanitized, equals(validWidget));
      });

      test('Debe manejar el proceso de sanitización sin errores', () {
        final validWidget = Container(
          color: Colors.green,
          width: 100,
          height: 50,
          child: const Text('Test'),
        );

        final sanitized = WidgetValidator.sanitizeWidget(validWidget);

        expect(sanitized, isNotNull);
        expect(sanitized, isA<Container>());
      });

      test('Debe preservar la decoración del Container durante la sanitización',
          () {
        final containerWithDecoration = Container(
          constraints: const BoxConstraints(
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Test'),
        );

        final sanitized =
            WidgetValidator.sanitizeWidget(containerWithDecoration);

        expect(sanitized, isA<Container>());
        final sanitizedContainer = sanitized as Container;
        expect(sanitizedContainer.decoration, isA<BoxDecoration>());
        final decoration = sanitizedContainer.decoration as BoxDecoration;
        expect(decoration.color, equals(Colors.red));
        expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
      });
    });

    group('isInFlexContext', () {
      test('Debe devolver verdadero para widgets Expanded', () {
        final expandedWidget = Expanded(
          child: Container(),
        );

        expect(WidgetValidator.isInFlexContext(expandedWidget), isTrue);
      });

      test('Debe devolver verdadero para widgets Flexible', () {
        final flexibleWidget = Flexible(
          child: Container(),
        );

        expect(WidgetValidator.isInFlexContext(flexibleWidget), isTrue);
      });

      test('Debe devolver falso para widgets que no son Flex', () {
        final regularWidgets = [
          const Text('Test'),
          Container(),
          const SizedBox(),
          const Icon(Icons.star),
        ];

        for (final widget in regularWidgets) {
          expect(
            WidgetValidator.isInFlexContext(widget),
            isFalse,
          );
        }
      });
    });

    group('getDiagnosticInfo', () {
      test('Debe proporcionar información de diagnóstico para Container', () {
        final container = Container(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 100),
          decoration: const BoxDecoration(color: Colors.blue),
        );

        final diagnosticInfo = WidgetValidator.getDiagnosticInfo(container);

        expect(diagnosticInfo, contains('Widget Type: Container'));
        expect(diagnosticInfo, contains('Container constraints:'));
        expect(diagnosticInfo, contains('Container decoration:'));
        expect(diagnosticInfo, contains('Is valid for skeleton:'));
      });

      test('Debe proporcionar información de diagnóstico para SizedBox', () {
        const sizedBox = SizedBox(width: 100, height: 50);

        final diagnosticInfo = WidgetValidator.getDiagnosticInfo(sizedBox);

        expect(diagnosticInfo, contains('Widget Type: SizedBox'));
        expect(diagnosticInfo, contains('SizedBox width: 100.0'));
        expect(diagnosticInfo, contains('SizedBox height: 50.0'));
        expect(diagnosticInfo, contains('Is valid for skeleton:'));
      });

      test('Debe proporcionar información de diagnóstico para otros widgets',
          () {
        const textWidget = Text('Test');

        final diagnosticInfo = WidgetValidator.getDiagnosticInfo(textWidget);

        expect(diagnosticInfo, contains('Widget Type: Text'));
        expect(diagnosticInfo, contains('Is valid for skeleton:'));
      });

      test(
          'Debe incluir el resultado de validación en la información de diagnóstico',
          () {
        final expandedWidget = Expanded(
          child: Container(),
        );

        final diagnosticInfo =
            WidgetValidator.getDiagnosticInfo(expandedWidget);

        expect(diagnosticInfo, contains('Is valid for skeleton: false'));
      });
    });

    group('casos límite y manejo de errores', () {
      test('Debe manejar restricciones nulas en Container', () {
        final container = Container(
          constraints: null,
          child: const Text('Test'),
        );

        expect(WidgetValidator.isValidForSkeleton(container), isTrue);

        final sanitized = WidgetValidator.sanitizeWidget(container);
        expect(sanitized, isA<Container>());
      });

      test('Debe manejar Container sin hijo', () {
        final container = Container(
          color: Colors.green,
          width: 100,
          height: 50,
        );

        expect(WidgetValidator.isValidForSkeleton(container), isTrue);

        final sanitized = WidgetValidator.sanitizeWidget(container);
        expect(sanitized, isA<Container>());
        expect((sanitized as Container).child, isNull);
      });

      test('Debe manejar SizedBox sin hijo', () {
        const sizedBox = SizedBox(width: 100, height: 50);

        expect(WidgetValidator.isValidForSkeleton(sizedBox), isTrue);

        final sanitized = WidgetValidator.sanitizeWidget(sizedBox);
        expect(sanitized, isA<SizedBox>());
        expect((sanitized as SizedBox).child, isNull);
      });

      test('Debe manejar una jerarquía compleja de widgets anidados', () {
        final complexWidget = Container(
          constraints: const BoxConstraints(
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
          child: Column(
            children: [
              Expanded(
                child: const SizedBox(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Text('Deep nesting'),
                  ),
                ),
              ),
            ],
          ),
        );

        expect(WidgetValidator.isValidForSkeleton(complexWidget), isFalse);

        final sanitized = WidgetValidator.sanitizeWidget(complexWidget);
        expect(sanitized, isA<Container>());
      });

      test(
          'Debe manejar restricciones mixtas válidas e inválidas en el contenedor.',
          () {
        final mixedContainer = Container(
          constraints: const BoxConstraints(
            minWidth: 0,
            maxWidth: 200,
            minHeight: double.infinity,
            maxHeight: double.infinity,
          ),
        );

        expect(WidgetValidator.isValidForSkeleton(mixedContainer), isFalse);

        final sanitized = WidgetValidator.sanitizeWidget(mixedContainer);
        expect(sanitized, isA<Container>());
        final sanitizedContainer = sanitized as Container;
        expect(sanitizedContainer.constraints!.maxHeight, equals(200));
      });

      test('Debe validar correctamente SizedBox con dimensiones nulas', () {
        const sizedBoxWithNulls = SizedBox(
          width: null,
          height: null,
          child: Text('Test'),
        );

        expect(WidgetValidator.isValidForSkeleton(sizedBoxWithNulls), isTrue);
      });

      test('Debe sanitizar Container con hijo que necesita sanitización', () {
        final containerWithBadChild = Container(
          padding: const EdgeInsets.all(8),
          child: Expanded(
            child: const Text('Expanded inside Container'),
          ),
        );

        final sanitized = WidgetValidator.sanitizeWidget(containerWithBadChild);

        expect(sanitized, isA<Container>());
        final sanitizedContainer = sanitized as Container;
        expect(sanitizedContainer.child, isA<SizedBox>());
        expect(sanitizedContainer.padding, equals(const EdgeInsets.all(8)));
      });

      test('Debe manejar Expanded con hijo complejo', () {
        final expandedWithComplexChild = Expanded(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
              maxWidth: double.infinity,
            ),
            child: const SizedBox(
              width: double.infinity,
              height: 50,
            ),
          ),
        );

        final sanitized =
            WidgetValidator.sanitizeWidget(expandedWithComplexChild);

        expect(sanitized, isA<SizedBox>());
        final sanitizedSizedBox = sanitized as SizedBox;
        expect(sanitizedSizedBox.height, equals(50));
        expect(sanitizedSizedBox.child, isA<Container>());
      });
    });

    group('rendimiento y casos límite', () {
      test('Debe manejar widgets anidados profundamente de manera eficiente',
          () {
        Widget createNestedWidget(int depth) {
          if (depth == 0) {
            return const Text('Deep');
          }
          return Container(
            child: createNestedWidget(depth - 1),
          );
        }

        final deeplyNested = createNestedWidget(10);

        expect(() => WidgetValidator.isValidForSkeleton(deeplyNested),
            returnsNormally);
        expect(() => WidgetValidator.sanitizeWidget(deeplyNested),
            returnsNormally);
      });

      test('Debe manejar widgets con valores de restricción extremos', () {
        final extremeContainer = Container(
          constraints: const BoxConstraints(
            minWidth: 0,
            maxWidth: double.maxFinite,
            minHeight: 0,
            maxHeight: 10000,
          ),
        );

        expect(WidgetValidator.isValidForSkeleton(extremeContainer), isTrue);

        final sanitized = WidgetValidator.sanitizeWidget(extremeContainer);
        expect(sanitized, isA<Container>());
      });

      test(
          'Debe proporcionar información de diagnóstico integral para widgets complejos',
          () {
        final complexContainer = Container(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 300,
            minHeight: 50,
            maxHeight: 150,
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
              ),
            ],
          ),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const Text('Complex Container'),
        );

        final diagnosticInfo =
            WidgetValidator.getDiagnosticInfo(complexContainer);

        expect(diagnosticInfo, contains('Widget Type: Container'));
        expect(diagnosticInfo, contains('Container constraints:'));
        expect(diagnosticInfo, contains('Container decoration:'));
        expect(diagnosticInfo,
            contains('BoxConstraints(100.0<=w<=300.0, 50.0<=h<=150.0)'));
        expect(diagnosticInfo, contains('Is valid for skeleton: true'));
      });

      test('Debe manejar la sanitización de SingleChildRenderObjectWidget', () {
        final opacityWidget = Opacity(
          opacity: 0.5,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: double.infinity,
              maxHeight: double.infinity,
            ),
            child: const Text('Opacity child'),
          ),
        );

        final sanitized = WidgetValidator.sanitizeWidget(opacityWidget);

        expect(sanitized, isA<Container>());
        final sanitizedContainer = sanitized as Container;
        expect(sanitizedContainer.child, isA<Container>());
      });
    });
  });
}
