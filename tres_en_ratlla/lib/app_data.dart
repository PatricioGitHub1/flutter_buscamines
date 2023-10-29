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
  int currentFlagsUsed = 0;

  List<List<String>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-'; 

  // imagenes
  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  
  ui.Image? image1;
  ui.Image? image2;
  ui.Image? image3;
  ui.Image? image4;
  ui.Image? image5;
  ui.Image? image6;
  ui.Image? image7;
  ui.Image? image8;

  bool imagesReady = false;

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
    currentFlagsUsed = 0;
    placeMines();
  }

  // En començar la partida, col·loca les mines en el tauler
  void placeMines() {
    Random random = new Random();
    for (int i=0; i < numeroMinas; i++) {
      while (true) {
        int row = random.nextInt(midaTablero);  // Genera una fila aleatoria
        int col = random.nextInt(midaTablero);  // Genera una columna aleatoria
        if (board[row][col] == '-' && board[row][col] != 'M') {
          board[row][col] = 'M';
          break;
        }
      }
    }
  }

  /*Mina = 'M', Bandera = 'X' 'XO'*/
  // Funció per seleccionar i mostrar les caselles
  void selectSquare(int row, int col) {
    if (board[row][col] == 'M') {
      print("Mina trobada amb un click");
      gameIsOver = true; // Informa al programa de que s'ha detonat una mina i acaba el joc
      gameWinner = 'M'; // Informa al programa de que el jugador ha perdut
      for (int i = 0; i < midaTablero; i++) {
        for (int j = 0; j < midaTablero; j++) {
          if (board[i][j] == 'M' || board[i][j] == 'XO') {
            board[i][j] = 'O'; // Reveala una mina
          }
        }
      }
    }
    if (board[row][col] == 'XO' || board[row][col] == 'X') {
      return;
    }
    else {
      Set<String> visited = Set();
      searchAdjacentSquares(row, col, visited);
    }
    
  }

  void placeRemoveFlag(int row, int col) {
    if (board[row][col] == '-' ) {
      if ((numeroMinas-currentFlagsUsed) == 0) {
        return;
      }
      board[row][col] = 'X';
      print("S'ha col·locat una bandera");
      currentFlagsUsed++;
    } else if (board[row][col] == 'M') {
      if ((numeroMinas-currentFlagsUsed) == 0) {
        return;
      }
      board[row][col] = 'XO';
      print("S'ha col·locat una bandera");
      currentFlagsUsed++;
    }
    else if (board[row][col] == 'X') {
      board[row][col] = 'FlagRemove';
      print("S'ha tret una bandera ? " + board[row][col]);
      currentFlagsUsed--;
    }
    else if (board[row][col] == 'XO') {
      board[row][col] = 'M';
      print("S'ha tret una bandera ? " + board[row][col]);
      currentFlagsUsed--;
    }
  }

  // Booleà que determina si una casella seleccionada té una mina
  bool hasMine(int row, int col) {
    return board[row][col] == 'M';
  }

  int countAdjacentMines(int row, int col) {
    int count = 0;
    int n = board.length;
    int m = board[0].length;
    for (int dx = (row > 0 ? -1 : 0); dx <= (row < n - 1 ? 1 : 0); dx++) {
    // Deviation of the column that gets adjusted according to the provided position
    for (int dy = (col > 0 ? -1 : 0); dy <= (col < m - 1 ? 1 : 0); dy++) {
      if (dx != 0 || dy != 0) {
        if (board[row + dx][col + dy] == 'M' || board[row + dx][col + dy] == 'XO') {
          count++;
        }
      }
    }
  }
    return count;
  }

  // Funció recursiva que cerca les caselles adjacents per veure si tenen una mina o una bandera
  void searchAdjacentSquares(int row, int col, Set<String> visited) {
    String position = '$row-$col'; // Representa la posición de la casilla
    if (row < 0 || row >= midaTablero || col < 0 || col >= midaTablero || visited.contains(position)) {
      return; // Fora dels límits del tauler
    }
    visited.add(position); // Marca la casilla como visitada
    if (board[row][col] == 'X' || board[row][col] == 'O' || board[row][col] == 'XO') {
      return; // Ja s'ha descobert o té una bandera
    }
    int adjacentMines = countAdjacentMines(row, col);
    if (adjacentMines > 0) {
      // Mostra el número de mines adjacents
      board[row][col] = adjacentMines.toString();
    } else {
      // Cerca les caselles adjacents de manera recursiva
      board[row][col] = 'C';
      searchAdjacentSquares(row - 1, col - 1, visited); // Superior-esquerra
      searchAdjacentSquares(row - 1, col, visited);     // Superior
      searchAdjacentSquares(row - 1, col + 1, visited); // Superior-dreta
      searchAdjacentSquares(row, col - 1, visited);     // Esquerra
      searchAdjacentSquares(row, col + 1, visited);     // Dreta
      searchAdjacentSquares(row + 1, col - 1, visited); // Inferior-esquerra
      searchAdjacentSquares(row + 1, col, visited);     // Inferior
      searchAdjacentSquares(row + 1, col + 1, visited); // Inferior-dreta
    }
  }

  // Comprova si el jugador ha revelat totes les caselles que no tenen cap mina
  void checkGameStatus() {
    bool allCellsSelected = true;
    for (int i = 0; i < midaTablero; i++) {
      for (int j = 0; j < midaTablero; j++) {
        if (board[i][j] == "-" || board[i][j] == "X") {
          allCellsSelected = false;
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

    Image tmp1 = Image.asset('assets/images/1.png');
    Image tmp2 = Image.asset('assets/images/2.png');
    
    Image tmp3 = Image.asset('assets/images/3.png');
    Image tmp4 = Image.asset('assets/images/4.png');
    Image tmp5 = Image.asset('assets/images/5.png');
    Image tmp6 = Image.asset('assets/images/6.png');
    Image tmp7 = Image.asset('assets/images/7.png');
    Image tmp8 = Image.asset('assets/images/8.png');
    
    // Carrega les imatges
    if (context.mounted) {
      image1 = await convertWidgetToUiImage(tmp1);
    }
    if (context.mounted) {
      image2 = await convertWidgetToUiImage(tmp2);
    }

    if (context.mounted) {
      image3 = await convertWidgetToUiImage(tmp3);
    }
    if (context.mounted) {
      image4 = await convertWidgetToUiImage(tmp4);
    }
    if (context.mounted) {
      image5 = await convertWidgetToUiImage(tmp5);
    }
    if (context.mounted) {
      image6 = await convertWidgetToUiImage(tmp6);
    }
    if (context.mounted) {
      image7 = await convertWidgetToUiImage(tmp7);
    }
    if (context.mounted) {
      image8 = await convertWidgetToUiImage(tmp8);
    }
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

  void printBoardConsole() {
    print("======================================================0");
    for (int i = 0; i != board.length; i++) {
      print(board[i]);
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
