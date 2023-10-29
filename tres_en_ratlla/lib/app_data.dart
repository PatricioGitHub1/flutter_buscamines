import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // App status
  String colorPlayer = "Verd";
  String colorOpponent = "Taronja";

  int midaTablero = 9;
  int numeroMinas = 5;
  int numeroBanderes = 0;

  List<List<String>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-';

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;

  Timer? gameTimer;
  int gameTime = 0;

  bool firstSquareSelected = false;

  void resetGame() {
    if (midaTablero == 9) {
      board = [
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
        ['-', '-', '-','-', '-', '-','-', '-', '-'],
      ];
    } else if (midaTablero == 15) {
      board = [
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
        ['-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-','-', '-', '-',],
      ];
    }
    gameIsOver = false;
    gameWinner = '-';
    placeMines();
    stopTimer();
    firstSquareSelected = false;
    gameTime = 0;
  }

  // En començar la partida, col·loca les mines en el tauler
  void placeMines() {
    Random random = new Random();
    for (int i=0; i < numeroMinas; i++) {
      while (true) {
        int row = random.nextInt(midaTablero);  // Genera una fila aleatoria
        int col = random.nextInt(midaTablero);  // Genera una columna aleatoria
        if (board[row][col] == '-' && board[row][col] != 'MINE') {
          board[row][col] = 'MINE';
          break;
        }
      }
    }
  }

  // Funcio per iniciar el temporitzador de la partida
  void startTimer() {
    if (gameTimer == null) {
      gameTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        gameTime++;
        print(gameTime);
        notifyListeners();
      });
    }
  }

  // Funció per parar el temporitzador de la partida
  void stopTimer() {
    gameTimer?.cancel();
    gameTimer = null;
  }

  /*Mina = 'MINE', Bandera = 'Flag'*/
  // Funció per seleccionar i mostrar les caselles
  void selectSquare(int row, int col) {
    if (!firstSquareSelected) {
      startTimer();
      firstSquareSelected = true;
    }
    if (board[row][col] == 'MINE') {
      print("Mina trobada");
      stopTimer(); // S'atura el temporitzador de la partida
      gameIsOver = true; // Informa al programa de que s'ha detonat una mina i acaba el joc
      gameWinner = 'MINE'; // Informa al programa de que el jugador ha perdut
      for (int i = 0; i < midaTablero; i++) {
        for (int j = 0; j < midaTablero; j++) {
          if (board[i][j] == 'MINE') {
            board[i][j] = 'O'; // Reveala una mina
          }
        }
      }
      /*
      else {
        searchAdjacentSquares(row, col);
      }
      */
    }
  }

  void placeRemoveFlag(int row, int col) {
    // print(board[row][col] + " - row " + row.toString() + " | col " + col.toString());
    if (!firstSquareSelected) {
      startTimer();
      firstSquareSelected = true;
    }
    if (board[row][col] == '-' || board[row][col] == 'MINE') {
      numeroBanderes++;
      board[row][col] = 'X';
      print("S'ha col·locat una bandera. Total banderes: $numeroBanderes");
    }
    else if (board[row][col] == 'X') {
      numeroBanderes--;
      board[row][col] = 'FlagRemove';
      print("S'ha tret una bandera ? " + board[row][col] + ". Total banderes: $numeroBanderes");
    }
    /*
    else {
      searchAdjacentSquares(row, col);
    }
    */
  }

  // Booleà que determina si una casella seleccionada té una mina
  bool hasMine(int row, int col) {
    return board[row][col] == 'O';
  }

  int countAdjacentMines(int row, int col) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (row + i >= 0 && row + i < midaTablero && col + j >= 0 && col + j < midaTablero) {
          if (hasMine(row + i, col + j)) {
            count++;
          }
        }
      }
    }
    return count;
  }

  // Funció recursiva que cerca les caselles adjacents per veure si tenen una mina o una bandera
  void searchAdjacentSquares(int row, int col) {
    if (row < 0 || row >= midaTablero || col < 0 || col >= midaTablero) {
      return; // Fora dels límits del tauler
    }
    if (board[row][col] == 'X' || board[row][col] == 'O') {
      return; // Ja s'ha descobert o té una bandera
    }
    if (board[row][col] == 'O' && hasMine(row, col)) {
      gameIsOver = true; // Informa al programa de que s'ha detonat una mina i acaba el joc
      return;
    }
    int adjacentMines = countAdjacentMines(row, col);
    if (adjacentMines > 0) {
      // Mostra el número de mines adjacents
      board[row][col] = adjacentMines.toString();
    } else {
      // Cerca les caselles adjacents de manera recursiva
      board[row][col] = 'O';
      searchAdjacentSquares(row - 1, col - 1); // Superior-esquerra
      searchAdjacentSquares(row - 1, col);     // Superior
      searchAdjacentSquares(row - 1, col + 1); // Superior-dreta
      searchAdjacentSquares(row, col - 1);     // Esquerra
      searchAdjacentSquares(row, col + 1);     // Dreta
      searchAdjacentSquares(row + 1, col - 1); // Inferior-esquerra
      searchAdjacentSquares(row + 1, col);     // Inferior
      searchAdjacentSquares(row + 1, col + 1); // Inferior-dreta
    }
  }

  // Comprova si el jugador ha revelat totes les caselles que no tenen cap mina
  void checkGameStatus() {
    bool allCellsSelected = true; // De manera predeterminada, el programa asumirà que s'han seleccionat totes les caselles sense mines
    for (int i = 0; i < midaTablero; i++) {
      for (int j = 0; j < midaTablero; j++) {
        if (board[i][j] != 'MINE' && board[i][j] != 'X') {
          allCellsSelected = false; // Si es troba una casella que no s'ha seleccionat, el booleà anterior serà false
        }
      }
    }
    if (allCellsSelected) {
      gameIsOver = true; // Informa al programa de que s'ha detonat una mina i acaba el joc
    }
  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpPlayer = Image.asset('assets/images/bandera.png');
    Image tmpOpponent = Image.asset('assets/images/mina.png');

    // Carrega les imatges
    if (context.mounted) {
      imagePlayer = await convertWidgetToUiImage(tmpPlayer);
    }
    if (context.mounted) {
      imageOpponent = await convertWidgetToUiImage(tmpOpponent);
    }

    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );
    return completer.future;
  }
}
