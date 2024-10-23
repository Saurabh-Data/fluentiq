import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fluentIQ/screens/auth/splash_screen.dart';
import 'package:fluentIQ/screens/home_screen.dart';
import 'package:fluentIQ/screens/vocabulary_screen.dart';
import 'package:fluentIQ/screens/drawer_content/daily_quizzes_screen.dart';
import 'package:fluentIQ/screens/pdf_materials_screen.dart';
import 'package:fluentIQ/screens/video_lecture_screen.dart';// Ensure this points to the correct path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FluentIQ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set splash screen as the initial route
      routes: {
        '/': (context) => SplashScreen(), // Ensure this points to your splash screen

        '/home': (context) => const HomeScreen(),
        '/vocabulary': (context) => const VocabularyScreen(),
        '/quizzes': (context) => const DailyQuizzesScreen(),
        '/pdfMaterials': (context) => const PdfMaterialsScreen(),
        '/videoLectures': (context) => const VideoLectureScreen(),
      },
    );
  }
}
