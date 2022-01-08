import 'package:flutter/material.dart';
import 'piece_widget.dart';
import 'dart:math' as math;
import 'package:chess/chess.dart' as chess_lib;


import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 
final logic = GetIt.instance<GameLogic>(); 

class Tile extends StatelessWidget {
  final chess_lib.Piece? piece;
  final String tileColor;
  final String index;
  Tile({Key? key, required this.index})
      : piece = logic.get(index),
        tileColor = logic.squareColor(index)!,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var labelStyle =
        TextStyle(color: tileColor == 'light' ? Colors.brown : Colors.white);
    final args = logic.args; 
    final fileLabel = args.asBlack
        ? (index[1] == "8" ? index[0] : "")
        : (index[1] == "1" ? index[0] : "");
    final rankLabel = args.asBlack
        ? (index[0] == "h" ? index[1] : "")
        : (index[0] == "a" ? index[1] : "");
    return GestureDetector(
      onTapUp: (_) => logic.tapTile(index), 
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            color: logic.selectedTile == index
                ? Colors.amber[400]
                : (tileColor == 'light' ? Colors.grey[200] : Colors.brown),
          ),
        ),
        if (logic.previousMove != null 
        && (logic.previousMove!['to'] == index || logic.previousMove!['from'] == index)) 
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3.0, 
                  color: 
                    logic.previousMove!['from'] == index
                      ? Colors.black54
                      : Colors.black26
                )
              ),
            ),
          ),
        Positioned(
          top: 2,
          left: 2,
          child: Text(rankLabel, style: labelStyle),
        ),
        Positioned(
          right: 2,
          bottom: 2,
          child: Text(fileLabel, style: labelStyle),
        ),
        if (logic.availableMoves.contains(index))
          Center(
              child: Container(
                  width: 20, height: 20, 
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ))),
        if (piece != null)
          Positioned.fill(
              child: Transform.rotate(
                  angle: args.isMultiplayer &&
                          args.asBlack ==
                              (piece!.color == chess_lib.Color.WHITE)
                      ? math.pi
                      : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: PieceWidget(piece: piece!),
                  ))),
      ]),
    );
  }

}
