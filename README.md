# Flutter Skeleton Loader

[![pub package](https://img.shields.io/pub/v/flutter_skeleton_loader.svg)](https://pub.dev/packages/flutter_skeleton_loader)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tests](https://github.com/idamkiller/flutter_skeleton_loader/actions/workflows/tests.yml/badge.svg)](https://github.com/idam/flutter_skeleton_loader/actions/workflows/tests.yml)


Una biblioteca Flutter para crear efectos de carga (skeletons) elegantes y personalizables para tus aplicaciones. Proporciona una forma sencilla de mostrar placeholders mientras se cargan los datos reales.

## Características

- 🚀 Fácil de implementar con un solo widget `SkeletonLoader`
- 🎨 Personalizable con colores y dimensiones
- 🔄 Soporte para todos los widgets comunes de Flutter
- 📱 Diseño responsivo
- ⚡ Rendimiento optimizado
- 🧪 Cobertura de pruebas completa

## Instalación

Agrega la dependencia a tu archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_skeleton_loader: ^1.0.0
```

Luego ejecuta:

```bash
flutter pub get
```

## Uso básico

```dart
import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simular carga de datos
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      isLoading: isLoading,
      child: YourActualWidget(),
    );
  }
}
```

## Ejemplos

### Texto

```dart
SkeletonLoader(
  isLoading: isLoading,
  child: Text(
    'Este es un texto que se mostrará cuando termine de cargar',
    style: TextStyle(fontSize: 16),
  ),
)
```

### Imagen

```dart
SkeletonLoader(
  isLoading: isLoading,
  child: Image.network(
    'https://example.com/image.jpg',
    width: 200,
    height: 200,
  ),
)
```

### Lista

```dart
SkeletonLoader(
  isLoading: isLoading,
  child: ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text('Item $index'),
        subtitle: Text('Descripción del item $index'),
      );
    },
  ),
)
```

### Formulario

```dart
SkeletonLoader(
  isLoading: isLoading,
  child: Column(
    children: [
      TextField(
        decoration: InputDecoration(labelText: 'Nombre'),
      ),
      SizedBox(height: 16),
      TextField(
        decoration: InputDecoration(labelText: 'Email'),
      ),
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {},
        child: Text('Enviar'),
      ),
    ],
  ),
)
```

## Widgets soportados

El paquete soporta automáticamente los siguientes widgets:

- Text
- Image
- Container
- SizedBox
- Card
- IconButton
- Icon
- CircleAvatar
- ListTile
- ListView
- PageView
- TextField
- TextFormField
- Checkbox
- Switch
- Radio (todos los tipos genéricos)
- DropdownButton (todos los tipos genéricos)
- PopupMenuButton (todos los tipos genéricos)
- Slider
- Row
- Column
- Wrap
- Flex
- Form

## Personalización

Puedes personalizar el color base de los skeletons:

```dart
SkeletonLoader(
  isLoading: isLoading,
  baseColor: Colors.grey[300],
  child: YourWidget(),
)
```

## Contribuir

Las contribuciones son bienvenidas. Si encuentras un bug o tienes una sugerencia, por favor abre un issue en GitHub.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
