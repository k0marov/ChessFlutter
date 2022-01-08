import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:localstore/localstore.dart'; 
import 'dart:async'; 

import 'game_model.dart'; 

import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 
final logic = GetIt.instance<GameLogic>(); 

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({ Key? key }) : super(key: key);

  @override
  _ResumeScreenState createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final List<Game> _games = [];  
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    _subscription = Localstore.instance.collection('games').stream.listen((gameMap) {
      final game = Game.fromMap(gameMap); 
      if (!_games.contains(game)) {
        setState(() => _games.add(game)); 
      }
    }); 
    if (kIsWeb) Localstore.instance.collection('games').stream.asBroadcastStream();
    super.initState();
  }
  @override 
  void dispose() {
    _subscription?.cancel(); 
    super.dispose(); 
  }

  void _delete(int gameIndex) {
    _games[gameIndex].delete(); 
    setState(() => _games.removeAt(gameIndex)); 
  }

  void _openGame(int index) {
      logic.load(_games[index]); 
      _delete(index); 
      Navigator.pushNamed(context, "/game"); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resume Game")),
      body: _games.isEmpty ? const Center(child: Text("You have no unfinished games", textScaleFactor: 1.5))
      : ListView.builder(
        itemCount: _games.length, 
        itemBuilder: (context, index) {
          final game = _games[index];
          return Card(
            child: ListTile(
              title: Text(game.name),
              onTap: () => _openGame(index), 
              leading: IconButton( 
                icon: const Icon(Icons.arrow_forward), 
                onPressed: () => _openGame(index), 
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _delete(index)
              ),
            ),
          );
        },
      ),
    ); 
  } 
}