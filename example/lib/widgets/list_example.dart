import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/skeleton_loader.dart';

class ListExample extends StatelessWidget {
  final bool isLoading;
  const ListExample({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Lista con Skeleton',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: SkeletonLoader(
            isLoading: isLoading,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('Elemento ${index + 1}'),
                  subtitle: Text('Descripción del elemento ${index + 1}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: SkeletonLoader(
            isLoading: isLoading,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(
                      'Elemento ${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
