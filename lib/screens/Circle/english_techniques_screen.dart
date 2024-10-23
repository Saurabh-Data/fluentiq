import 'package:flutter/material.dart';

class EnglishTechniquesScreen extends StatelessWidget {
  final List<Map<String, String>> techniques = [
    {
      'title': '1. Practice Speaking',
      'description': 'Speak English with friends, family, or practice alone. The more you speak, the more fluent you become.'
    },
    {
      'title': '2. Learn 5 New Words Daily',
      'description': 'Write down 5 new words each day and use them in sentences. This will expand your vocabulary quickly.'
    },
    {
      'title': '3. Listen to English Audio',
      'description': 'Watch English shows, listen to podcasts, or music to understand natural English speaking.'
    },
    {
      'title': '4. Read Books and Articles',
      'description': 'Start with simple English books, news, or blog articles. It helps improve vocabulary and sentence structure.'
    },
    {
      'title': '5. Keep a Diary in English',
      'description': 'Write about your day in English. This improves writing and helps you express your thoughts better.'
    },
    {
      'title': '6. Learn Basic Grammar',
      'description': 'Focus on simple grammar rules like tenses, verbs, and sentence structures to build a strong foundation.'
    },
    {
      'title': '7. Use Flashcards for Vocabulary',
      'description': 'Create flashcards for new words with their meanings and examples. It helps with memorization.'
    },
    {
      'title': '8. Watch English Movies with Subtitles',
      'description': 'Watch movies with English subtitles to learn sentence formation and pronunciation.'
    },
    {
      'title': '9. Practice Pronunciation',
      'description': 'Use FluentIQ videos to improve your English pronunciation by repeating after native speakers.'
    },
    {
      'title': '10. Join an English Discussion Group',
      'description': 'Join a group where you can discuss topics in English. This helps with speaking confidence.'
    },
    {
      'title': '11. Learn Common Idioms',
      'description': 'Idioms are phrases that don’t have literal meanings. Learn common ones to sound more natural in conversations.'
    },
    {
      'title': '12. Take English Quizzes',
      'description': 'Test your knowledge by taking quizzes to check your grammar and vocabulary progress.'
    },
    {
      'title': '13. Read Aloud Daily',
      'description': 'Reading aloud helps you improve fluency, pronunciation, and sentence structure.'
    },
    {
      'title': '14. Record Yourself Speaking',
      'description': 'Record your voice and listen to it. This helps you correct mistakes in pronunciation and grammar.'
    },
    {
      'title': '15. Learn English Through Games',
      'description': 'Play FluentIQ word games like crosswords or scrabble to have fun while expanding your vocabulary.'
    },
  ];

   EnglishTechniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('English Techniques')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Roadmap Section
          Card(
            margin: EdgeInsets.only(bottom: 16.0),
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'English Learning Roadmap',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Start with basic grammar and vocabulary.\n'
                        '2. Practice speaking and listening regularly.\n'
                        '3. Improve reading and writing skills.\n'
                        '4. Learn advanced grammar and techniques.\n'
                        '5. Engage in conversations and discussions.\n'
                        '6. Keep testing yourself and take quizzes.\n'
                        '7. Aim for fluency by consistent practice.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // Techniques Section
          ...techniques.map((technique) {
            return Card(
              margin: EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                title: Text(
                  technique['title']!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    technique['description']!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
