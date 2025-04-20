# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
