import 'package:flutter/material.dart';

import 'package:quiz_app_flutter/resultados.dart';

import 'quiz_dados.dart';

class Quiz extends StatefulWidget {
  Quiz({Key? key, required this.quiz}) : super(key: key);

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

    quiz.forEach(
      (elemento) {
        int alternativaCorreta = elemento['alternativa_correta'];
        List respostas = elemento['respostas'];

        String respostaCorreta = elemento['respostas'][alternativaCorreta - 1];
        //print(respostaCorreta);

        respostas.shuffle();
        int i = 1;
        respostas.forEach(
          (elemento) {
            //print(elemento);
            if (elemento == respostaCorreta) {
              alternativaCorreta = i;
            }
            i++;
          },
        );
        elemento['alternativa_correta'] = alternativaCorreta;
      },
    );

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
        print('acertos totais: $acertos erros totais: $erros');

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
          title: Center(child: Text('Quiz')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Pergunta $perguntaNumero de 10',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text(
                'Pergunta: \n\n' + quiz[perguntaNumero - 1]['pergunta'],
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(1);
                  },
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][0],
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(2);
                  },
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][1],
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(3);
                  },
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][2],
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    respondeu(4);
                  },
                  child: Text(
                    quiz[perguntaNumero - 1]['respostas'][3],
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
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
