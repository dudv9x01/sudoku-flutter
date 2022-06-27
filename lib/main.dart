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
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
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
