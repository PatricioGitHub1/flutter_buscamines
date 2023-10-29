import 'package:flutter/cupertino.dart';
import 'layout_intro.dart';
import 'layout_settings.dart';
import 'layout_play.dart';
import 'app_data.dart';

// Main application widget
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Main application state
class AppState extends State<App> {
  final AppData appData = AppData();
  // Definir el contingut del widget 'App'
  @override
  Widget build(BuildContext context) {
    // Farem servir la base 'Cupertino'
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: const LayoutIntro(),
      routes: {
        'intro': (context) => const LayoutIntro(),
        'settings': (context) => const LayoutSettings(),
        'play': (context) => LayoutPlay(gameTime: appData.gameTime, numeroMinas: appData.numeroMinas, numeroBanderes: appData.numeroBanderes),
      },
    );
  }
}
