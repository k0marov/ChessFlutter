import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:chess/chess.dart' as chess_lib;

class PieceWidget extends StatelessWidget {
  final String shortName; 
  PieceWidget({Key? key, required chess_lib.Piece piece}) : 
    shortName=piece.type.toString() + piece.color.toString()[6].toLowerCase(), 
    super(key: key); 

  // const PieceWidget.fromShortName({Key? key, required this.shortName}) : super(key: key);
  // static Map<String, Image> cache = {};

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        "assets/pieces/$shortName.svg", 
        fit: BoxFit.contain, 
      );
  }
}

