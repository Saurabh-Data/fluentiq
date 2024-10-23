import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Articles', 'icon': Icons.article},
    {'title': 'Quick Revision', 'icon': Icons.refresh},
    {'title': 'Forum', 'icon': Icons.forum},
    {'title': 'Twisters', 'icon': Icons.language},
    {'title': 'Grammar', 'icon': Icons.book},
  ];

 TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Fluentiq'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryIcon(
                title: categories[index]['title'],
                icon: categories[index]['icon'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryIcon({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[100],
            ),
            child: Icon(
              icon,
              size: 30.0,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
