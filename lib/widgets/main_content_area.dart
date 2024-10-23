import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          VocabularySection(),
          DailyStoryDisplay(),
          BottomSections(),
        ],
      ),
    );
  }
}

class VocabularySection extends StatelessWidget {
  const VocabularySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vocabulary',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Synonyms, Antonyms, Word Meanings...',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class DailyStoryDisplay extends StatelessWidget {
  const DailyStoryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Story',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Once upon a time...',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class BottomSections extends StatelessWidget {
  const BottomSections({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        VideoLecturesSection(),
        QuizzesSection(),
        //PDFMaterialsSection(),
      ],
    );
  }
}

class VideoLecturesSection extends StatelessWidget {
  const VideoLecturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Lectures',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Watch video lectures to enhance your learning.',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class QuizzesSection extends StatelessWidget {
  const QuizzesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quizzes',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Take daily quizzes to test your knowledge.',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

