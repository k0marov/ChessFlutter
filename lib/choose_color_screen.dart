import 'package:flutter/material.dart';
import 'piece_widget.dart'; 

import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 
final logic = GetIt.instance<GameLogic>(); 

class ChooseColorScreen extends StatelessWidget {
  const ChooseColorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("You Play As"),
      ),
      body: Center(
        child: 
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  child: SizedBox(
                    width: 150, height: 150, 
                    child: PieceWidget(piece: Piece(PieceType.KING, PieceColor.BLACK))
                  ), 
                  onTap: () {
                    logic.args.asBlack = true; 
                    Navigator.pushNamed(context, '/game'); 
                    logic.start(); 
                  }
                ),
              ), 
              Flexible(
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  child: SizedBox(
                    width: 150, height: 150, 
                    child: PieceWidget(piece: Piece(PieceType.KING, PieceColor.WHITE))
                  ), 
                  onTap: () {
                    logic.args.asBlack = false; 
                    Navigator.pushNamed(context, '/game'); 
                    logic.start(); 
                  }
                ),
              )
            ]
          )
    ));
  }
}
