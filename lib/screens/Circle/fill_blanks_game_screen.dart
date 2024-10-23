import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MarkovChain {
  final Map<String, List<String>> _chain = {};

  void train(List<String> words) {
    for (int i = 0; i < words.length - 1; i++) {
      if (!_chain.containsKey(words[i])) {
        _chain[words[i]] = [];
      }
      _chain[words[i]]!.add(words[i + 1]);
    }
  }

  String generateSentence(String startWord, int length) {
    String currentWord = startWord;
    StringBuffer sentence = StringBuffer(currentWord);
    Random random = Random();

    for (int i = 0; i < length - 1; i++) {
      if (_chain.containsKey(currentWord)) {
        List<String> nextWords = _chain[currentWord]!;
        currentWord = nextWords[random.nextInt(nextWords.length)];
        sentence.write(' $currentWord');
      }
    }
    return sentence.toString();
  }
}

class OneWordPuzzleGame extends StatefulWidget {
  const OneWordPuzzleGame({super.key});

  @override
  _OneWordPuzzleGameState createState() => _OneWordPuzzleGameState();
}

class _OneWordPuzzleGameState extends State<OneWordPuzzleGame> with SingleTickerProviderStateMixin {
  final List<String> _corpus = [
    "the",
    "cat",
    "sat",
    "on",
    "the",
    "mat",
    "the",
    "dog",
    "barked",
    "loudly",
    "the",
    "bird",
    "sang",
    "beautifully",
    "the",
    "mouse",
    "squeaked",
    "softly"
  ];

  final MarkovChain _markovChain = MarkovChain();
  String _sentence = '';
  String _missingWord = '';
  String _userInput = '';
  int _level = 1; // 1 for easy, 2 for medium, 3 for hard
  int _timerDuration = 30; // Initial timer duration
  late Timer _timer;
  int _remainingTime = 0;
  bool _isAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    _markovChain.train(_corpus);
    _generatePuzzle();
  }

  void _startTimer() {
    _remainingTime = _timerDuration;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        _showTimeOutDialog();
      }
    });
  }

  void _showTimeOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Time's Up!"),
          content: Text("The word was: $_missingWord"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextLevel();
              },
              child: Text("Next Level"),
            ),
          ],
        );
      },
    );
  }

  void _generatePuzzle() {
    int sentenceLength = 3 + _level; // Increase length with levels
    _sentence = _markovChain.generateSentence("the", sentenceLength);
    List<String> words = _sentence.split(' ');

    // Select a random word to replace
    int blankIndex = Random().nextInt(words.length);
    _missingWord = words[blankIndex];
    words[blankIndex] = '____'; // Replace with blank
    _sentence = words.join(' ');

    // Set timer duration based on level
    _timerDuration = 30 + (10 * _level); // Easy: 30s, Medium: 40s, Hard: 50s
    _startTimer(); // Start timer for the new puzzle
  }

  void _checkAnswer() {
    if (_userInput.toLowerCase() == _missingWord) {
      _isAnswerCorrect = true;
      _timer.cancel(); // Stop the timer
      _showCorrectDialog();
    } else {
      _isAnswerCorrect = false;
      _showIncorrectDialog();
    }
  }

  void _showCorrectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Correct!", style: TextStyle(color: Colors.green)),
            content: Text("The word was: $_missingWord"),
            actions: [
            TextButton(
            onPressed: () {
          Navigator.of(context).pop();
          _nextLevel(); // Go to the next level
        },
        child: Text("Next Level"),
            ),
      ],
    );
  },
  );
}

void _showIncorrectDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: Text("Incorrect!", style: TextStyle(color: Colors.red)),
          content: Text("Try again!"),
          actions: [
          TextButton(
          onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("OK"),
      ),
      ],
      );
    },
  );
}

void _nextLevel() {
  setState(() {
    _userInput = '';
    if (_level < 3) {
      _level++;
      _generatePuzzle();
    } else {
      // Reset game if max level reached
      _level = 1;
      _generatePuzzle();
    }
  });
}

void _onLevelChanged(int? value) {
  setState(() {
    _level = value ?? 1; // Update level based on dropdown selection
    _generatePuzzle(); // Generate a new puzzle
  });
}

@override
void dispose() {
  _timer.cancel(); // Cancel timer on dispose
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('One Word Puzzle Game'),
      backgroundColor: Colors.blueAccent,
    ),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'), // Add your background image here
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level selection dropdown
            DropdownButton<int>(
              value: _level,
              items: [
                DropdownMenuItem(value: 1, child: Text("Easy (30 sec)")),
                DropdownMenuItem(value: 2, child: Text("Medium (40 sec)")),
                DropdownMenuItem(value: 3, child: Text("Hard (50 sec)")),
              ],
              onChanged: _onLevelChanged,
            ),
            SizedBox(height: 20),
            Text(
              _sentence,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Time remaining: $_remainingTime seconds',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _userInput = value; // Update user input
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Fill in the blank',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text("Submit"),
            ),
            SizedBox(height: 20),
            Text(
              'Level: $_level',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow),
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
    debugShowCheckedModeBanner: false,
    home: OneWordPuzzleGame(),
  ));
}
