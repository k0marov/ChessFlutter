import 'game_arguments.dart';
import 'ai.dart'; 
import 'game_model.dart'; 

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart'; 
import 'package:chess/chess.dart' as chess_lib; 
import 'dart:math' as math; 

typedef Piece = chess_lib.Piece; 
typedef PieceType = chess_lib.PieceType; 
typedef PieceColor = chess_lib.Color; 

abstract class GameLogic extends ChangeNotifier {
  String? get selectedTile;
  List<String> get availableMoves;
  List<PieceType> get eatenBlack; 
  List<PieceType> get eatenWhite; 
  Map<String, String>? get previousMove; // 'from' and 'to' keys that point to positions on the board

  GameArguments args=GameArguments(asBlack: false, isMultiplayer: false); 

  String boardIndex(int rank, int file);
  void tapTile(String index); 
  int getRelScore(PieceColor color); 
  void clear();
  void start(); 
  Game save(); 
  void load(Game game); 

  Piece? get(String index); 
  String? squareColor(String index); 
  PieceColor turn(); 
  bool gameOver(); 
  bool inCheckmate(); 
  bool inDraw(); 
  bool inThreefoldRepetition(); 
  bool insufficientMaterial(); 
  bool inStalemate(); 

  bool get isPromotion;
  void promote(Piece? selectedPiece);
}

class GameLogicImplementation extends GameLogic {
  var chess = chess_lib.Chess();
  @override
  String? selectedTile;
  @override
  List<String> availableMoves = [];
  @override 
  List<PieceType> eatenBlack = [];  // what black ate
  @override
  List<PieceType> eatenWhite = [];  // what white ate
  
  @override 
  // null means "this is a first move"
  // ignore: avoid_init_to_null
  Map<String, String>? previousMove = null;   // 'from' and 'to' keys that point to positions on the board

  @override
  bool get isPromotion => promotionMove != null;

  // null means "this move is not a promotion"
  // ignore: avoid_init_to_null
  var promotionMove = null;

  ChessAI ai = ChessAI(); 

  GameLogicImplementation();

  static const boardFiles = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  @override
  String boardIndex(int rank, int file) {
    return boardFiles[file] + (rank+1).toString();
  }

  static const pieceScores = {
    PieceType.PAWN : 1, 
    PieceType.KNIGHT : 3, 
    PieceType.BISHOP : 3, 
    PieceType.ROOK : 5, 
    PieceType.QUEEN : 8, 
    PieceType.KING : 999, 
  }; 

  int _getScore(PieceColor color) {
    return chess.board
        .where((piece) => piece != null && piece.color == color)
        .map((piece) => pieceScores[piece!.type]).fold(0, (p, c) => p + c!); 
  }
  @override 
  int getRelScore(PieceColor color) {
    PieceColor otherColor = color == PieceColor.WHITE ? PieceColor.BLACK : PieceColor.WHITE; 
    var mainPlayerScore = _getScore(color); 
    var secondPlayerScore = _getScore(otherColor); 
    return math.max(mainPlayerScore, secondPlayerScore) - secondPlayerScore;
  }

  @override 
  Piece? get(String index) => chess.get(index); 
  @override 
  String? squareColor(String index) => chess.square_color(index); 
  @override
  PieceColor turn() => chess.turn; 
  @override 
  bool gameOver() => chess.game_over; 
  @override
  bool inCheckmate() => chess.in_checkmate; 
  @override
  bool inDraw() => chess.in_draw; 
  @override
  bool inThreefoldRepetition() => chess.in_threefold_repetition; 
  @override
  bool insufficientMaterial() => chess.insufficient_material; 
  @override
  bool inStalemate() => chess.in_stalemate; 

  void _addEatenPiece(Piece eatenPiece) {
      if (eatenPiece.color == PieceColor.BLACK) {
        eatenWhite.add(eatenPiece.type); 
      } else {
        eatenBlack.add(eatenPiece.type); 
      }
  }

  bool _move(move) {
    Piece? eatenPiece = chess.get(move['to']); 
    bool isValid = chess.move(move); 
    if (isValid) {
      if (eatenPiece != null) _addEatenPiece(eatenPiece); 
      maybeCallAI(); 
      previousMove = {'from': move['from'], 'to': move['to']}; 
    }
    return isValid; 
  }

  void maybeCallAI() async {
    if (!gameOver() && !args.isMultiplayer && !(args.asBlack == (chess.turn == PieceColor.BLACK))) {
      while (!ai.isReady()) {
        await Future.delayed(const Duration(seconds: 1)); 
      }
      var move = await ai.compute(chess.fen, args.difficultyOfAI, 1000); 
      _move({'from': move[0]+move[1], 
             'to': move[2]+move[3], 
             'promotion': move.length == 5 ? move[4] : null}); 
    notifyListeners(); 
  }
}

  @override
  void promote(Piece? selectedPiece) {
    if (selectedPiece != null) {
      promotionMove['promotion'] = selectedPiece.type.toString();
      _move(promotionMove); 
    }
    promotionMove = null;
    notifyListeners();
  }

  void makeMove(String fromInd, String toInd) {
    final move = {'from': fromInd, 'to': toInd};
    bool isValid = _move(move);
    if (!isValid &&
        chess.move({'from': fromInd, 'to': toInd, 'promotion': 'q'})) {
      chess.undo();
      promotionMove = move;
    } else if (promotionMove != null) {
      promotionMove = null;
    } 
  }

  void select(String? index) {
    selectedTile = index;
    availableMoves = chess
        .moves({'square': index, 'verbose': true})
        .map((move) => move['to'].toString())
        .toList();
  }

  @override
  void tapTile(String index) {
    if (!args.isMultiplayer && args.asBlack == (turn() == PieceColor.WHITE)) {
      return; 
    }

    if (index == selectedTile) {
      select(null);
    } else if (selectedTile != null) {
      if (chess.get(index)?.color == chess.turn) {
        select(index);
      } else {
        makeMove(selectedTile!, index);
        select(null);
      }
    } else if (chess.get(index)?.color == chess.turn) {
      select(index);
    } else {
      return;
    }
    notifyListeners();
  }

  @override
  void clear() {
    chess.reset();
    selectedTile = null;
    availableMoves = [];
    eatenBlack = []; eatenWhite = []; 
    promotionMove = null;
    previousMove = null; 
  }
  @override 
  void start() {
    chess.reset(); 
    maybeCallAI(); 
  }
  @override 
  Game save() {
    String name = DateTime.now().toString().substring(0, 16) + 
                 (args.isMultiplayer ? " Multiplayer" : " vs ${args.difficultyOfAI}"); 
    final id = Localstore.instance.collection("games").doc().id; 
    Game game = Game(
      id: id, 
      name: name, 
      fen: chess.fen, 
      args: args, 
      eatenBlack: eatenBlack, 
      eatenWhite: eatenWhite, 
    ); 
    game.save(); 
    return game; 
  }
  @override 
  void load(Game game) {
    clear(); 
    chess = chess_lib.Chess.fromFEN(game.fen); 
    args = game.args; 
    eatenBlack = game.eatenBlack; 
    eatenBlack = game.eatenWhite; 
    notifyListeners(); 
    maybeCallAI(); 
  }
}