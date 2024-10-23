import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrammarRulesScreen extends StatefulWidget {
  const GrammarRulesScreen({super.key});

  @override
  _GrammarRulesScreenState createState() => _GrammarRulesScreenState();
}

class _GrammarRulesScreenState extends State<GrammarRulesScreen> {
  final List<Map<String, String>> grammarRules = [
    {
      'rule': 'Can',
      'definition': 'Used to express ability or permission.',
      'example': 'I can swim.',
      'details': 'We use "can" to say we are able to do something. For example, if you can swim, you say "I can swim." You can also use it to ask for permission, like "Can I go to the park?"'
    },
    {
      'rule': 'Should',
      'definition': 'Used to indicate what is a good idea or advice.',
      'example': 'You should study for your exam.',
      'details': 'We use "should" to give advice or suggest something. For instance, if your friend is going to take a test, you might say, "You should study to do well."'
    },
    {
      'rule': 'Could',
      'definition': 'Used to express past ability or polite requests.',
      'example': 'I could ride a bike when I was five.',
      'details': 'We use "could" to talk about things we were able to do in the past. For example, "I could ride a bike when I was five." It’s also polite to use it when asking for something, like "Could you help me?"'
    },
    {
      'rule': 'Have',
      'definition': 'Used to show possession or as part of verb tenses.',
      'example': 'I have a dog.',
      'details': 'We use "have" to show that we own something, like in "I have a dog." It can also help form verb tenses, like "I have eaten," to show something that has already happened.'
    },
    {
      'rule': 'Was',
      'definition': 'Past tense of "is" for singular subjects.',
      'example': 'He was at the party.',
      'details': 'We use "was" to talk about something that happened in the past. For example, "He was at the party" means he attended the party before.'
    },
  ];

  late String currentRule;
  late String ruleDetails;
  int currentDay = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentDay();
  }

  Future<void> _loadCurrentDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Attempt to retrieve the current day
    try {
      currentDay = prefs.getInt('current_day') ?? 0;

      // Ensure we don't go beyond the available rules
      if (currentDay < grammarRules.length) {
        currentRule = grammarRules[currentDay]['rule']!;
        ruleDetails = grammarRules[currentDay]['details']!;
      } else {
        currentRule = "No more rules available.";
        ruleDetails = "";
      }

      // Increment day for the next time the screen is accessed
      prefs.setInt('current_day', currentDay + 1);
    } catch (e) {
      // Handle errors gracefully
      currentRule = "Error loading rule.";
      ruleDetails = "An unexpected error occurred. Please try again.";
      print("Error loading current day: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grammar Rules'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Rule: $currentRule',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Definition: ${grammarRules[currentDay]['definition']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Example: ${grammarRules[currentDay]['example']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Details: $ruleDetails',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (currentDay < grammarRules.length)
              ElevatedButton(
                onPressed: _nextRule,
                child: Text('Next Rule'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _nextRule() async {
    // Increment the day count and load the next rule
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentDay = (prefs.getInt('current_day') ?? 0);

    if (currentDay < grammarRules.length) {
      // Update the current rule and details
      currentRule = grammarRules[currentDay]['rule']!;
      ruleDetails = grammarRules[currentDay]['details']!;
      prefs.setInt('current_day', currentDay + 1);
      setState(() {});
    } else {
      // Reset to show no more rules
      currentRule = "No more rules available.";
      ruleDetails = "";
    }
  }
}
