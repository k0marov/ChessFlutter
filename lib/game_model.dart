import 'game_arguments.dart'; 
import 'game_logic.dart' show PieceType; 
import 'package:localstore/localstore.dart'; 

PieceType pieceTypeFromJson(String json) {
  if (json == 'p') {
    return PieceType.PAWN;
  } else if (json == "q") {
    return PieceType.QUEEN;
  } else if (json == "k") {
    return PieceType.KING;
  } else if (json == "n") {
    return PieceType.KNIGHT;
  } else if (json == "b") {
    return PieceType.BISHOP;
  } else if (json == "r") {
    return PieceType.ROOK;
  } else {
    throw Exception("PieceType could not decode JSON: $json");
  } 
}
String pieceTypeToJson(PieceType pieceType) => pieceType.toString(); 

class Game {
  final String id; 
  final String name; 
  final String fen; 
  final GameArguments args; 
  final List<PieceType> eatenBlack; 
  final List<PieceType> eatenWhite; 
  Game({
    required this.id, 
    required this.name, 
    required this.fen, 
    required this.args, 
    required this.eatenBlack, 
    required this.eatenWhite, 
  }); 

  Map<String, dynamic> toMap() => {
    'id': id, 
    'name': name, 
    'fen': fen, 
    'args': args.toJson(), 
    'ateblck': eatenBlack.map((pieceType) => pieceTypeToJson(pieceType)).toList(), 
    'atewht': eatenWhite.map((pieceType) => pieceTypeToJson(pieceType)).toList(), 
  }; 

  factory Game.fromMap(Map<String, dynamic> map) => Game(
    id: map['id'], 
    name: map['name'], 
    fen: map['fen'], 
    args: GameArguments.fromJson(map['args']), 
    eatenBlack: map['ateblck'].map<PieceType>((json) => pieceTypeFromJson(json)).toList(), 
    eatenWhite: map['atewht'].map<PieceType>((json) => pieceTypeFromJson(json)).toList(), 
  );  
}

extension ExtGame on Game {
  Future save() async => 
    Localstore.instance.collection('games').doc(id).set(toMap()); 
  Future delete() async => 
    Localstore.instance.collection('games').doc(id).delete(); 
}
