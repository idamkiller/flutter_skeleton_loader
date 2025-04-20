import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/default_skeleton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/utils/skeleton_registry.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/skeletons.dart';

enum MyEnum { value1, value2 }

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

    testWidgets('debería construir SizedBoxSkeleton para un SizedBox sin child',
        (
      tester,
    ) async {
      final widget = SizedBox(width: 100, height: 100);
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<SizedBoxSkeleton>());
      expect((skeleton as SizedBoxSkeleton).baseColor, baseColor);
    });
    testWidgets('debería construir SizedBox para un SizedBox con child', (
      tester,
    ) async {
      final widget = SizedBox(
        width: 100,
        height: 10,
        child: Text('Test'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<SizedBox>());
    });
    testWidgets(
        'debería construir SizedBox con un child Skeleton para un SizedBox con child',
        (
      tester,
    ) async {
      final widget = SizedBox(
        width: 100,
        height: 10,
        child: Text('Test'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<SizedBox>());
      expect((skeleton as SizedBox).child, isA<TextSkeleton>());
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

    testWidgets('debería construir RadioSkeleton para un Radio<int>', (
      tester,
    ) async {
      final widget = Radio<int>(value: 1, groupValue: 1, onChanged: (value) {});
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir RadioSkeleton para un Radio<String>', (
      tester,
    ) async {
      final widget = Radio<String>(
        value: '1',
        groupValue: '1',
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir RadioSkeleton para un Radio<bool>', (
      tester,
    ) async {
      final widget = Radio<bool>(
        value: true,
        groupValue: true,
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });
    testWidgets('debería construir RadioSkeleton para un Radio<double>', (
      tester,
    ) async {
      final widget = Radio<double>(
        value: 1.0,
        groupValue: 1.0,
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });
    testWidgets('debería construir RadioSkeleton para un Radio<Color>', (
      tester,
    ) async {
      final widget = Radio<Color>(
        value: Colors.red,
        groupValue: Colors.red,
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir RadioSkeleton para un Radio<DateTime>', (
      tester,
    ) async {
      final widget = Radio<DateTime>(
        value: DateTime.now(),
        groupValue: DateTime.now(),
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });
    testWidgets('debería construir RadioSkeleton para un Radio<Duration>', (
      tester,
    ) async {
      final widget = Radio<Duration>(
        value: Duration(seconds: 1),
        groupValue: Duration(seconds: 1),
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });
    testWidgets('debería construir RadioSkeleton para un Radio<Enum>', (
      tester,
    ) async {
      final widget = Radio<Enum>(
        value: MyEnum.value1,
        groupValue: MyEnum.value1,
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });
    testWidgets('debería construir RadioSkeleton para un Radio<void>', (
      tester,
    ) async {
      final widget = Radio<void>(
        value: null,
        groupValue: null,
        onChanged: (value) {},
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<RadioSkeleton>());
      expect((skeleton as RadioSkeleton).baseColor, baseColor);
    });

    testWidgets(
      'debería construir DropdownButtonSkeleton para un DropdownButton<String>',
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
      'debería construir DropdownButtonSkeleton para un DropdownButton<int>',
      (tester) async {
        final widget = DropdownButton<int>(
          value: 1,
          items: [
            DropdownMenuItem(value: 1, child: Text('Item 1')),
            DropdownMenuItem(value: 2, child: Text('Item 2')),
          ],
          onChanged: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un DropdownButton<bool>',
      (tester) async {
        final widget = DropdownButton<bool>(
          value: true,
          items: [
            DropdownMenuItem(value: true, child: Text('Item 1')),
            DropdownMenuItem(value: false, child: Text('Item 2')),
          ],
          onChanged: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un DropdownButton<double>',
      (tester) async {
        final widget = DropdownButton<double>(
          value: 1.0,
          items: [
            DropdownMenuItem(value: 1.0, child: Text('Item 1')),
            DropdownMenuItem(value: 2.0, child: Text('Item 2')),
          ],
          onChanged: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un DropdownButton<Color>',
      (tester) async {
        final widget = DropdownButton<Color>(
          value: Colors.red,
          items: [
            DropdownMenuItem(value: Colors.red, child: Text('Item 1')),
            DropdownMenuItem(value: Colors.blue, child: Text('Item 2')),
          ],
          onChanged: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un DropdownButton<Duration>',
      (tester) async {
        final widget = DropdownButton<Duration>(
          value: Duration(seconds: 1),
          items: [
            DropdownMenuItem(
              value: Duration(seconds: 1),
              child: Text('Item 1'),
            ),
            DropdownMenuItem(
              value: Duration(seconds: 2),
              child: Text('Item 2'),
            ),
          ],
          onChanged: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<String>',
      (tester) async {
        final widget = PopupMenuButton<String>(
          itemBuilder: (context) => [
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
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<int>',
      (tester) async {
        final widget = PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(value: 1, child: Text('Item 1')),
            PopupMenuItem(value: 2, child: Text('Item 2')),
          ],
          onSelected: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<bool>',
      (tester) async {
        final widget = PopupMenuButton<bool>(
          itemBuilder: (context) => [
            PopupMenuItem(value: true, child: Text('Item 1')),
            PopupMenuItem(value: false, child: Text('Item 2')),
          ],
          onSelected: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<double>',
      (tester) async {
        final widget = PopupMenuButton<double>(
          itemBuilder: (context) => [
            PopupMenuItem(value: 1.0, child: Text('Item 1')),
            PopupMenuItem(value: 2.0, child: Text('Item 2')),
          ],
          onSelected: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<Color>',
      (tester) async {
        final widget = PopupMenuButton<Color>(
          itemBuilder: (context) => [
            PopupMenuItem(value: Colors.red, child: Text('Item 1')),
            PopupMenuItem(value: Colors.blue, child: Text('Item 2')),
          ],
          onSelected: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<DateTime>',
      (tester) async {
        final widget = PopupMenuButton<DateTime>(
          itemBuilder: (context) => [
            PopupMenuItem(value: DateTime.now(), child: Text('Item 1')),
            PopupMenuItem(
              value: DateTime.now().add(Duration(days: 1)),
              child: Text('Item 2'),
            ),
          ],
          onSelected: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<Duration>',
      (tester) async {
        final widget = PopupMenuButton<Duration>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: Duration(seconds: 1),
              child: Text('Item 1'),
            ),
            PopupMenuItem(
              value: Duration(seconds: 2),
              child: Text('Item 2'),
            ),
          ],
          onSelected: (value) {},
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DropdownButtonSkeleton>());
        expect((skeleton as DropdownButtonSkeleton).baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DropdownButtonSkeleton para un PopupMenuButton<void>',
      (tester) async {
        final widget = PopupMenuButton<void>(
          itemBuilder: (context) => [
            PopupMenuItem(value: null, child: Text('Item 1')),
            PopupMenuItem(value: null, child: Text('Item 2')),
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
      'debería construir skeletons para widgets con múltiples hijos tipo Row',
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
    testWidgets(
      'debería construir skeletons para widgets con múltiples hijos tipo Column',
      (tester) async {
        final widget = Column(children: [Text('Texto 1'), Text('Texto 2')]);
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<Column>());
        final column = skeleton as Column;
        expect(column.children.length, 2);
        expect(column.children[0], isA<TextSkeleton>());
        expect(column.children[1], isA<TextSkeleton>());
      },
    );
    testWidgets(
      'debería construir skeletons para widgets con múltiples hijos tipo Wrap',
      (tester) async {
        final widget = Wrap(children: [Text('Texto 1'), Text('Texto 2')]);
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<Wrap>());
        final wrap = skeleton as Wrap;
        expect(wrap.children.length, 2);
        expect(wrap.children[0], isA<TextSkeleton>());
        expect(wrap.children[1], isA<TextSkeleton>());
      },
    );
    testWidgets(
      'debería construir skeletons para widgets con múltiples hijos tipo Flex',
      (tester) async {
        final widget = Flex(
          direction: Axis.horizontal,
          children: [Text('Texto 1'), Text('Texto 2')],
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<Flex>());
        final flex = skeleton as Flex;
        expect(flex.children.length, 2);
        expect(flex.children[0], isA<TextSkeleton>());
        expect(flex.children[1], isA<TextSkeleton>());
      },
    );

    testWidgets('debería construir skeleton para un Form', (tester) async {
      final widget = Form(child: TextField());
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<TextFieldSkeleton>());
      expect((skeleton as TextFieldSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir skeleton para un CircleAvatar', (
      tester,
    ) async {
      final widget = CircleAvatar(
        backgroundImage: NetworkImage('https://example.com/image.jpg'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<CircleAvatarSkeleton>());
      expect((skeleton as CircleAvatarSkeleton).baseColor, baseColor);
    });

    testWidgets(
      'debería construir DefaultSkeleton para un widget no registrado y sin múltiples hijos',
      (tester) async {
        final widget = InkWell(
          onTap: () {},
          child: Container(width: 100, height: 100, color: Colors.blue),
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DefaultSkeleton>());
        expect((skeleton as DefaultSkeleton).baseColor, baseColor);
        expect(skeleton.width, 100);
        expect(skeleton.height, 40);
      },
    );

    testWidgets(
      'debería construir TextSkeleton para un widget GestureDetector con child Text',
      (tester) async {
        final widget = GestureDetector(
          onTap: () {},
          child: Text('Hola Mundo'),
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<TextSkeleton>());
        expect((skeleton as TextSkeleton).text, 'Hola Mundo');
        expect(skeleton.baseColor, baseColor);
      },
    );
    testWidgets(
      'debería construir DefaultSkeleton para un widget GestureDetector sin child',
      (tester) async {
        final widget = GestureDetector(
          onTap: () {},
          child: null,
        );
        final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

        expect(skeleton, isA<DefaultSkeleton>());
        expect((skeleton as DefaultSkeleton).baseColor, baseColor);
        expect(skeleton.width, 100);
        expect(skeleton.height, 40);
      },
    );
  });
}
