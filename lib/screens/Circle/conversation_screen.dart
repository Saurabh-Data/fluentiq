import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversation')),
      body: Center(child: Text('Content for Conversation goes here.')),
    );
  }
}
