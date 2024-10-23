import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../../models/word_model.dart'; // Import the WordModel

class WordGame extends StatefulWidget {
  const WordGame({super.key});

  @override
  _WordGameState createState() => _WordGameState();
}

class _WordGameState extends State<WordGame> {
  List<WordModel> words = [];
  String currentWord = '';
  String currentDefinition = '';
  String userGuess = '';
  int score = 0;
  int incorrect = 0;
  int questionCount = 0;
  String selectedLevel = 'easy'; // Default level
  List<Map<String, String>> questionsAndAnswers = []; // Stores word, definition, and user's guess
  List<String> usedWords = []; // Tracks words already used in the current game

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    List<WordModel> fetchedWords = [];

    // Difficulty levels word lists
    Map<String, List<String>> wordLists = {
      'easy': ['Cat', 'Dog', 'House', 'Tree', 'Book', 'Chair', 'Car', 'Apple', 'Pen', 'Table'],
      'medium': ['Aberration', 'Benevolent', 'Cacophony', 'Debilitate', 'Ebullient', 'Fickle', 'Gregarious', 'Hapless', 'Idyllic', 'Jubilant'],
      'hard': ['Recalcitrant', 'Obfuscate', 'Pusillanimous', 'Quixotic', 'Sesquipedalian', 'Ubiquitous', 'Vicissitude', 'Zephyr', 'Wanderlust', 'Yonder']
    };

    List<String>? wordList = wordLists[selectedLevel] ?? wordLists['easy'];

    // Shuffle the word list to randomize words each time
    wordList?.shuffle();

    for (String word in wordList!) {
      if (!usedWords.contains(word)) {
        final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          fetchedWords.add(WordModel.fromJson(jsonData[0]));
          usedWords.add(word); // Mark word as used
          if (fetchedWords.length == 5) break; // Stop once we have 5 words
        } else {
          throw Exception('Failed to load word');
        }
      }
    }

    setState(() {
      words = fetchedWords;
      _newWord(); // Set a new word once fetched
    });
  }

  void _newWord() {
    if (words.isNotEmpty) {
      final random = Random();
      final wordEntry = words.removeAt(random.nextInt(words.length));
      setState(() {
        currentWord = wordEntry.word;
        currentDefinition = wordEntry.definition;
        userGuess = '';
      });
    }
  }

  void _checkGuess() {
    // Store the user's guess, actual word, and definition
    questionsAndAnswers.add({
      'word': currentWord,
      'definition': currentDefinition,
      'userGuess': userGuess,
    });

    if (userGuess.toLowerCase() == currentWord.toLowerCase()) {
      score++;
    } else {
      incorrect++;
    }

    questionCount++;

    if (questionCount >= 5) {
      _showScoreSummary();
    } else {
      _newWord();
    }
  }

  void _showScoreSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You got $score correct and $incorrect incorrect.'),
              SizedBox(height: 10),
              Text('Correct Meanings:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...questionsAndAnswers.map((qa) {
                return ListTile(
                  title: Text('Word: ${qa['word']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Definition: ${qa['definition']}'),
                      Text('Your Guess: ${qa['userGuess']}'),
                    ],
                  ),
                );
              }),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      score = 0;
      incorrect = 0;
      questionCount = 0;
      usedWords.clear(); // Clear previous used words
      questionsAndAnswers.clear(); // Clear previous round's data
      _fetchWords(); // Fetch a new set of words
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Word Game')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Level selection
            DropdownButton<String>(
              value: selectedLevel,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLevel = newValue!;
                  _restartGame(); // Fetch new words based on level and start a new game
                });
              },
              items: <String>['easy', 'medium', 'hard'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value[0].toUpperCase() + value.substring(1)), // Capitalize level name
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Guess the word based on the definition:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              currentDefinition,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  userGuess = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Guess',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGuess,
              child: Text('Submit Guess'),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
