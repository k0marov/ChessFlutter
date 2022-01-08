import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'chess_app.dart'; 
import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 

void main() {
  GetIt.instance.registerSingleton<GameLogic>(GameLogicImplementation(), signalsReady: true); 

  WidgetsFlutterBinding.ensureInitialized(); 
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );
  runApp(const ChessApp());
}

