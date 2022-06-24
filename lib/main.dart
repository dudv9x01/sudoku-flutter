import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:sudoku/page/bootstrap.dart';
import 'package:sudoku/page/sudoku_game.dart';
import 'package:sudoku/state/sudoku_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future<SudokuState> _loadState() async {
    SudokuState sudokuState = await SudokuState.resumeFromDB();
    return sudokuState;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SudokuState>(
      future: _loadState(),
      builder: (context, AsyncSnapshot<SudokuState> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Center(
                  child: Text('Sudoku loading...',
                      style: TextStyle(color: Colors.black),
                      textDirection: TextDirection.ltr)));
        }

        SudokuState sudokuState = snapshot.data!;
        BootstrapPage bootstrapPage = BootstrapPage();
        SudokuGamePage sudokuGamePage = SudokuGamePage(title: "Sudoku");

        return ScopedModel(
          model: sudokuState,
          child: MaterialApp(
            title: 'Sudoku',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: bootstrapPage,
            routes: <String, WidgetBuilder>{
              "/bootstrap": (context) => bootstrapPage,
              "/newGame": (context) =>
                  SudokuGamePage(title: "Sudoku"),
              "/gaming": (context) => sudokuGamePage
            },
          ),
        );
      },
    );
  }
}
