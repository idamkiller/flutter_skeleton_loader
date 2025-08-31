# Changelog

## [2.0.0] - 2025-08-23

### ⚡ MEJORAS MAYORES DE RENDIMIENTO Y ARQUITECTURA

#### Añadido
- **Sistema de caché inteligente** para skeletons - reduce reconstrucciones.
- **Configuración global** con `SkeletonConfig` para valores por defecto centralizados.
- **Builder Pattern** con `SkeletonLoaderBuilder` para API más fluida e intuitiva.
- **Arquitectura modular** basada en providers para mejor extensibilidad.
- **Validador de widgets** que previene errores comunes de renderizado.
- **Registry optimizado** con lazy loading y sistema de prioridades.
- **Utilidades de testing** para facilitar pruebas automatizadas.
- **Manejo robusto de errores** con fallbacks automáticos.
- **Ejemplos avanzados** demostrando todas las nuevas funcionalidades.

#### Mejorado
- **ShimmerEffect optimizado** - mejor rendimiento en animaciones.
- **Mejor manejo de layout** - elimina errores de "unbounded height/width".
- **PageViewSkeleton mejorado** con solución a problemas de dimensiones.
- **AnimatedCrossFade personalizado** para transiciones más suaves.
- **Documentación inline** exhaustiva en todo el código.
- **Gestión de memoria** optimizada para aplicaciones complejas.

#### Corregido
- Errores de renderizado con widgets `Expanded` fuera de contexto Flex.
- Problemas de dimensiones infinitas que causaban crashes.
- Issues con `PageView` y "Horizontal viewport unbounded height".
- Memory leaks en animaciones de larga duración.
- Incompatibilidades con ciertos tipos de widgets complejos.

#### API Nuevas

##### Configuración Global
```dart
SkeletonConfig.configure(
  baseColor: Colors.grey[300],
  highlightColor: Colors.white,
  shimmerDuration: Duration(milliseconds: 1000),
);
```

##### Builder Pattern
```dart
SkeletonLoaderBuilder()
  .child(Text('Hello World'))
  .loading(true)
  .lightTheme()
  .fastAnimation()
  .build();
```

##### Métodos de Conveniencia
```dart
// Configuración rápida
SkeletonLoaderBuilder.quick(child: widget, isLoading: true);

// Tema claro
SkeletonLoaderBuilder.light(child: widget, isLoading: true);

// Tema oscuro  
SkeletonLoaderBuilder.dark(child: widget, isLoading: true);
```

##### Validación de Widgets
```dart
// Validar widget antes de crear skeleton
if (!WidgetValidator.isValidForSkeleton(widget)) {
  widget = WidgetValidator.sanitizeWidget(widget);
}
```

#### Breaking Changes
- Mínima versión de Dart requerida: 2.17.0
- Algunos constructores internos han cambiado (no afecta API pública)
- El comportamiento de caché puede cambiar el timing de algunas animaciones

#### Migración
La mayoría del código existente funcionará sin cambios. Para aprovechar las nuevas funcionalidades:

1. **Configuración global** (opcional):
```dart
// Al inicio de la app
SkeletonConfig.configure(baseColor: yourColor);
```

2. **Builder pattern** (opcional, mejora legibilidad):
```dart
// Antes
SkeletonLoader(isLoading: true, child: widget)

// Ahora (opcional)
SkeletonLoaderBuilder().child(widget).loading(true).build()
```

3. **Manejo de errores** (automático):
Los widgets problemáticos ahora se validan y sanitizan automáticamente.

## [1.1.1] - 2025-07-17

### Fixes
- Corrección de problemas de renderizado en el widget `SkeletonLoader` que causaban parpadeos en algunos dispositivos.
- Mejora en la detección de cambios de estado para evitar renderizados innecesarios.
- Ajustes en la lógica de animación para mejorar la fluidez del efecto shimmer.
- Corrección de problemas de compatibilidad con algunos Widgets.

## [1.1.0] - 2025-04-20

### Añadido
- Mejora en manejo de SizedBox cuando trae un hijo
- Optimización de rendimiento en el widget SkeletonLoader
- Nuevo parámetro `shimmerDuration` para personalizar la duración de la animación
- Mayor coherencia en la API de SkeletonLoader

### Mejorado
- Documentación más detallada para todos los parámetros
- Rendimiento de animaciones con uso de RepaintBoundary
- Calidad del efecto de shimmer con mejores transiciones

## [1.0.1] - 2025-04-19

### Añadido
- Soporte para GestureDetector

## [1.0.0] - 2025-04-18

### Añadido
- Implementación inicial del paquete Flutter Skeleton Loader
- Widget `SkeletonLoader` para mostrar efectos de carga
- Soporte para todos los widgets comunes de Flutter:
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
- Personalización del color base de los skeletons
- Documentación completa con ejemplos
- Pruebas unitarias y de widgets para todos los componentes
