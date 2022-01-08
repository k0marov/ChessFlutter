import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 
final logic = GetIt.instance<GameLogic>(); 



class ChooseDifficultyScreen extends StatelessWidget {
  const ChooseDifficultyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const difficulties = [
      "Kid", "Easy", "Normal", "Hard", "Unreal" 
    ]; 
    return Scaffold(
        appBar: AppBar(
          title: const Text("Choose Difficulty"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final difficulty in difficulties) 
              TextButton(
                onPressed: () {
                  logic.args.difficultyOfAI = difficulty; 
                  Navigator.pushNamed(context, '/color'); 
                },
                child: Text(difficulty, textScaleFactor: 2.0)
              ),
          ]
        )
    );  
  }
}
