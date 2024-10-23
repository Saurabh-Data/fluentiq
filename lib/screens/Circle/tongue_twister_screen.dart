import 'package:flutter/material.dart';

class TongueTwisterScreen extends StatelessWidget {
  final List<String> easyTongueTwisters = [
    "She sells seashells by the seashore.",
    "Peter Piper picked a peck of pickled peppers.",
    "How can a clam cram in a clean cream can?",
    "I scream, you scream, we all scream for ice cream!",
    "Red lorry, yellow lorry.",
    "Betty Botter bought some butter, but she said the butter's bitter.",
    "If two ducks swam in a lake, which duck would swim the fastest?",
    "Can you can a can as a canner can can a can?",
    "Fuzzy Wuzzy was a bear.",
    "I saw Susie sitting in a shoeshine shop."
  ];

  final List<String> mediumTongueTwisters = [
    "Unique New York, unique New York, you know you need unique New York.",
    "Can you can a can as a canner can can a can?",
    "The great Greek grape growers grow great Greek grapes.",
    "Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. Fuzzy Wuzzy wasn't very fuzzy, was he?",
    "Red leather, yellow leather.",
    "The thirty-three thieves thought that they thrilled the throne throughout Thursday.",
    "The big black bug bit the big black bear.",
    "I thought a thought. But the thought I thought wasn't the thought I thought I thought.",
    "Sheena leads, Sheila needs."
  ];

  final List<String> hardTongueTwisters = [
    "The sixth sick sheik's sixth sheep's sick.",
    "Pad kid poured curd pulled cold.",
    "How much wood would a woodchuck chuck if a woodchuck could chuck wood?",
    "If two witches were watching two watches, which witch would watch which watch?",
    "Silly Sally swiftly shooed seven silly sheep.",
    "A box of mixed biscuits, a mixed biscuit box.",
    "How can a clam cram in a clean cream can?",
    "The thirty-three thieves thought that they thrilled the throne throughout Thursday.",
    "She sells sea shells by the sea shore."
  ];

   TongueTwisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tongue Twisters'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMotivationalQuote(),
            SizedBox(height: 20),
            _buildDifficultyButton('Easy Tongue Twisters', easyTongueTwisters, Colors.greenAccent, context),
            _buildDifficultyButton('Medium Tongue Twisters', mediumTongueTwisters, Colors.amber, context),
            _buildDifficultyButton('Hard Tongue Twisters', hardTongueTwisters, Colors.redAccent, context),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '"Practice makes perfect!"',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '- SP',
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal[700],
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String title, List<String> tongueTwisters, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showTongueTwistersDrawer(title, tongueTwisters, context);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: color),
              ),
              Icon(Icons.arrow_forward, color: color),
            ],
          ),
        ),
      ),
    );
  }

  void _showTongueTwistersDrawer(String title, List<String> tongueTwisters, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 10),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: tongueTwisters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(tongueTwisters[index], style: TextStyle(fontSize: 18)),
                    );
                  },
                ),
              ),
              TextButton(
                child: Text('Close', style: TextStyle(color: Colors.teal)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
