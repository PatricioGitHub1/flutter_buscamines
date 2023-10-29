import 'package:flutter/cupertino.dart';
import 'widget_tresratlla.dart';
import 'app_data.dart';
import 'package:provider/provider.dart';

class LayoutPlay extends StatefulWidget {
  const LayoutPlay({Key? key}) : super(key: key);

  @override
  LayoutPlayState createState() => LayoutPlayState();
}

class LayoutPlayState extends State<LayoutPlay> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    String getTrailingText() {
          int flagsLeft = appData.numeroMinas-appData.currentFlagsUsed; 
          return "Flags Left: $flagsLeft";
        }

    String getTimerText() {
      if (!appData.firstSquareSelected) {
        return "Partida";
      }
      int timerSeconds = appData.gameTime;
      int minutes = timerSeconds ~/ 60; 
      int seconds = timerSeconds % 60; 

      String formattedMinutes = minutes.toString().padLeft(2, '0');
      String formattedSeconds = seconds.toString().padLeft(2, '0');

      return "$formattedMinutes : $formattedSeconds";
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(getTimerText()),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        trailing: Text(getTrailingText()),
      ),
      child: const SafeArea(
        child: WidgetTresRatlla(),
      ),
    );
  }
}
