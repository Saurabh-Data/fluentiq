import 'package:flutter/material.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  _AvatarScreenState createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  int selectedAvatarIndex = 0;

  final List<String> avatarImages = [
    'assets/avatar1.png',
    'assets/avatar2.png',
    'assets/avatar3.png',
    'assets/avatar4.png',
  ];

  final List<String> avatarNames = [
    'Warrior',
    'Mage',
    'Rogue',
    'Archer',
  ];

  final List<Color> backgroundColors = [
    Colors.blue.shade300,
    Colors.purple.shade300,
    Colors.green.shade300,
    Colors.orange.shade300,
  ];

  void _selectAvatar(int index) {
    setState(() {
      selectedAvatarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Choose Your Avatar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Text(
            'Selected Avatar:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CircleAvatar(
            radius: 60,
            backgroundColor: backgroundColors[selectedAvatarIndex],
            backgroundImage: AssetImage(avatarImages[selectedAvatarIndex]),
          ),
          SizedBox(height: 20),
          Text(
            avatarNames[selectedAvatarIndex],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: avatarImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _selectAvatar(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedAvatarIndex == index
                            ? Colors.deepPurple
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            avatarImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          color: Colors.black.withOpacity(0.5),
                          child: Text(
                            avatarNames[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Save the selected avatar and move to the next screen
                // You can handle the saving logic here (e.g., in Firestore or local storage)
                Navigator.pushNamed(context, '/home'); // Adjust navigation as needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
