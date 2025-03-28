import 'package:flutter/material.dart';
import 'homepage.dart';
import 'quiz.dart';
import 'resultados.dart';
import 'quiz_dados.dart';

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
        '/': (context) => const Homepage(),
        'Quiz': (context) => Quiz(
              quizFacil: quizFacil,
              quizMedio: quizMedio,
              quizDificil: quizDificil,
              nivelInicial: 'fácil',
            ),
        Resultado.routeName: (context) => const Resultado(),
      },
    );
  }
}