import 'package:flutter/material.dart';
import 'tile.dart';

import 'package:get_it/get_it.dart'; 
import 'game_logic.dart'; 
final logic = GetIt.instance<GameLogic>(); 

class ChessBoard extends StatelessWidget {
  const ChessBoard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          for (int rank = 0; rank < 8; ++rank) 
            TableRow(
              children: [
                for (int file = 0; file < 8; ++file) 
                  TableCell(
                    child: AspectRatio(
                      aspectRatio: 1, 
                      child: Tile(
                        index:  
                          logic.args.asBlack ? 
                            logic.boardIndex(rank, 7-file) 
                          : logic.boardIndex(7-rank, file)
                      ),
                    )
                  ) 
              ] 
            )
        ]
    ); 
  }
}
