import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/interfaces/base_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/interfaces/skeleton_provider.dart';

import '../../mocks/default_priority_provider.dart';
import '../../mocks/test_skeleton_provider.dart';

void main() {
  group('BaseSkeletonProvider', () {
    late TestSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = TestSkeletonProvider();
    });

    group('implementación por defecto', () {
      test('Debería tener prioridad 0 por defecto cuando no se sobrescribe',
          () {
        final defaultProvider = DefaultPriorityProvider();
        expect(defaultProvider.priority, 0);
      });

      test('Debería permitir sobrescribir la prioridad', () {
        expect(provider.priority, 5);
      });

      test('Debería implementar SkeletonProvider', () {
        expect(provider, isA<SkeletonProvider>());
      });
    });

    group('hasValidDimensions', () {
      test('Debería retornar true cuando ambas dimensiones son null', () {
        expect(provider.testHasValidDimensions(null, null), isTrue);
      });

      test('Debería retornar true cuando width es null y height es finito', () {
        expect(provider.testHasValidDimensions(null, 100.0), isTrue);
      });

      test('Debería retornar true cuando height es null y width es finito', () {
        expect(provider.testHasValidDimensions(100.0, null), isTrue);
      });

      test('Debería retornar true cuando ambas dimensiones son finitas', () {
        expect(provider.testHasValidDimensions(100.0, 200.0), isTrue);
        expect(provider.testHasValidDimensions(0.0, 0.0), isTrue);
        expect(provider.testHasValidDimensions(1.5, 2.7), isTrue);
      });

      test('Debería retornar true para dimensiones finitas muy pequeñas', () {
        expect(provider.testHasValidDimensions(0.001, 0.001), isTrue);
      });

      test('Debería retornar true para dimensiones finitas muy grandes', () {
        expect(provider.testHasValidDimensions(999999.0, 999999.0), isTrue);
      });

      test('Debería retornar false cuando width es infinito', () {
        expect(
            provider.testHasValidDimensions(double.infinity, 100.0), isFalse);
        expect(provider.testHasValidDimensions(double.infinity, null), isFalse);
      });

      test('Debería retornar false cuando height es infinito', () {
        expect(
            provider.testHasValidDimensions(100.0, double.infinity), isFalse);
        expect(provider.testHasValidDimensions(null, double.infinity), isFalse);
      });

      test('Debería retornar false cuando ambas dimensiones son infinitas', () {
        expect(
            provider.testHasValidDimensions(double.infinity, double.infinity),
            isFalse);
      });

      test('Debería retornar false cuando width es NaN', () {
        expect(provider.testHasValidDimensions(double.nan, 100.0), isFalse);
        expect(provider.testHasValidDimensions(double.nan, null), isFalse);
      });

      test('Debería retornar false cuando height es NaN', () {
        expect(provider.testHasValidDimensions(100.0, double.nan), isFalse);
        expect(provider.testHasValidDimensions(null, double.nan), isFalse);
      });

      test('Debería retornar false cuando ambas dimensiones son NaN', () {
        expect(
            provider.testHasValidDimensions(double.nan, double.nan), isFalse);
      });

      test('Debería retornar false para combinaciones de valores no finitos',
          () {
        expect(provider.testHasValidDimensions(double.infinity, double.nan),
            isFalse);
        expect(provider.testHasValidDimensions(double.nan, double.infinity),
            isFalse);
      });

      test('Debería retornar true para dimensiones negativas finitas', () {
        expect(provider.testHasValidDimensions(-10.0, -20.0), isTrue);
        expect(provider.testHasValidDimensions(-1.5, 10.0), isTrue);
      });
    });

    group('sanitizeDimension', () {
      test('Debería retornar el valor original cuando es válido y positivo',
          () {
        expect(provider.testSanitizeDimension(100.0, 50.0), 100.0);
        expect(provider.testSanitizeDimension(25.5, 10.0), 25.5);
        expect(provider.testSanitizeDimension(1.0, 100.0), 1.0);
      });

      test('Debería retornar el valor por defecto cuando la dimensión es null',
          () {
        expect(provider.testSanitizeDimension(null, 50.0), 50.0);
        expect(provider.testSanitizeDimension(null, 100.0), 100.0);
        expect(provider.testSanitizeDimension(null, 25.5), 25.5);
      });

      test('Debería retornar el valor por defecto cuando la dimensión es 0',
          () {
        expect(provider.testSanitizeDimension(0.0, 50.0), 50.0);
      });

      test(
          'Debería retornar el valor por defecto cuando la dimensión es negativa',
          () {
        expect(provider.testSanitizeDimension(-10.0, 50.0), 50.0);
        expect(provider.testSanitizeDimension(-1.5, 25.0), 25.0);
        expect(provider.testSanitizeDimension(-100.0, 75.0), 75.0);
      });

      test(
          'Debería retornar el valor por defecto cuando la dimensión es infinita',
          () {
        expect(provider.testSanitizeDimension(double.infinity, 50.0), 50.0);
        expect(provider.testSanitizeDimension(double.negativeInfinity, 25.0),
            25.0);
      });

      test('Debería retornar el valor por defecto cuando la dimensión es NaN',
          () {
        expect(provider.testSanitizeDimension(double.nan, 50.0), 50.0);
      });

      test('Debería manejar valores muy pequeños positivos', () {
        expect(provider.testSanitizeDimension(0.001, 50.0), 0.001);
        expect(provider.testSanitizeDimension(0.0001, 10.0), 0.0001);
      });

      test('Debería manejar valores muy grandes', () {
        expect(provider.testSanitizeDimension(999999.0, 50.0), 999999.0);
        expect(provider.testSanitizeDimension(1e6, 100.0), 1e6);
      });

      test('Debería manejar diferentes valores por defecto', () {
        expect(provider.testSanitizeDimension(null, 0.0), 0.0);
        expect(provider.testSanitizeDimension(null, 1.5), 1.5);
        expect(provider.testSanitizeDimension(null, 1000.0), 1000.0);
      });

      group('casos extremos de sanitización', () {
        test('Debería sanitizar múltiples casos problemáticos', () {
          final testCases = <Map<String, Object?>>[
            {'input': null, 'default': 40.0, 'expected': 40.0},
            {'input': 0.0, 'default': 40.0, 'expected': 40.0},
            {'input': -1.0, 'default': 40.0, 'expected': 40.0},
            {'input': -100.0, 'default': 40.0, 'expected': 40.0},
            {'input': double.infinity, 'default': 40.0, 'expected': 40.0},
            {
              'input': double.negativeInfinity,
              'default': 40.0,
              'expected': 40.0
            },
            {'input': double.nan, 'default': 40.0, 'expected': 40.0},
            {'input': 50.0, 'default': 40.0, 'expected': 50.0},
            {'input': 0.1, 'default': 40.0, 'expected': 0.1},
          ];

          for (final testCase in testCases) {
            final input = testCase['input'] as double?;
            final defaultValue = testCase['default'] as double;
            final expected = testCase['expected'] as double;

            expect(
              provider.testSanitizeDimension(input, defaultValue),
              expected,
              reason: 'Falló para input: $input, default: $defaultValue',
            );
          }
        });
      });
    });

    group('métodos abstractos', () {
      test('Debería implementar canHandle correctamente', () {
        final containerWidget = Container();
        final textWidget = const Text('test');

        expect(provider.canHandle(containerWidget), isTrue);
        expect(provider.canHandle(textWidget), isFalse);
      });

      test('Debería implementar createSkeleton correctamente', () {
        final containerWidget = Container();
        final skeleton = provider.createSkeleton(containerWidget, baseColor);

        expect(skeleton, isA<Container>());
        final skeletonContainer = skeleton as Container;
        expect(skeletonContainer.color, baseColor);
      });

      test('Debería implementar priority correctamente', () {
        expect(provider.priority, 5);
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería implementar SkeletonProvider', () {
        expect(provider, isA<SkeletonProvider>());
      });

      test('Debería permitir extensión por clases concretas', () {
        expect(provider, isA<BaseSkeletonProvider>());
        expect(provider, isA<TestSkeletonProvider>());
      });

      test('Debería implementar todos los métodos requeridos sin errores', () {
        final widget = Container();

        expect(() => provider.canHandle(widget), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(
            () => provider.createSkeleton(widget, baseColor), returnsNormally);
        expect(() => provider.testHasValidDimensions(100.0, 100.0),
            returnsNormally);
        expect(
            () => provider.testSanitizeDimension(100.0, 50.0), returnsNormally);
      });
    });

    group('comportamiento en escenarios reales', () {
      test('Debería validar correctamente dimensiones de widgets típicos', () {
        // Dimensiones típicas de botones
        expect(provider.testHasValidDimensions(120.0, 40.0), isTrue);

        // Dimensiones típicas de imágenes
        expect(provider.testHasValidDimensions(300.0, 200.0), isTrue);

        // Dimensiones típicas de contenedores
        expect(provider.testHasValidDimensions(100.0, 100.0), isTrue);
      });

      test('Debería sanitizar correctamente valores problemáticos comunes', () {
        expect(provider.testSanitizeDimension(0.0, 24.0), 24.0);
        expect(provider.testSanitizeDimension(-10.0, 18.0), 18.0);
        expect(provider.testSanitizeDimension(double.infinity, 100.0), 100.0);
        expect(provider.testSanitizeDimension(null, 40.0), 40.0);
      });

      test('Debería preservar valores válidos sin modificación', () {
        final validDimensions = [1.0, 18.0, 24.0, 40.0, 100.0, 200.0, 300.0];

        for (final dimension in validDimensions) {
          expect(
            provider.testSanitizeDimension(dimension, 50.0),
            dimension,
            reason: 'Debería preservar el valor válido: $dimension',
          );
        }
      });
    });

    group('casos extremos y límites', () {
      test('Debería manejar valores en los límites de precisión de double', () {
        final verySmall = double.minPositive;
        expect(provider.testSanitizeDimension(verySmall, 50.0), verySmall);

        final veryLarge = double.maxFinite;
        expect(provider.testSanitizeDimension(veryLarge, 50.0), veryLarge);
      });

      test('Debería manejar combinaciones extremas en hasValidDimensions', () {
        expect(
            provider.testHasValidDimensions(
                double.minPositive, double.maxFinite),
            isTrue);
        expect(provider.testHasValidDimensions(0.0, double.maxFinite), isTrue);
        expect(
            provider.testHasValidDimensions(double.minPositive, 0.0), isTrue);
      });

      test('Debería manejar valores por defecto extremos en sanitización', () {
        expect(provider.testSanitizeDimension(null, 0.0), 0.0);
        expect(provider.testSanitizeDimension(null, double.maxFinite),
            double.maxFinite);
        expect(provider.testSanitizeDimension(null, double.minPositive),
            double.minPositive);
      });
    });

    group('consistencia entre métodos', () {
      test('sanitizeDimension debería ser consistente con hasValidDimensions',
          () {
        final problematicValues = [
          double.infinity,
          double.negativeInfinity,
          double.nan,
          0.0,
          -10.0,
        ];

        for (final value in problematicValues) {
          if (!value.isFinite || value <= 0) {
            expect(
              provider.testSanitizeDimension(value, 50.0),
              50.0,
              reason: 'sanitizeDimension debería usar default para: $value',
            );
          }
        }
      });

      test(
          'hasValidDimensions debería aceptar valores que sanitizeDimension preserva',
          () {
        final validValues = [1.0, 10.0, 50.0, 100.0, 1000.0];

        for (final value in validValues) {
          expect(
            provider.testHasValidDimensions(value, value),
            isTrue,
            reason: 'hasValidDimensions debería aceptar: $value',
          );
          expect(
            provider.testSanitizeDimension(value, 25.0),
            value,
            reason: 'sanitizeDimension debería preservar: $value',
          );
        }
      });
    });
  });
}
