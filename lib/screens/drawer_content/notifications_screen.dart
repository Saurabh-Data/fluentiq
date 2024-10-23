import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Latest Notifications!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Example notification list
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5, // Replace with actual notification count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Notification ${index + 1}'),
                  subtitle: Text('Details of notification ${index + 1}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
