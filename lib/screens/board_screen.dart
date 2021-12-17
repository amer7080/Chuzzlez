import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:provider/provider.dart';
import 'package:chuzzlez/providers/board_provider.dart';

class Board extends StatefulWidget {
  Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  ChessBoardController controller = ChessBoardController();
  var pgns = BoardProvider().pgns;
  var lvlCount = BoardProvider().levelCount;
  var moveCount = BoardProvider().moveCount;
  var solution;
  var chessBoard;
  bool won = false;

  // var pgns = Provider.of<BoardProvider>(context, listen: false).pgns;
  void checkMove(String solution, int lvlcount, int movecount) {
    var solSplit = solution.split(',');
    var solFinal = solSplit[movecount].split(' ');
    var lastMove = controller.getSan().last!.split(' ')[1];

    // checks if last move was made by player or system
    if (controller.getSan().last!.split(' ').length == 2) {
      // checks if last move is same as solution move
      if (lastMove == solFinal[1]) {
        // checks if system has a move after player
        if (solFinal.length == 3) {
          controller.makeMoveWithNormalNotation(solFinal[2]);
          moveCount++;
        } else {
          print('you won');
          setState(() {
            this.won = true;
          });
        }
      } else {
        controller.game.undo_move();
        controller.notifyListeners();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        const Center(
            child: Text('Level 4',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ))),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Home',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(color: Colors.black),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                if (lvlCount != 0) {
                  lvlCount -= 1;
                  moveCount = 0;
                  controller.loadPGN(pgns[lvlCount]);
                  solution = BoardProvider().solutions[lvlCount];
                  setState(() {
                    won = false;
                  });
                }
              },
              child: const Text('Prev',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(color: Colors.black),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                if (lvlCount != pgns.length - 1) {
                  lvlCount += 1;
                  moveCount = 0;
                  controller.loadPGN(pgns[lvlCount]);
                  solution = BoardProvider().solutions[lvlCount];
                  setState(() {
                    won = false;
                  });
                }
              },
              child: const Text('Next',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(color: Colors.black),
              ),
            )
          ],
        ),
        chessBoard = ChessBoard(
          controller: controller,
          boardColor: BoardColor.green,
          boardOrientation: PlayerColor.white,
          enableUserMoves: !won,
          onMove: () {
            checkMove(solution, lvlCount, moveCount);
          },
        )
      ]),
    );
  }
}