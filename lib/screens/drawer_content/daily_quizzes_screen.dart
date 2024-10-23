import 'package:flutter/material.dart';

class DailyQuizzesScreen extends StatelessWidget {
  const DailyQuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quizzes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Daily Quizzes!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to access quizzes
              },
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
