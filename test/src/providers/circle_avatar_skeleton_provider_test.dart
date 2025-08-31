import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton_loader/src/providers/circle_avatar_skeleton_provider.dart';
import 'package:flutter_skeleton_loader/src/widgets/skeletons/circle_avatar_skeleton.dart';

void main() {
  group('CircleAvatarSkeletonProvider', () {
    late CircleAvatarSkeletonProvider provider;
    const baseColor = Color(0xFFE0E0E0);

    setUp(() {
      provider = CircleAvatarSkeletonProvider();
    });

    group('canHandle', () {
      test('Debería devolver verdadero para el widget CircleAvatar', () {
        const avatarWidget = CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue,
        );

        expect(provider.canHandle(avatarWidget), isTrue);
      });

      test(
          'Debería devolver verdadero para CircleAvatar con radio predeterminado',
          () {
        const avatarWidget = CircleAvatar();

        expect(provider.canHandle(avatarWidget), isTrue);
      });

      test('Debería devolver verdadero para CircleAvatar con backgroundImage',
          () {
        const avatarWidget = CircleAvatar(
          backgroundImage: NetworkImage('https://example.com/image.jpg'),
        );

        expect(provider.canHandle(avatarWidget), isTrue);
      });

      test('Debería devolver verdadero para CircleAvatar con child', () {
        const avatarWidget = CircleAvatar(
          child: Icon(Icons.person),
        );

        expect(provider.canHandle(avatarWidget), isTrue);
      });

      test(
          'Debería devolver verdadero para CircleAvatar con propiedades personalizadas',
          () {
        final avatarWidget = CircleAvatar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minRadius: 10,
          maxRadius: 50,
          child: const Text('AB'),
        );

        expect(provider.canHandle(avatarWidget), isTrue);
      });

      test('Debería devolver falso para widgets que no son CircleAvatar', () {
        const textWidget = Text('Not an avatar');
        final containerWidget = Container();
        const iconWidget = Icon(Icons.person);

        expect(provider.canHandle(textWidget), isFalse);
        expect(provider.canHandle(containerWidget), isFalse);
        expect(provider.canHandle(iconWidget), isFalse);
      });
    });

    group('prioridad', () {
      test('Debería devolver prioridad 7', () {
        expect(provider.priority, 7);
      });
    });

    group('createSkeleton', () {
      testWidgets('Debería crear CircleAvatarSkeleton para CircleAvatar básico',
          (tester) async {
        const avatarWidget = CircleAvatar(radius: 25);

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        expect(skeleton, isA<CircleAvatarSkeleton>());

        final avatarSkeleton = skeleton as CircleAvatarSkeleton;
        expect(avatarSkeleton.baseColor, baseColor);
        expect(avatarSkeleton.radius, 25.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(CircleAvatarSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear CircleAvatarSkeleton con radio predeterminado cuando no se especifica',
          (tester) async {
        const avatarWidget = CircleAvatar();

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        expect(skeleton, isA<CircleAvatarSkeleton>());

        final avatarSkeleton = skeleton as CircleAvatarSkeleton;
        expect(avatarSkeleton.baseColor, baseColor);
        expect(avatarSkeleton.radius, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 20.0);
        expect(size.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería crear CircleAvatarSkeleton con dimensiones correctas',
          (tester) async {
        const avatarWidget = CircleAvatar(radius: 30);

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        expect(containerWidget.constraints, isNotNull);

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 30.0);
        expect(size.height, 30.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear CircleAvatarSkeleton con el color correcto',
          (tester) async {
        const customColor = Colors.blue;
        const avatarWidget = CircleAvatar(
          radius: 20,
          backgroundColor: Colors.red,
        );

        final skeleton = provider.createSkeleton(avatarWidget, customColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, customColor);
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería crear CircleAvatarSkeleton con forma circular',
          (tester) async {
        const avatarWidget = CircleAvatar(radius: 25);

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.shape, BoxShape.circle);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar CircleAvatar con backgroundImage',
          (tester) async {
        const avatarWidget = CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://example.com/image.jpg'),
        );

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        expect(skeleton, isA<CircleAvatarSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.image, isNull);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar CircleAvatar con widget hijo',
          (tester) async {
        const avatarWidget = CircleAvatar(
          radius: 30,
          child: Icon(Icons.person),
        );

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        expect(skeleton, isA<CircleAvatarSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(Icon), findsNothing);
        expect(find.byType(CircleAvatarSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar CircleAvatar con colores personalizados',
          (tester) async {
        const avatarWidget = CircleAvatar(
          radius: 20,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        );

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        expect(skeleton, isA<CircleAvatarSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar CircleAvatar con minRadius y maxRadius',
          (tester) async {
        final avatarWidget = CircleAvatar(
          minRadius: 10,
          maxRadius: 50,
        );

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        expect(skeleton, isA<CircleAvatarSkeleton>());

        final avatarSkeleton = skeleton as CircleAvatarSkeleton;
        expect(avatarSkeleton.radius, 20.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 20.0);
        expect(size.height, 20.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar diferentes tamaños de radio',
          (tester) async {
        final testCases = [
          {'radius': 10.0, 'expected': 10.0},
          {'radius': 15.0, 'expected': 15.0},
          {'radius': 40.0, 'expected': 40.0},
          {'radius': 50.0, 'expected': 50.0},
        ];

        for (final testCase in testCases) {
          final radius = testCase['radius'] as double;
          final expected = testCase['expected'] as double;

          final avatarWidget = CircleAvatar(radius: radius);
          final skeleton = provider.createSkeleton(avatarWidget, baseColor);

          expect(skeleton, isA<CircleAvatarSkeleton>());

          final avatarSkeleton = skeleton as CircleAvatarSkeleton;
          expect(avatarSkeleton.radius, expected);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: skeleton),
            ),
          );

          final size = tester.getSize(find.byType(Container));
          expect(size.width, expected);
          expect(size.height, expected);

          await tester.pumpWidget(Container());
        }

        expect(tester.takeException(), isNull);
      });
    });

    group('sanitización de dimensiones', () {
      testWidgets('Debería usar dimensiones sanitizadas', (tester) async {
        const avatarWidget = CircleAvatar(radius: 25);

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);
        final avatarSkeleton = skeleton as CircleAvatarSkeleton;

        expect(avatarSkeleton.radius, 25.0);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final size = tester.getSize(find.byType(Container));
        expect(size.width, 25.0);
        expect(size.height, 25.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar el radio cero con un valor predeterminado',
          (tester) async {
        const avatarWidget = CircleAvatar(radius: 0);

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);
        final avatarSkeleton = skeleton as CircleAvatarSkeleton;

        expect(avatarSkeleton.radius, isNotNull);
        expect(avatarSkeleton.radius! >= 0, isTrue);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });

    group('herencia y cumplimiento de interfaces', () {
      test('Debería extender BaseSkeletonProvider', () {
        expect(provider, isA<CircleAvatarSkeletonProvider>());
      });

      test('Debería implementar métodos requeridos', () {
        expect(() => provider.canHandle(const Text('test')), returnsNormally);
        expect(() => provider.priority, returnsNormally);
        expect(() => provider.createSkeleton(const CircleAvatar(), baseColor),
            returnsNormally);
      });
    });

    group('casos límite', () {
      testWidgets('Debería manejar un radio muy pequeño', (tester) async {
        const avatarWidget = CircleAvatar(radius: 1);

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(CircleAvatarSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar un radio muy grande', (tester) async {
        const avatarWidget = CircleAvatar(radius: 100);

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(CircleAvatarSkeleton), findsOneWidget);
        final size = tester.getSize(find.byType(Container));
        expect(size.width, 100.0);
        expect(size.height, 100.0);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar un color de fondo muy oscuro',
          (tester) async {
        const darkColor = Color(0xFF000000);
        const avatarWidget = CircleAvatar(radius: 20);

        final skeleton = provider.createSkeleton(avatarWidget, darkColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, darkColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar un color de fondo muy claro',
          (tester) async {
        const lightColor = Color(0xFFFFFFFF);
        const avatarWidget = CircleAvatar(radius: 15);

        final skeleton = provider.createSkeleton(avatarWidget, lightColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, lightColor);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Debería manejar CircleAvatar con un widget hijo complejo',
          (tester) async {
        final avatarWidget = CircleAvatar(
          radius: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.person),
              Text('AB'),
            ],
          ),
        );

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        expect(skeleton, isA<CircleAvatarSkeleton>());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.byType(Column), findsNothing);
        expect(find.byType(Icon), findsNothing);
        expect(find.text('AB'), findsNothing);
        expect(find.byType(CircleAvatarSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('escenarios específicos de CircleAvatar', () {
      testWidgets('Debería manejar CircleAvatar utilizado como foto de perfil',
          (tester) async {
        const avatarWidget = CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/profile.jpg'),
          backgroundColor: Colors.grey,
        );

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        final containerWidget =
            tester.widget<Container>(find.byType(Container));
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, baseColor);
        expect(decoration.shape, BoxShape.circle);
        expect(decoration.image, isNull);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'Debería manejar CircleAvatar utilizado como visualización de iniciales',
          (tester) async {
        const avatarWidget = CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: Text('JD', style: TextStyle(color: Colors.white)),
        );

        final skeleton = provider.createSkeleton(avatarWidget, baseColor);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: skeleton),
          ),
        );

        expect(find.text('JD'), findsNothing);
        expect(find.byType(CircleAvatarSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
