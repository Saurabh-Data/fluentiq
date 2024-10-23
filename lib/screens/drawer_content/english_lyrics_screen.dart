import 'package:flutter/material.dart';
import 'dart:async';

class EnglishLyricsScreen extends StatefulWidget {
  const EnglishLyricsScreen({super.key});

  @override
  _EnglishLyricsScreenState createState() => _EnglishLyricsScreenState();
}

class _EnglishLyricsScreenState extends State<EnglishLyricsScreen> {
  final List<String> _lyricsCorpus = [
    "When I find myself in times of trouble,  \nMother Mary comes to me.",
    "And in the end,  \nthe love you take is equal to the love you make.",
    "Hello from the other side,  \nI must have called a thousand times.",
    "Just a small-town girl,  \nliving in a lonely world.",
    "We don't talk anymore like we used to do.",
    "Is it too late now to say sorry?",
    "Because you make me feel like  \nI've been locked out of heaven.",
    "Can't stop the feeling,  \ngot this feeling in my body.",
    "I got a feeling that tonight's gonna be a good night.",
    "Every little thing is gonna be alright.",
    "Don't worry, be happy.",
    "I'm on the edge of glory,  \nand I'm hanging on a moment of truth.",
    "It's a beautiful day,  \ndon't let it get away.",
    "We are the champions,  \nmy friend.",
    "Just dance,  \ngonna be okay.",
    "It's a party in the USA.",
    "Rolling in the deep.",
    "Uptown funk you up.",
    "I will survive, hey hey.",
    "It's getting hot in here,  \nso take off all your clothes.",
    "I wanna dance with somebody.",
    "You are my fire,  \nthe one desire.",
    "All you need is love.",
    "Hit me baby one more time.",
    "Let it go, let it go,  \ncant hold it back anymore.",
    "I kissed a girl and I liked it.",
    "I'm a survivor,  \nI'm not gonna give up.",
    "Shake it off,  \nshake it off.",
    "Take me to church,  \nI'll worship like a dog.",
    "Call me maybe.",
    "Ain't no mountain high enough.",
    "With every heartbeat,  \nI still believe.",
  ];

  String _generatedLyrics = "";
  int _likes = 0;
  int _dislikes = 0;
  Timer? _timer;
  bool _canVote = true;

  @override
  void initState() {
    super.initState();
    _generateLyrics();
    _startDailyLyricGeneration();
  }

  void _startDailyLyricGeneration() {
    _timer = Timer.periodic(Duration(hours: 24), (timer) {
      _generateLyrics();
    });
  }

  void _generateLyrics() {
    StringBuffer generated = StringBuffer();

    for (int i = 0; i < 30; i++) {
      String randomLine = _lyricsCorpus[(i + 1) % _lyricsCorpus.length];
      generated.writeln(randomLine);
      generated.writeln(""); // Adding an empty line for better spacing
    }

    setState(() {
      _generatedLyrics = generated.toString();
      // Reset likes and dislikes for new lyrics
      _likes = 0;
      _dislikes = 0;
      _canVote = true; // Allow voting again
    });
  }

  void _like() {
    if (_canVote) {
      setState(() {
        _likes++;
        _canVote = false; // Disable voting after clicking
      });
      _startVoteCooldown();
    }
  }

  void _dislike() {
    if (_canVote) {
      setState(() {
        _dislikes++;
        _canVote = false; // Disable voting after clicking
      });
      _startVoteCooldown();
    }
  }

  void _startVoteCooldown() {
    Timer(Duration(hours: 24), () {
      setState(() {
        _canVote = true; // Re-enable voting after 24 hours
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '🎶 Daily English Lyrics 🎶',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Engage with the rhythms of the day!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lyrics for Better Pronunciation:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _generatedLyrics,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: _canVote ? Colors.green : Colors.grey, size: 30),
                          onPressed: _canVote ? _like : null,
                        ),
                        Text('Likes: $_likes', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_down, color: _canVote ? Colors.red : Colors.grey, size: 30),
                          onPressed: _canVote ? _dislike : null,
                        ),
                        Text('Dislikes: $_dislikes', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                if (!_canVote)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'You can vote again in 24 hours.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EnglishLyricsScreen(),
  ));
}
