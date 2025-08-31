import 'package:example/widgets/basic_example.dart';
import 'package:example/widgets/builder_pattern_example.dart';
import 'package:example/widgets/card_example.dart';
import 'package:example/widgets/complex_layout_example.dart';
import 'package:example/widgets/dropdown_example.dart';
import 'package:example/widgets/list_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

/// [EJEMPLOS DE USO AVANZADO]
/// Ejemplos que demuestran las nuevas funcionalidades y mejoras
/// implementadas en el paquete flutter_skeleton_loader.

void main() {
  // [CONFIGURACIÓN GLOBAL] Configurar valores por defecto para toda la app
  SkeletonConfig.configure(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    shimmerDuration: const Duration(milliseconds: 1200),
    transitionDuration: const Duration(milliseconds: 400),
  );

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skeleton Loader - Ejemplos Avanzados',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skeleton Loader - Ejemplos'),
        actions: [
          IconButton(
            icon: Icon(_isLoading ? Icons.stop : Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = !_isLoading;
              });
              if (_isLoading) {
                _simulateLoading();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// [EJEMPLO BÁSICO] Uso estándar del SkeletonLoader
            BasicExample(isLoading: _isLoading),

            /// [EJEMPLO BUILDER] Usando la nueva API Builder
            BuilderPatternExample(isLoading: _isLoading),

            /// [EJEMPLO LAYOUT COMPLEJO] Manejo de widgets complejos
            ComplexLayoutExample(isLoading: _isLoading),

            /// [EJEMPLO LISTA] Skeleton para listas
            ListExample(isLoading: _isLoading),

            /// [EJEMPLO CARD] Skeleton para cards
            CardExample(isLoading: _isLoading),

            /// [EJEMPLO DROPDOWN] Skeleton para DropdownButton
            DropdownExample(isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}

/// [EJEMPLOS DE CONFIGURACIÓN]
/// Clase que demuestra diferentes configuraciones avanzadas
class AdvancedConfigurationExamples {
  /// [CONFIGURACIÓN PERSONALIZADA] Setup personalizado para diferentes temas
  static void setupCustomTheme() {
    SkeletonConfig.configure(
      baseColor: const Color(0xFF2C2C2C),
      highlightColor: const Color(0xFF3E3E3E),
      shimmerDuration: const Duration(milliseconds: 2000),
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  /// [EJEMPLO DE VALIDACIÓN] Cómo usar el validador de widgets
  static Widget buildWithValidation(Widget child) {
    // [VALIDACIÓN PREVIA] Validar widget antes de crear skeleton
    if (!WidgetValidator.isValidForSkeleton(child)) {
      final sanitizedChild = WidgetValidator.sanitizeWidget(child);

      return SkeletonLoader(isLoading: true, child: sanitizedChild);
    }

    return SkeletonLoader(isLoading: true, child: child);
  }
}
