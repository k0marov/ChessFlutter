import 'package:flutter/material.dart';
import 'home_screen_button.dart'; 


import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 
final logic = GetIt.instance<GameLogic>(); 

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const minWidth = 250.0; 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chess"),
      ),
      body: Center(
        child: ButtonBar(
          alignment: MainAxisAlignment.center, 
          children: [
            HomeScreenButton(
              text: "Singleplayer", 
              minWidth: minWidth, 
              onPressed: (context) {
                logic.args.isMultiplayer = false; 
                Navigator.pushNamed(context, '/difficulty'); 
              }
            ), 
            HomeScreenButton(
              text: "Multiplayer", 
              minWidth: minWidth, 
              onPressed: (context) {
                logic.args.isMultiplayer = true; 
                Navigator.pushNamed(context, '/color'); 
              }
            ), 
            HomeScreenButton(
              text: "Resume", 
              minWidth: minWidth, 
              onPressed: (context) {
                Navigator.pushNamed(context, '/resume'); 
              }
            ), 
          ]
        ),
      )
    );
  }
}
