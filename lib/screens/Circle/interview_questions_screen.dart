import 'package:flutter/material.dart';

class InterviewQuestionsScreen extends StatelessWidget {
  final List<Map<String, String>> questionsAndAnswers = [
    {
      "question": "Tell me about yourself.",
      "answer": "Provide a brief summary of your background, skills, and experiences."
    },
    {
      "question": "What are your strengths?",
      "answer": "Mention a few strengths that are relevant to the job."
    },
    {
      "question": "What are your weaknesses?",
      "answer": "Discuss a weakness and how you are working to improve it."
    },
    {
      "question": "Why do you want to work here?",
      "answer": "Express your interest in the company and how it aligns with your career goals."
    },
    {
      "question": "Where do you see yourself in five years?",
      "answer": "Discuss your career aspirations and how you plan to achieve them."
    },
  ];

   InterviewQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interview Questions')),
      body: ListView.builder(
        itemCount: questionsAndAnswers.length,
        itemBuilder: (context, index) {
          return _buildQuestionCard(context, questionsAndAnswers[index]);
        },
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, Map<String, String> qa) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        title: Text(
          qa['question']!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              qa['answer']!,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
