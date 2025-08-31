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

      expect(skeleton, isA<Card>());
      expect((skeleton as Card).child, isA<ContainerSkeleton>());
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

        expect(skeleton, isA<IntrinsicHeight>());
        final intrinsicHeight = skeleton as IntrinsicHeight;
        expect(intrinsicHeight.child, isA<Row>());
        final row = intrinsicHeight.child as Row;
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

        expect(skeleton, isA<IntrinsicWidth>());
        final intrinsicWidth = skeleton as IntrinsicWidth;
        expect(intrinsicWidth.child, isA<Column>());
        final column = intrinsicWidth.child as Column;
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

    // Tests para Expanded widgets
    testWidgets('debería construir Expanded con skeleton del child', (
      tester,
    ) async {
      final widget = Expanded(
        flex: 2,
        child: Text('Expanded Text'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Expanded>());
      final expanded = skeleton as Expanded;
      expect(expanded.flex, 2);
      expect(expanded.child, isA<TextSkeleton>());
      expect((expanded.child as TextSkeleton).text, 'Expanded Text');
      expect((expanded.child as TextSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir Expanded con flex por defecto', (
      tester,
    ) async {
      final widget = Expanded(
        child: Container(width: 100, height: 50),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Expanded>());
      final expanded = skeleton as Expanded;
      expect(expanded.flex, 1); // valor por defecto
      expect(expanded.child, isA<ContainerSkeleton>());
    });

    // Tests para Flexible widgets
    testWidgets('debería construir Flexible con skeleton del child', (
      tester,
    ) async {
      final widget = Flexible(
        flex: 3,
        fit: FlexFit.loose,
        child: Icon(Icons.star),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Flexible>());
      final flexible = skeleton as Flexible;
      expect(flexible.flex, 3);
      expect(flexible.fit, FlexFit.loose);
      expect(flexible.child, isA<IconSkeleton>());
      expect((flexible.child as IconSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir Flexible con valores por defecto', (
      tester,
    ) async {
      final widget = Flexible(
        child: Text('Flexible Text'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Flexible>());
      final flexible = skeleton as Flexible;
      expect(flexible.flex, 1); // valor por defecto
      expect(flexible.fit, FlexFit.loose); // valor por defecto
      expect(flexible.child, isA<TextSkeleton>());
    });

    // Tests para Padding widgets
    testWidgets('debería construir Padding con skeleton del child', (
      tester,
    ) async {
      final widget = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Padded Text'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Padding>());
      final padding = skeleton as Padding;
      expect(padding.padding, const EdgeInsets.all(16.0));
      expect(padding.child, isA<TextSkeleton>());
      expect((padding.child as TextSkeleton).text, 'Padded Text');
      expect((padding.child as TextSkeleton).baseColor, baseColor);
    });

    testWidgets('debería construir Padding sin child con DefaultSkeleton', (
      tester,
    ) async {
      final widget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: null,
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Padding>());
      final padding = skeleton as Padding;
      expect(padding.padding,
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0));
      expect(padding.child, isA<DefaultSkeleton>());
      expect((padding.child as DefaultSkeleton).baseColor, baseColor);
      expect((padding.child as DefaultSkeleton).width, 100);
      expect((padding.child as DefaultSkeleton).height, 40);
    });

    testWidgets('debería construir Padding con diferentes tipos de padding', (
      tester,
    ) async {
      final widget = Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
        child: Icon(Icons.home),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Padding>());
      final padding = skeleton as Padding;
      expect(padding.padding, const EdgeInsets.only(top: 12.0, bottom: 8.0));
      expect(padding.child, isA<IconSkeleton>());
    });

    // Tests para Container con child
    testWidgets('debería construir Container con skeleton del child', (
      tester,
    ) async {
      final widget = Container(
        width: 200,
        height: 150,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text('Container Text'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Container>());
      final container = skeleton as Container;
      expect(container.margin, const EdgeInsets.all(8.0));
      expect(container.padding, const EdgeInsets.all(12.0));
      expect(container.decoration, isA<BoxDecoration>());
      expect(container.child, isA<TextSkeleton>());
      expect((container.child as TextSkeleton).text, 'Container Text');
    });

    testWidgets('debería construir Container con constraints y child', (
      tester,
    ) async {
      final widget = Container(
        constraints: const BoxConstraints(
          minWidth: 100,
          maxWidth: 300,
          minHeight: 50,
          maxHeight: 200,
        ),
        child: Icon(Icons.favorite),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Container>());
      final container = skeleton as Container;
      expect(container.constraints, isA<BoxConstraints>());
      expect(container.constraints!.maxWidth, 300);
      expect(container.constraints!.maxHeight, 200);
      expect(container.child, isA<IconSkeleton>());
    });

    testWidgets('debería construir Container con child complejo', (
      tester,
    ) async {
      final widget = Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text('Title'),
            Icon(Icons.star),
          ],
        ),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Container>());
      final container = skeleton as Container;
      expect(container.padding, const EdgeInsets.all(16.0));
      expect(container.child, isA<IntrinsicWidth>());

      // Verificar que el Column interno tiene los skeletons correctos
      final intrinsicWidth = container.child as IntrinsicWidth;
      expect(intrinsicWidth.child, isA<Column>());
      final column = intrinsicWidth.child as Column;
      expect(column.children.length, 2);
      expect(column.children[0], isA<TextSkeleton>());
      expect(column.children[1], isA<IconSkeleton>());
    });

    testWidgets('debería preservar todas las propiedades del Container', (
      tester,
    ) async {
      final widget = Container(
        width: 250,
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        constraints: const BoxConstraints(
          minWidth: 200,
          maxWidth: 400,
        ),
        child: Text('Complex Container'),
      );
      final skeleton = SkeletonRegistry.buildSkeleton(widget, baseColor);

      expect(skeleton, isA<Container>());
      final container = skeleton as Container;

      // Verificar que se preservan las propiedades del Container original
      expect(container.margin, const EdgeInsets.symmetric(horizontal: 16.0));
      expect(container.padding, const EdgeInsets.symmetric(vertical: 8.0));
      expect(container.decoration, equals(widget.decoration));
      expect(container.constraints, equals(widget.constraints));
      expect(container.child, isA<TextSkeleton>());
    });
  });
}
