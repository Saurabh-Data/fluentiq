import 'package:fluentIQ/screens/grammar_rules_screen.dart';
import 'package:fluentIQ/screens/pdf_materials_screen.dart';
import 'package:fluentIQ/screens/video_lecture_screen.dart';
import 'package:fluentIQ/screens/vocabulary_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/side_drawer.dart';
import 'Circle/conversation_screen.dart';
import 'Circle/english_techniques_screen.dart';
import 'Circle/fill_blanks_game_screen.dart';
import 'Circle/interview_questions_screen.dart';
import 'Circle/practice_question_screen.dart';
import 'Circle/story_screen.dart';
import 'Circle/tongue_twister_screen.dart';
import 'frontscreen/daily_quiz_screen.dart';
import 'frontscreen/daily_insight_content.dart'; // Dart file for Daily Insight content

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FluentIQ'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to Notifications Screen
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          // Circular Section - Fixed at the top
          _buildTopNavigationBar(context),

          // Main content scrollable section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Insight Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DailyInsightSection(), // Updated to use stateful widget
                  ),

                  // Vocabulary Section with logo
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Vocabulary', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  _buildVocabularySection(context),

                  // Grammar Rules Section with logo
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Grammar Rules', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  _buildGrammarRulesSection(context),

                  // Daily Quiz Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Daily Quiz or Challenge', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  _buildDailyQuizSection(context),

                  // Space before Bottom Navigation Buttons
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavButton(Icons.home, 'Home', () {}),
            _buildBottomNavButton(Icons.video_library, 'Video Lectures', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoLectureScreen()));
            }),
            _buildBottomNavButton(Icons.picture_as_pdf, 'PDF Materials', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PdfMaterialsScreen()));
            }),
          ],
        ),
      ),
    );
  }

  // Top Navigation Bar
  Widget _buildTopNavigationBar(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.blueAccent.withOpacity(0.1), // Changed background color
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCircularIcon(context, 'Daily Story', Icons.menu_book, StoryScreen()),
          _buildCircularIcon(context, 'Conversation', Icons.chat, ConversationScreen()),
          _buildCircularIcon(context, 'Games', Icons.spatial_tracking, OneWordPuzzleGame ()), // Replace with actual game screen
          _buildCircularIcon(context, 'Tongue Twister', Icons.speaker, TongueTwisterScreen()),
          _buildCircularIcon(context, 'Practice?', Icons.question_answer, PracticeQuestionScreen()),
          _buildCircularIcon(context, 'Interview?', Icons.work, InterviewQuestionsScreen()),
          _buildCircularIcon(context, 'English Technique', Icons.lightbulb, EnglishTechniquesScreen()),
        ],
      ),
    );
  }

  Widget _buildCircularIcon(BuildContext context, String label, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Vocabulary Section with Icon
  Widget _buildVocabularySection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VocabularyScreen()));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.book, size: 50, color: Colors.white), // Icon for Vocabulary
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Tap here to explore Vocabulary (Antonyms, Synonyms, Meanings)',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grammar Rules Section with Icon
  Widget _buildGrammarRulesSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GrammarRulesScreen()));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.library_books, size: 50, color: Colors.white), // Icon for Grammar Rules
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Tap here for Grammar Rules',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Daily Quiz Section with Icon
  Widget _buildDailyQuizSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DailyQuizScreen()));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.cyan[400],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.question_answer, size: 50, color: Colors.grey[800]), // Icon for Daily Quiz
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Tap here for Daily Quiz or Challenge',
                style: TextStyle(color: Colors.grey[800], fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build Bottom Navigation Buttons
  Widget _buildBottomNavButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 35, color: Colors.blue),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.blue)),
        ],
      ),
    );
  }
}

// Daily Insight Section Stateful Widget
class DailyInsightSection extends StatefulWidget {
  const DailyInsightSection({super.key});

  @override
  _DailyInsightSectionState createState() => _DailyInsightSectionState();
}

class _DailyInsightSectionState extends State<DailyInsightSection> {
  late List<String> dailyInsights; // Declare the daily insights list
  late String currentInsight; // Current insight to be displayed
  int currentInsightIndex = 0; // Index to track the current insight

  @override
  void initState() {
    super.initState();

    // Initialize daily insights and set the first insight
    dailyInsights = DailyInsightContent.getDailyInsights(); // Get the list of insights
    currentInsight = dailyInsights[currentInsightIndex]; // Assign the first insight
  }

  void _getNewInsight() {
    setState(() {
      // Move to the next insight and loop back if necessary
      currentInsightIndex = (currentInsightIndex + 1) % dailyInsights.length;
      currentInsight = dailyInsights[currentInsightIndex]; // Update current insight
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for a fresh look
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, size: 30, color: Colors.amber), // Insight icon
              SizedBox(width: 10),
              Text(
                'Daily Insight',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            currentInsight, // Display the current insight
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 14),
          ElevatedButton(
            onPressed: _getNewInsight,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.amber, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ), // Trigger fetching a new insight
            child: Text('Get Another Insight'),
          ),
        ],
      ),
    );
  }
}
