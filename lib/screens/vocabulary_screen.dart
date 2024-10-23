import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _vocabularyData;
  List<String> _synonyms = [];
  List<String> _antonyms = [];
  List<String> _suggestions = []; // List for suggestions
  bool _isLoading = false;
  String _error = '';

  final List<String> _motivationalQuotes = [
    "The more that you read, the more things you will know. The more that you learn, the more places you’ll go.",
    "Education is the most powerful weapon which you can use to change the world.",
    "Success is the sum of small efforts, repeated day in and day out.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "Don't watch the clock; do what it does. Keep going."
  ];

  String? _randomQuote;

  @override
  void initState() {
    super.initState();
    _randomQuote = _motivationalQuotes[_generateRandomIndex()];
  }

  int _generateRandomIndex() {
    return (DateTime
        .now()
        .microsecond % _motivationalQuotes.length);
  }

  Future<void> _fetchVocabulary(String word) async {
    setState(() {
      _isLoading = true;
      _error = '';
      _suggestions.clear(); // Clear previous suggestions
    });

    try {
      final response = await http.get(
          Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> meanings = [];
        for (var entry in data[0]['meanings']) {
          for (var def in entry['definitions']) {
            meanings.add(def['definition']);
          }
        }

        final synonymsResponse = await http.get(
            Uri.parse('https://api.datamuse.com/words?ml=$word&max=5'));
        final antonymsResponse = await http.get(
            Uri.parse('https://api.datamuse.com/words?rel_ant=$word&max=5'));

        if (synonymsResponse.statusCode == 200) {
          final synonymsData = json.decode(synonymsResponse.body);
          _synonyms =
          List<String>.from(synonymsData.map((item) => item['word']));
        }

        if (antonymsResponse.statusCode == 200) {
          final antonymsData = json.decode(antonymsResponse.body);
          _antonyms =
          List<String>.from(antonymsData.map((item) => item['word']));
        }

        setState(() {
          _vocabularyData = {'meanings': meanings};
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to fetch data. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'An error occurred. Please check your internet connection.';
      });
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) return;

    try {
      final response = await http.get(
          Uri.parse('https://api.datamuse.com/sug?s=$query'));

      if (response.statusCode == 200) {
        final suggestionsData = json.decode(response.body);
        setState(() {
          _suggestions =
          List<String>.from(suggestionsData.map((item) => item['word']));
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch suggestions.';
      });
    }
  }

  void _onSuggestionTapped(String suggestion) {
    _controller.text = suggestion;
    _fetchVocabulary(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary Explorer'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade100, Colors.teal.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter a word',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String word = _controller.text.trim();
                      if (word.isNotEmpty) {
                        _fetchVocabulary(word);
                      }
                    },
                  ),
                ),
                onChanged: (value) {
                  _fetchSuggestions(value);
                },
              ),
              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _randomQuote ?? '',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),

              if (_isLoading) CircularProgressIndicator(),

              if (_error.isNotEmpty)
                SnackBar(
                  content: Text(_error, style: TextStyle(color: Colors.red)),
                  backgroundColor: Colors.white,
                ),

              if (_vocabularyData != null) ...[
                _buildVocabularyColumn(
                    'Meanings', _vocabularyData!['meanings']),
                _buildCombinedColumn('Synonyms', _synonyms),
                _buildCombinedColumn('Antonyms', _antonyms),
              ],

              if (_suggestions.isNotEmpty) ...[
                _buildSuggestionsColumn('Suggestions', _suggestions),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVocabularyColumn(String title, List<String> data) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: 150,
            child: data.isNotEmpty
                ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]),
                );
              },
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('No $title available'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedColumn(String title, List<String> data) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data.isNotEmpty ? data.join(', ') : 'No $title available',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsColumn(String title, List<String> suggestions) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
          ),
          Divider(),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: suggestions.map((suggestion) {
              return GestureDetector(
                onTap: () => _onSuggestionTapped(suggestion), // Handle tap here
                child: Chip(
                  label: Text(suggestion),
                  backgroundColor: Colors.teal.shade100,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
