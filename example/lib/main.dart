import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Skeleton Loader',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.delay = const Duration(seconds: 1)});
  final Duration delay;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;

  Future<void> _removeSkeleton() async {
    await Future.delayed(widget.delay);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _removeSkeleton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SkeletonLoader(
          isLoading: isLoading,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              Text(
                key: const Key('text_example'),
                'Hello, World!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Image.asset(
                key: const Key('image_example'),
                'assets/150x150.png',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
              Container(
                key: const Key('container_example'),
                padding: const EdgeInsets.all(16.0),
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue, width: 2.0),
                ),
              ),
              Icon(
                key: const Key('icon_example'),
                Icons.flutter_dash,
                size: 100,
                color: Colors.blue,
              ),
              ElevatedButton(
                key: const Key('button_example'),
                onPressed: () {},
                child: const Text('Click Me!'),
              ),
              CircleAvatar(
                key: const Key('avatar_example'),
                radius: 50,
                backgroundImage: AssetImage('assets/150x150.png'),
              ),
              Checkbox(
                key: const Key('checkbox_example'),
                value: true,
                onChanged: (value) {},
              ),
              Radio(
                key: const Key('radio_example'),
                value: 1,
                groupValue: 1,
                onChanged: (value) {},
              ),
              Switch(
                key: const Key('switch_example'),
                value: true,
                onChanged: (value) {},
              ),
              Slider(
                key: const Key('slider_example'),
                value: 0.5,
                onChanged: (value) {},
                min: 0,
                max: 1,
              ),
              DropdownButton(
                key: const Key('dropdown_example'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Option 1')),
                  DropdownMenuItem(value: 2, child: Text('Option 2')),
                ],
                onChanged: (value) {},
                hint: const Text('Select an option'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
