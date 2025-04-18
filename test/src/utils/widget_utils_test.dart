import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/utils/widget_utils.dart';

void main() {
  group('WidgetUtils', () {
    group('getItemCount', () {
      test(
        'debería retornar 5 para ListView con SliverChildBuilderDelegate sin estimatedChildCount',
        () {
          final widget = ListView.builder(
            itemCount: null,
            itemBuilder:
                (context, index) => ListTile(title: Text('Item $index')),
          );

          expect(WidgetUtils.getItemCount(widget), 5);
        },
      );

      test(
        'debería retornar el estimatedChildCount para ListView con SliverChildBuilderDelegate',
        () {
          final widget = ListView.builder(
            itemCount: 10,
            itemBuilder:
                (context, index) => ListTile(title: Text('Item $index')),
          );

          expect(WidgetUtils.getItemCount(widget), 10);
        },
      );

      test(
        'debería retornar la longitud de children para ListView con SliverChildListDelegate',
        () {
          final widget = ListView(
            children: [
              ListTile(title: Text('Item 1')),
              ListTile(title: Text('Item 2')),
              ListTile(title: Text('Item 3')),
            ],
          );

          expect(WidgetUtils.getItemCount(widget), 3);
        },
      );

      test(
        'debería retornar 3 para PageView con SliverChildBuilderDelegate sin estimatedChildCount',
        () {
          final widget = PageView.builder(
            itemCount: null,
            itemBuilder: (context, index) => Container(),
          );

          expect(WidgetUtils.getItemCount(widget), 3);
        },
      );

      test(
        'debería retornar el estimatedChildCount para PageView con SliverChildBuilderDelegate',
        () {
          final widget = PageView.builder(
            itemCount: 4,
            itemBuilder: (context, index) => Container(),
          );

          expect(WidgetUtils.getItemCount(widget), 4);
        },
      );

      test(
        'debería retornar la longitud de children para PageView con SliverChildListDelegate',
        () {
          final widget = PageView(
            children: [
              Container(),
              Container(),
              Container(),
              Container(),
              Container(),
            ],
          );

          expect(WidgetUtils.getItemCount(widget), 5);
        },
      );

      test('debería retornar la longitud de children para Column', () {
        final widget = Column(
          children: [
            Text('Item 1'),
            Text('Item 2'),
            Text('Item 3'),
            Text('Item 4'),
          ],
        );

        expect(WidgetUtils.getItemCount(widget), 4);
      });

      test('debería retornar la longitud de children para Row', () {
        final widget = Row(
          children: [
            Icon(Icons.star),
            Icon(Icons.favorite),
            Icon(Icons.thumb_up),
          ],
        );

        expect(WidgetUtils.getItemCount(widget), 3);
      });

      test('debería retornar la longitud de children para Wrap', () {
        final widget = Wrap(
          children: [
            Chip(label: Text('Tag 1')),
            Chip(label: Text('Tag 2')),
            Chip(label: Text('Tag 3')),
            Chip(label: Text('Tag 4')),
            Chip(label: Text('Tag 5')),
          ],
        );

        expect(WidgetUtils.getItemCount(widget), 5);
      });

      test('debería retornar 5 para un widget no soportado', () {
        final widget = Text('No soportado');

        expect(WidgetUtils.getItemCount(widget), 5);
      });
    });
  });
}
