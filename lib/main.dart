import 'package:flutter/material.dart';

import 'homepage.dart';
import 'quiz.dart';
import 'resultados.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
        'Quiz': (context) => Quiz(
              quiz: [0],
            ),
        Resultado.routeName: (context) => Resultado()
      },
    );
  }
}
