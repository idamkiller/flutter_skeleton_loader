import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/config/skeleton_config.dart';

void main() {
  group('SkeletonConfig', () {
    setUp(() {
      SkeletonConfig.reset();
    });

    tearDown(() {
      SkeletonConfig.reset();
    });

    group('Valores predeterminados', () {
      test('Debería tener valores predeterminados correctos', () {
        final config = SkeletonConfig.instance;

        expect(config.defaultBaseColor, equals(const Color(0xFFE0E0E0)));
        expect(config.defaultHighlightColor, equals(const Color(0xFFEEEEEE)));
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 1500)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('Debería devolver la misma instancia en múltiples llamadas', () {
        final instance1 = SkeletonConfig.instance;
        final instance2 = SkeletonConfig.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Configuración', () {
      test('Debería configurar baseColor correctamente', () {
        const customBaseColor = Color(0xFF123456);

        SkeletonConfig.configure(baseColor: customBaseColor);

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(customBaseColor));

        expect(config.defaultHighlightColor, equals(const Color(0xFFEEEEEE)));
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 1500)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('Debería configurar highlightColor correctamente', () {
        const customHighlightColor = Color(0xFF654321);

        SkeletonConfig.configure(highlightColor: customHighlightColor);

        final config = SkeletonConfig.instance;
        expect(config.defaultHighlightColor, equals(customHighlightColor));

        expect(config.defaultBaseColor, equals(const Color(0xFFE0E0E0)));
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 1500)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('Debería configurar shimmerDuration correctamente', () {
        const customShimmerDuration = Duration(milliseconds: 2000);

        SkeletonConfig.configure(shimmerDuration: customShimmerDuration);

        final config = SkeletonConfig.instance;
        expect(config.defaultShimmerDuration, equals(customShimmerDuration));

        expect(config.defaultBaseColor, equals(const Color(0xFFE0E0E0)));
        expect(config.defaultHighlightColor, equals(const Color(0xFFEEEEEE)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('Debería configurar transitionDuration correctamente', () {
        const customTransitionDuration = Duration(milliseconds: 500);

        SkeletonConfig.configure(transitionDuration: customTransitionDuration);

        final config = SkeletonConfig.instance;
        expect(
            config.defaultTransitionDuration, equals(customTransitionDuration));

        expect(config.defaultBaseColor, equals(const Color(0xFFE0E0E0)));
        expect(config.defaultHighlightColor, equals(const Color(0xFFEEEEEE)));
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 1500)));
      });

      test('Debería configurar todos los valores a la vez', () {
        const customBaseColor = Color(0xFF111111);
        const customHighlightColor = Color(0xFF222222);
        const customShimmerDuration = Duration(milliseconds: 1000);
        const customTransitionDuration = Duration(milliseconds: 400);

        SkeletonConfig.configure(
          baseColor: customBaseColor,
          highlightColor: customHighlightColor,
          shimmerDuration: customShimmerDuration,
          transitionDuration: customTransitionDuration,
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(customBaseColor));
        expect(config.defaultHighlightColor, equals(customHighlightColor));
        expect(config.defaultShimmerDuration, equals(customShimmerDuration));
        expect(
            config.defaultTransitionDuration, equals(customTransitionDuration));
      });

      test(
          'Debería preservar los valores existentes al configurar valores parciales',
          () {
        SkeletonConfig.configure(
          baseColor: const Color(0xFF111111),
          shimmerDuration: const Duration(milliseconds: 1000),
        );

        SkeletonConfig.configure(
          highlightColor: const Color(0xFF222222),
          transitionDuration: const Duration(milliseconds: 400),
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(const Color(0xFF111111)));
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 1000)));

        expect(config.defaultHighlightColor, equals(const Color(0xFF222222)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 400)));
      });

      test('Debería manejar valores nulos correctamente', () {
        SkeletonConfig.configure(
          baseColor: const Color(0xFF111111),
          highlightColor: const Color(0xFF222222),
          shimmerDuration: const Duration(milliseconds: 1000),
          transitionDuration: const Duration(milliseconds: 400),
        );

        SkeletonConfig.configure(
          baseColor: null,
          highlightColor: null,
          shimmerDuration: null,
          transitionDuration: null,
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(const Color(0xFF111111)));
        expect(config.defaultHighlightColor, equals(const Color(0xFF222222)));
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 1000)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 400)));
      });
    });

    group('funcionalidad de reinicio', () {
      test('Debería restablecer a los valores predeterminados', () {
        SkeletonConfig.configure(
          baseColor: const Color(0xFF111111),
          highlightColor: const Color(0xFF222222),
          shimmerDuration: const Duration(milliseconds: 1000),
          transitionDuration: const Duration(milliseconds: 400),
        );

        var config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(const Color(0xFF111111)));
        expect(config.defaultHighlightColor, equals(const Color(0xFF222222)));

        SkeletonConfig.reset();

        config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(const Color(0xFFE0E0E0)));
        expect(config.defaultHighlightColor, equals(const Color(0xFFEEEEEE)));
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 1500)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 300)));
      });

      test('Debería crear una nueva instancia después de restablecer', () {
        final instance1 = SkeletonConfig.instance;

        SkeletonConfig.reset();

        final instance2 = SkeletonConfig.instance;

        expect(identical(instance1, instance2), isFalse);
      });
    });

    group('comportamiento de singleton', () {
      test('Debería mantener singleton después de la configuración', () {
        SkeletonConfig.configure(baseColor: const Color(0xFF111111));

        final instance1 = SkeletonConfig.instance;
        final instance2 = SkeletonConfig.instance;

        expect(identical(instance1, instance2), isTrue);
        expect(instance1.defaultBaseColor, equals(const Color(0xFF111111)));
        expect(instance2.defaultBaseColor, equals(const Color(0xFF111111)));
      });

      test(
          'Debería mantener los valores configurados a través de múltiples accesos',
          () {
        const customColor = Color(0xFF333333);
        const customDuration = Duration(milliseconds: 2500);

        SkeletonConfig.configure(
          baseColor: customColor,
          shimmerDuration: customDuration,
        );

        for (int i = 0; i < 5; i++) {
          final config = SkeletonConfig.instance;
          expect(config.defaultBaseColor, equals(customColor));
          expect(config.defaultShimmerDuration, equals(customDuration));
        }
      });
    });

    group('Casos límite', () {
      test('Debería manejar valores de duración cero', () {
        SkeletonConfig.configure(
          shimmerDuration: Duration.zero,
          transitionDuration: Duration.zero,
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultShimmerDuration, equals(Duration.zero));
        expect(config.defaultTransitionDuration, equals(Duration.zero));
      });

      test('Debería manejar valores de duración muy grandes', () {
        const largeDuration = Duration(days: 365);

        SkeletonConfig.configure(shimmerDuration: largeDuration);

        final config = SkeletonConfig.instance;
        expect(config.defaultShimmerDuration, equals(largeDuration));
      });

      test('Debería manejar Colors.transparent', () {
        SkeletonConfig.configure(
          baseColor: Colors.transparent,
          highlightColor: Colors.transparent,
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(Colors.transparent));
        expect(config.defaultHighlightColor, equals(Colors.transparent));
      });

      test('Debería manejar colores de alta opacidad', () {
        const opaqueColor = Color(0xFFFFFFFF);
        const semiTransparentColor = Color(0x80FFFFFF);

        SkeletonConfig.configure(
          baseColor: opaqueColor,
          highlightColor: semiTransparentColor,
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(opaqueColor));
        expect(config.defaultHighlightColor, equals(semiTransparentColor));
      });
    });

    group('Inmutabilidad', () {
      test('Debería ser inmutable después de la creación', () {
        const customColor = Color(0xFF111111);
        SkeletonConfig.configure(baseColor: customColor);

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(customColor));

        expect(config, isA<SkeletonConfig>());
      });

      test('Debería crear una nueva instancia al reconfigurar', () {
        SkeletonConfig.configure(baseColor: const Color(0xFF111111));
        final instance1 = SkeletonConfig.instance;

        SkeletonConfig.configure(baseColor: const Color(0xFF222222));
        final instance2 = SkeletonConfig.instance;

        expect(identical(instance1, instance2), isFalse);
        expect(instance1.defaultBaseColor, equals(const Color(0xFF111111)));
        expect(instance2.defaultBaseColor, equals(const Color(0xFF222222)));
      });
    });

    group('Patrones de uso comunes', () {
      test('Debería soportar colores de Material Design', () {
        SkeletonConfig.configure(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(Colors.grey[300]));
        expect(config.defaultHighlightColor, equals(Colors.grey[100]));
      });

      test('Debería soportar colores de tema personalizados', () {
        const primaryColor = Color(0xFF6200EA);
        const surfaceColor = Color(0xFFF5F5F5);

        SkeletonConfig.configure(
          baseColor: surfaceColor,
          highlightColor: primaryColor,
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultBaseColor, equals(surfaceColor));
        expect(config.defaultHighlightColor, equals(primaryColor));
      });

      test(
          'Debería soportar la optimización del rendimiento con duraciones más cortas',
          () {
        SkeletonConfig.configure(
          shimmerDuration: const Duration(milliseconds: 800),
          transitionDuration: const Duration(milliseconds: 150),
        );

        final config = SkeletonConfig.instance;
        expect(config.defaultShimmerDuration,
            equals(const Duration(milliseconds: 800)));
        expect(config.defaultTransitionDuration,
            equals(const Duration(milliseconds: 150)));
      });
    });
  });
}
