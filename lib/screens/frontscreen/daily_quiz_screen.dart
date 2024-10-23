import 'package:flutter/material.dart';


class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key});

  @override
  _DailyQuizScreenState createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen> {
  final String _paragraph =
      "Learning English is essential in today's globalized world. It opens doors to numerous opportunities and enhances one's ability to communicate with people from diverse backgrounds. Mastering English can significantly improve your career prospects as many multinational companies require employees who can speak and write in English fluently. In addition to professional benefits, learning English allows you to explore rich literary works, including classic novels, poetry, and modern literature. These texts often carry cultural significance and provide insights into the English-speaking world. Furthermore, being proficient in English enables you to enjoy movies, music, and television shows in their original language, which can enhance your understanding and appreciation of the art form. English is also the primary language of the internet. Most online content, including articles, tutorials, and social media, is in English. By learning the language, you gain access to a vast amount of information and resources available online. You can connect with people globally, share your ideas, and participate in discussions that transcend geographical boundaries. In educational settings, English is often the medium of instruction in many countries. Being proficient in English allows students to excel academically, as they can understand the curriculum better and engage with international research. Additionally, learning English is an ongoing process that requires practice and exposure. It’s important to read widely, listen to various forms of media, and engage in conversations with native speakers. Immersing yourself in the language will help you develop your vocabulary and improve your pronunciation. To summarize, learning English is not just about acquiring a new skill; it’s about opening yourself up to a world of opportunities, enriching your life experiences, and becoming a part of a global community.";

  List<Map<String, dynamic>> _quizQuestions = [];
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  final List<bool> _answeredCorrectly = [];
  bool _quizStarted = false; // Track if the quiz has started
  bool _quizAttempted = false; // Track if the quiz has been attempted today
  final Set<String> _learnedWords = {}; // Track learned words

  @override
  void initState() {
    super.initState();
    _generateDailyQuestions();
  }

  void _generateDailyQuestions() {
    // Generate questions using a simple Markov Chain approach
    var questions = _generateQuestionsFromParagraph(_paragraph);
    _quizQuestions = questions.map((question) {
      return {
        'question': question['question'],
        'options': question['options'],
        'answer': question['answer'],
      };
    }).toList();
  }

  List<Map<String, dynamic>> _generateQuestionsFromParagraph(String text) {
    // Basic example of creating questions (replace this with actual Markov chain logic)
    List<Map<String, dynamic>> questions = [
      {
        'question': 'What is the meaning of "opportunities"?',
        'options': ['Chances for advancement', 'Difficulties', 'Errors', 'Cultural practices'],
        'answer': 'Chances for advancement',
      },
      {
        'question': 'What does it mean to "communicate"?',
        'options': ['To argue', 'To share information', 'To ignore', 'To complain'],
        'answer': 'To share information',
      },
      {
        'question': 'What is meant by "mastering" English?',
        'options': ['To learn the basics', 'To speak fluently', 'To avoid using it', 'To forget it'],
        'answer': 'To speak fluently',
      },
      // Add more questions dynamically based on the paragraph
      // This is just a placeholder; implement your Markov chain logic to generate real questions
    ];

    // Collect learned words from the paragraph
    _learnedWords.addAll(text.split(RegExp(r'\W+')).map((word) => word.toLowerCase()));

    return questions;
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true; // Mark quiz as started
    });
  }

  void _submitAnswer() {
    if (_selectedOption != null) {
      bool isCorrect = _selectedOption == _quizQuestions[_currentQuestionIndex]['answer'];
      setState(() {
        _answeredCorrectly.add(isCorrect);
      });

      // Move to the next question or show results
      if (_currentQuestionIndex < _quizQuestions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOption = null; // Reset the selected option
        });
      } else {
        // Show results dialog
        _showResultsDialog();
        setState(() {
          _quizAttempted = true; // Mark quiz as attempted
        });
      }
    }
  }

  void _showResultsDialog() {
    int score = _answeredCorrectly.where((answered) => answered).length;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quiz Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You scored $score out of ${_quizQuestions.length}.'),
              SizedBox(height: 10),
              Text('Words learned today: ${_learnedWords.join(", ")}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentQuestionIndex = 0;
                  _selectedOption = null;
                  _answeredCorrectly.clear();
                  _quizStarted = false; // Reset quiz started state
                });
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily English Quiz', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView( // Wrap in SingleChildScrollView to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_quizStarted) ...[
              Text(
                _paragraph,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ] else if (_quizQuestions.isNotEmpty) ...[
              Text(
                _quizQuestions[_currentQuestionIndex]['question'],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ..._quizQuestions[_currentQuestionIndex]['options'].map<Widget>((option) {
                return RadioListTile(
                  title: Text(option, style: TextStyle(fontSize: 18)),
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value as String?;
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _quizAttempted ? null : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ), // Disable button if already attempted
                child: Text('Submit', style: TextStyle(fontSize: 18)),
              ),
              if (_quizAttempted)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'You can only attempt the quiz once per day.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
