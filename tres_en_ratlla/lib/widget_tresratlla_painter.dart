import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;

  WidgetTresRatllaPainter(this.appData);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    // Definim els punts on es creuaran les línies verticals
    /*
    final double firstVertical = size.width / 3;
    final double secondVertical = 2 * size.width / 3;

    // Dibuixem les línies verticals
    canvas.drawLine(
        Offset(firstVertical, 0), Offset(firstVertical, size.height), paint);
    canvas.drawLine(
        Offset(secondVertical, 0), Offset(secondVertical, size.height), paint);

    */
    int value_tablero = appData.midaTablero;
    for (int i = 1; i != (value_tablero+1); i++) {
        // linias verticales
        final double vertical = i * size.width / value_tablero;
        canvas.drawLine(
          Offset(vertical, 0), Offset(vertical, size.height), paint
        );
        // linias horizontales
        final double horizontal = i * size.height / value_tablero;
        canvas.drawLine(
          Offset(0, horizontal), Offset(size.width, horizontal), paint);
    }

    // Definim els punts on es creuaran les línies horitzontals
    /*final double firstHorizontal = size.height / 3;
    final double secondHorizontal = 2 * size.height / 3;

    // Dibuixem les línies horitzontals
    canvas.drawLine(
        Offset(0, firstHorizontal), Offset(size.width, firstHorizontal), paint);
    canvas.drawLine(Offset(0, secondHorizontal),
        Offset(size.width, secondHorizontal), paint);
    */
  }

  // Dibuixa la imatge centrada a una casella del taulell
  void drawImage(Canvas canvas, ui.Image image, double x0, double y0, double x1,
      double y1) {
    double dstWidth = x1 - x0;
    double dstHeight = y1 - y0;

    double imageAspectRatio = image.width / image.height;
    double dstAspectRatio = dstWidth / dstHeight;

    double finalWidth;
    double finalHeight;

    if (imageAspectRatio > dstAspectRatio) {
      finalWidth = dstWidth;
      finalHeight = dstWidth / imageAspectRatio;
    } else {
      finalHeight = dstHeight;
      finalWidth = dstHeight * imageAspectRatio;
    }

    double offsetX = x0 + (dstWidth - finalWidth) / 2;
    double offsetY = y0 + (dstHeight - finalHeight) / 2;

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(offsetX, offsetY, finalWidth, finalHeight);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  /*
  // Dibuixa una creu centrada a una casella del taulell
  void drawCross(Canvas canvas, double x0, double y0, double x1, double y1,
      Color color, double strokeWidth) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      Offset(x0, y0),
      Offset(x1, y1),
      paint,
    );
    canvas.drawLine(
      Offset(x1, y0),
      Offset(x0, y1),
      paint,
    );
  }

  // Dibuixa un cercle centrat a una casella del taulell
  void drawCircle(Canvas canvas, double x, double y, double radius, Color color,
      double strokeWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(x, y), radius, paint);
  }
  */
  void drawEmptySquare(Canvas canvas, Offset topLeft, Offset bottomRight, Color color, double strokeWidth) {
  final Paint paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth;

  // Adjust the size of the rectangle to make it smaller
  Rect rectangle = Rect.fromPoints(
    Offset(topLeft.dx + 5, topLeft.dy + 5),
    Offset(bottomRight.dx - 5, bottomRight.dy - 5),
  );

  canvas.drawRect(rectangle, paint);
}

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    // Dibuixar 'X' i 'O' del tauler
    double cellWidth = size.width / appData.midaTablero;
    double cellHeight = size.height / appData.midaTablero;

    for (int i = 0; i < appData.midaTablero; i++) {
      for (int j = 0; j < appData.midaTablero; j++) {
        if (appData.board[i][j] == 'X' || appData.board[i][j] == 'XO') {
          // Dibuixar una X amb el color del jugador
          Color color = Colors.blue;
          switch (appData.colorPlayer) {
            case "Blau":
              color = Colors.blue;
              break;
            case "Verd":
              color = Colors.green;
              break;
            case "Gris":
              color = Colors.grey;
              break;
          }

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          drawImage(canvas, appData.imagePlayer!, x0, y0, x1, y1);
          // drawCross(canvas, x0, y0, x1, y1, color, 5.0);
        } else if (appData.board[i][j] == 'O') {
          // Dibuixar una O amb el color de l'oponent
          Color color = Colors.blue;
          switch (appData.colorOpponent) {
            case "Vermell":
              color = Colors.red;
              break;
            case "Taronja":
              color = Colors.orange;
              break;
            case "Marró":
              color = Colors.brown;
              break;
          }

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0) / 2;
          double radius = (min(cellWidth, cellHeight) / 2) - 5;

          drawImage(canvas, appData.imageOpponent!, x0, y0, x1, y1);
          // drawCircle(canvas, cX, cY, radius, color, 5.0);

        } else if (appData.board[i][j] == 'FlagRemove') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          // drawEmptySquare(canvas, Offset(x0, y0),Offset(x1, y1), Colors.white, 5.0);
          appData.board[i][j] = '-';
          print("Ha hecho doble click" + appData.board[i][j]);

        } else if (appData.board[i][j] == 'C') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          // pintar la casillas reveladas con marron suave
          drawEmptySquare(canvas, Offset(x0, y0),Offset(x1, y1), Colors.brown.shade400, 5.0);
        }
        
        else if (appData.isNumeric(appData.board[i][j])) {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          // pintar la casillas reveladas con marron suave
          drawEmptySquare(canvas, Offset(x0, y0),Offset(x1, y1), Colors.brown.shade400, 5.0);

          switch(appData.board[i][j]) {
              case "1":
              drawImage(canvas, appData.image1!, x0, y0, x1, y1);
              break;
              case "2":
              drawImage(canvas, appData.image2!, x0, y0, x1, y1);
              break;
              case "3":
              drawImage(canvas, appData.image3!, x0, y0, x1, y1);
              break;
              case "4":
              drawImage(canvas, appData.image4!, x0, y0, x1, y1);
              break;
              case "5":
              drawImage(canvas, appData.image5!, x0, y0, x1, y1);
              break;
              case "6":
              drawImage(canvas, appData.image6!, x0, y0, x1, y1);
              break;
              case "7":
              drawImage(canvas, appData.image7!, x0, y0, x1, y1);
              break;
              case "8":
              drawImage(canvas, appData.image8!, x0, y0, x1, y1);
              break;
          }
        }

      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size, String message) {

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }

  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    //
    appData.printBoardConsole();
    drawBoardStatus(canvas, size);
    // Comprueba estado del game
    appData.checkGameStatus();
    if (appData.gameIsOver) {
      if (appData.gameWinner == 'MINE') {
        drawGameOver(canvas, size, "Has perdut. Torna-ho a intentar.");
      }
      else {
        drawGameOver(canvas, size, "Has guanyat. Felicitats!");
      }
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
