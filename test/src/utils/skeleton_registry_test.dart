import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/default_skeleton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/utils/skeleton_registry.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/skeletons.dart';

void main() {
  group('SkeletonRegistry', () {
    const baseColor = Colors.grey;

    testWidgets('debería construir TextSkeleton para un Text', (tester) async {
      const text = 'Hola Mundo';
      final widget = Text(text);
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<TextSkeleton>());
      expect((skeleton as TextSkeleton).text, text);
      expect(skeleton.baseColor, baseColor);
    });

    testWidgets('debería construir ImageSkeleton para un Image', (
      tester,
    ) async {
      final widget = Image.network('https://example.com/image.jpg');
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<ImageSkeleton>());
      expect((skeleton as ImageSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir ContainerSkeleton para un Container', (
      tester,
    ) async {
      final widget = Container(width: 100, height: 100, color: Colors.blue);
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<ContainerSkeleton>());
      expect((skeleton as ContainerSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir SizedBoxSkeleton para un SizedBox', (
      tester,
    ) async {
      final widget = SizedBox(width: 100, height: 100);
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<SizedBoxSkeleton>());
      expect((skeleton as SizedBoxSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir CardSkeleton para un Card', (tester) async {
      final widget = Card(child: Container());
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<CardSkeleton>());
      expect((skeleton as CardSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir IconButtonSkeleton para un IconButton', (
      tester,
    ) async {
      final widget = IconButton(icon: Icon(Icons.add), onPressed: () {});
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<IconButtonSkeleton>());
      expect((skeleton as IconButtonSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir IconSkeleton para un Icon', (tester) async {
      final widget = Icon(Icons.add);
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<IconSkeleton>());
      expect((skeleton as IconSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir ListTileSkeleton para un ListTile', (
      tester,
    ) async {
      final widget = ListTile(
        title: Text('Título'),
        subtitle: Text('Subtítulo'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<ListTileSkeleton>());
      expect((skeleton as ListTileSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir ListViewSkeleton para un ListView', (
      tester,
    ) async {
      final widget = ListView(
        children: [
          ListTile(title: Text('Item 1')),
          ListTile(title: Text('Item 2')),
        ],
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<ListViewSkeleton>());
      expect((skeleton as ListViewSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir PageViewSkeleton para un PageView', (
      tester,
    ) async {
      final widget = PageView(children: [Container(), Container()]);
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<PageViewSkeleton>());
      expect((skeleton as PageViewSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir TextFieldSkeleton para un TextField', (
      tester,
    ) async {
      final widget = TextField();
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<TextFieldSkeleton>());
      expect((skeleton as TextFieldSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir TextFieldSkeleton para un TextFormField', (
      tester,
    ) async {
      final widget = TextFormField();
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<TextFieldSkeleton>());
      expect((skeleton as TextFieldSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir CheckboxSkeleton para un Checkbox', (
      tester,
    ) async {
      final widget = Checkbox(value: false, onChanged: (value) {});
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<CheckboxSkeleton>());
      expect((skeleton as CheckboxSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir CheckboxSkeleton para un Switch', (
      tester,
    ) async {
      final widget = Switch(value: false, onChanged: (value) {});
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<CheckboxSkeleton>());
      expect((skeleton as CheckboxSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir RadioSkeleton para un Radio', (
      tester,
    ) async {
      final widget = Radio<int>(value: 1, groupValue: 1, onChanged: (value) {});
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });

    testWidgets(
      'debería construir DropdownButtonSkeleton para un DropdownButton',
      (tester) async {
        final widget = DropdownButton<String>(
          value: '1',
          items: [
            DropdownMenuItem(value: '1', child: Text('Item 1')),
            DropdownMenuItem(value: '2', child: Text('Item 2')),
          ],
          onChanged: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );

    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton',
      (tester) async {
        final widget = PopupMenuButton<String>(
          itemBuilder:
              (context) => [
                PopupMenuItem(value: '1', child: Text('Item 1')),
                PopupMenuItem(value: '2', child: Text('Item 2')),
              ],
          onSelected: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );

    testWidgets('debería construir SliderSkeleton para un Slider', (
      tester,
    ) async {
      final widget = Slider(value: 0.5, onChanged: (value) {});
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<SliderSkeleton>());
      expect((skeleton as SliderSkeleton).baseColor, baseColor);
    });

    testWidgets(
      'debería construir DefaultSkeleton para un widget no registrado',
      (tester) async {
        final widget = CustomPaint();
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DefaultSkeleton>());
        expect((skeleton as DefaultSkeleton).baseColor, baseColor);
      },
    );

    testWidgets(
      'debería construir skeletons para widgets con múltiples hijos',
      (tester) async {
        final widget = Row(children: [Text('Texto 1'), Text('Texto 2')]);
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<Row>());
        final row = skeleton as Row;
        expect(row.children.length, 2);
        expect(row.children[0], isA<TextSkeleton>());
        expect(row.children[1], isA<TextSkeleton>());
      },
    );

    testWidgets('debería construir skeleton para un Form', (tester) async {
      final widget = Form(child: TextField());
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<TextFieldSkeleton>());
      expect((skeleton as TextFieldSkeleton).baseColor, baseColor);
    });
  });
}
