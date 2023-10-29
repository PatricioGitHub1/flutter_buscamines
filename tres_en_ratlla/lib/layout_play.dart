import 'package:flutter/cupertino.dart';
import 'widget_tresratlla.dart';

class LayoutPlay extends StatefulWidget {

  // final int timerValue; // Add timerValue as a parameter
  final int gameTime, numeroMinas, numeroBanderes;

  const LayoutPlay({Key? key, required this.gameTime, required this.numeroMinas, required this.numeroBanderes}) : super(key: key);

  @override
  LayoutPlayState createState() => LayoutPlayState();
}

class LayoutPlayState extends State<LayoutPlay> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Text("Temps transcorregut: ${widget.gameTime}"),
        trailing: Text("Mines: ${widget.numeroMinas}  /  Banderes: ${widget.numeroBanderes}"),
      ),
      child: const SafeArea(
        child: WidgetTresRatlla(),
      ),
    );
  }
}
