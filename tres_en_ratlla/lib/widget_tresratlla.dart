import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'widget_tresratlla_painter.dart';

class WidgetTresRatlla extends StatefulWidget {
  const WidgetTresRatlla({Key? key}) : super(key: key);

  @override
  WidgetTresRatllaState createState() => WidgetTresRatllaState();
}

class WidgetTresRatllaState extends State<WidgetTresRatlla> {
  Future<void>? _loadImagesFuture;

  // Al iniciar el widget, carrega les imatges
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppData appData = Provider.of<AppData>(context, listen: false);
      _loadImagesFuture = appData.loadImages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final int row =
            (details.localPosition.dy / (context.size!.height / appData.midaTablero)).floor();
        final int col =
            (details.localPosition.dx / (context.size!.width / appData.midaTablero)).floor();

        //appData.playMove(row, col);

        appData.selectSquare(row,col);
        setState(() {}); // Actualitza la vista
      }, onDoubleTapDown: (details) {
        final int row =
            (details.localPosition.dy / (context.size!.height / appData.midaTablero)).floor();
        final int col =
            (details.localPosition.dx / (context.size!.width / appData.midaTablero)).floor();
        appData.placeRemoveFlag(row, col);
        print("Bandera usadas = "+(appData.numeroMinas-appData.currentFlagsUsed).toString());
        setState(() {}); // Actualitza la vista
      },
      child: SizedBox(
        width: MediaQuery.of(context)
            .size
            .width, // Ocupa tot l'ample de la pantalla
        height: MediaQuery.of(context).size.height -
            56.0, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
        child: FutureBuilder(
          // Segons si les imatges estan disponibles mostra un progrés o el joc
          future: _loadImagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CupertinoActivityIndicator();
            } else {
              return GestureDetector(
                onTapUp: (TapUpDetails details) {
                  final int row =
                      (details.localPosition.dy / (context.size!.height / appData.midaTablero))
                          .floor();
                  final int col =
                      (details.localPosition.dx / (context.size!.width / appData.midaTablero))
                          .floor();

                  //appData.playMove(row, col);
                  appData.selectSquare(row,col);
                  setState(() {}); // Actualitza la vista
                }, /*onDoubleTapDown: (details) {
                    final int row =
                        (details.localPosition.dy / (context.size!.height / appData.midaTablero)).floor();
                    final int col =
                        (details.localPosition.dx / (context.size!.width / appData.midaTablero)).floor();
                    appData.placeRemoveFlag(row, col);
                    setState(() {}); // Actualitza la vista
                  },*/
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Ocupa tot l'ample de la pantalla
                  height: MediaQuery.of(context).size.height -
                      56.0 * 2, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
                  child: CustomPaint(
                    painter: WidgetTresRatllaPainter(appData),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
