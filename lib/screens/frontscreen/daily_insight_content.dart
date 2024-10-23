import 'package:flutter/material.dart';

class DailyInsightContent {
  // Example list of insights
  static List<String> getDailyInsights() {
    return [
      "Insight 1: Effective communication is key to success.",
      "Insight 2: Reading books can improve your vocabulary.",
      "Insight 3: Learning a new language opens doors to new opportunities.",
      "Insight 4: Consistency is key in language learning.",
      "Insight 5: Don’t be afraid to make mistakes.",
      "Insight 6: Practice speaking English daily for improvement.",
      "Insight 7: Listening to podcasts can improve your comprehension.",
      "Insight 8: Writing in English helps reinforce grammar rules."
    ];
  }
}

// Daily Insight Section Stateful Widget
class DailyInsightSection extends StatefulWidget {
  const DailyInsightSection({super.key});

  @override
  _DailyInsightSectionState createState() => _DailyInsightSectionState();
}

class _DailyInsightSectionState extends State<DailyInsightSection> {
  late List<String> dailyInsights; // Declare list of insights at class level
  late String currentInsight; // Declare current insight at class level
  int currentInsightIndex = 0; // Initialize the current index at class level

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, size: 30, color: Colors.amber),
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
            currentInsight, // Display current insight
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 14),
          ElevatedButton(
            onPressed: _getNewInsight,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Get Another Insight'),
          ),
        ],
      ),
    );
  }
}
