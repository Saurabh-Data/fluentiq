import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<Map<String, dynamic>> _stories = []; // Use dynamic for mixed types
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateDailyStories();
    _startDailyStoryRefresh();
  }

  void _generateDailyStories() {
    List<String> baseWords = [
      'adventure', 'ocean', 'forest', 'mountain', 'river', 'desert',
      'castle', 'dragon', 'hero', 'journey', 'friendship', 'magic',
      'whisper', 'explore', 'dream', 'wonder', 'brave', 'treasure',
      'mysterious', 'ancient', 'enchanting', 'colorful', 'beautiful',
      'joyful', 'happy', 'sad', 'excited', 'scared', 'curious',
      'determined', 'dolphin', 'tiger', 'monkey', 'elephant', 'rabbit',
      'sun', 'moon', 'star', 'cloud', 'flower', 'bird', 'wind',
      'tree', 'path', 'journey', 'home', 'happiness', 'freedom',
      'story', 'imagination', 'dreamer', 'adventure', 'kindness',
      'bravery', 'challenge', 'victory', 'journey', 'friend',
      'whimsy', 'creativity', 'exploration', 'inspiration',
      'magic', 'friendship', 'wonder', 'joy', 'love'
    ];


    _stories = List.generate(5, (index) {
      String story = _markovStoryGenerator(baseWords);
      String summary = _generateSummary(story);
      return {'story': story, 'summary': summary, 'isExpanded': false}; // Ensure it is dynamic
    });
  }

  String _markovStoryGenerator(List<String> baseWords) {
    Random random = Random();
    int length = random.nextInt(200) + 400; // Each story will have 400-600 words
    StringBuffer story = StringBuffer();

    for (int i = 0; i < length; i++) {
      String word = baseWords[random.nextInt(baseWords.length)];
      story.write('$word ');
    }
    return story.toString().trim();
  }

  String _generateSummary(String story) {
    // Return the first 50 words as a summary for simplicity
    List<String> words = story.split(' ');
    return words.take(50).join(' ') + (words.length > 50 ? '...' : '');
  }

  void _startDailyStoryRefresh() {
    _timer = Timer.periodic(Duration(hours: 24), (timer) {
      _generateDailyStories(); // Refresh the stories every 24 hours
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleExpand(int index) {
    setState(() {
      // Toggle the expansion state of the story
      _stories[index]['isExpanded'] = !_stories[index]['isExpanded']; // Explicit casting to bool
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Stories'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '🌟 Improve Your English 🌟\n'
                      'Enhance your vocabulary and comprehension skills by reading these engaging stories tailored for you.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(_stories.length, (index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleExpand(index),
                                child: Text(
                                  'Story ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _toggleExpand(index), // Make summary clickable
                                child: Text(
                                  _stories[index]['summary']!,
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              if (_stories[index]['isExpanded'] as bool)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _stories[index]['story']!,
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StoryScreen(),
  ));
}
