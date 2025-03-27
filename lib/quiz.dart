import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:quiz_app_flutter/resultados.dart';

import 'quiz_dados.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key, required this.quiz}) : super(key: key);

  final List quiz;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int perguntaNumero = 1;
  int acertos = 0;
  int erros = 0;
  @override
  Widget build(BuildContext context) {
    quiz.shuffle();

    for (var elemento in quiz) {
      int alternativaCorreta = elemento['alternativa_correta'];
      List respostas = elemento['respostas'];

      String respostaCorreta = elemento['respostas'][alternativaCorreta - 1];
      //print(respostaCorreta);

      respostas.shuffle();
      int i = 1;
      for (var elemento in respostas) {
        //print(elemento);
        if (elemento == respostaCorreta) {
          alternativaCorreta = i;
        }
        i++;
      }
      elemento['alternativa_correta'] = alternativaCorreta;
    }

    /*
    quiz.add({
      "pergunta": "O Flutter é ?",
      "respostas": [
        "uma linguagem",
        "um aplicativo",
        "um SDK",
        "um notebook",
      ],
      "alternativa_correta": 3,
    });

    for (int i = 3; i <= 20; i++) {
      quiz.add({
        "pergunta": "pergunta $i",
        "respostas": [
          "resposta 1",
          "resposta 2",
          "resposta 3",
          "resposta 4",
        ],
        "alternativa_correta": 3,
      });
    }
    */

    void respondeu(int respostaNumero) {
      setState(() {
        if (quiz[perguntaNumero - 1]['alternativa_correta'] == respostaNumero) {
          acertos++;
        } else {
          erros++;
        }
        if (kDebugMode) {
          print('acertos totais: $acertos erros totais: $erros');
        }

        if (perguntaNumero == 10) {
          Navigator.pushNamed(context, 'Resultados',
              arguments: Argumentos(acertos));
        } else {
          perguntaNumero++;
        }
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Quiz')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Pergunta $perguntaNumero de 10',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  'Pergunta: \n\n  ${quiz[perguntaNumero - 1]['pergunta']}',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(1);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][0],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(2);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][1],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(3);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][2],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(4);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][3],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
