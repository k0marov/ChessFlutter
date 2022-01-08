import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import 'choose_color_screen.dart';
import 'choose_difficulty_screen.dart'; 
import 'resume_screen.dart'; 

class ChessApp extends StatelessWidget {
  const ChessApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(), 
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/difficulty': (context) => const ChooseDifficultyScreen(), 
          '/color': (context) => const ChooseColorScreen(), 
          '/resume': (context) => const ResumeScreen(), 
          '/game': (context) => const GameScreen(),
        });
  }
}
