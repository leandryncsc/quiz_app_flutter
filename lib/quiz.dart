import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_flutter/resultados.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key, required this.quiz}) : super(key: key);

  final List<Map<String, dynamic>> quiz;
  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int perguntaNumero = 1;
  int acertos = 0;
  int erros = 0;
  late List<Map<String, dynamic>> perguntasEmbaralhadas;

  @override
  void initState() {
    super.initState();
    // Garante que estamos trabalhando com uma cópia da lista original
    perguntasEmbaralhadas = List<Map<String, dynamic>>.from(widget.quiz);
    _embaralharPerguntas();
  }

  void _embaralharPerguntas() {
    perguntasEmbaralhadas.shuffle();

    for (var pergunta in perguntasEmbaralhadas) {
      final alternativaCorretaOriginal = pergunta['alternativa_correta'] as int;
      final respostas = List<String>.from(pergunta['respostas'] as List);
      final respostaCorreta = respostas[alternativaCorretaOriginal - 1];

      respostas.shuffle();

      pergunta['respostas'] = respostas;
      pergunta['alternativa_correta'] = respostas.indexOf(respostaCorreta) + 1;
    }
  }

  void respondeu(int respostaNumero) {
    setState(() {
      final perguntaAtual = perguntasEmbaralhadas[perguntaNumero - 1];

      if (perguntaAtual['alternativa_correta'] == respostaNumero) {
        acertos++;
      } else {
        erros++;
      }

      if (kDebugMode) {
        print('acertos totais: $acertos erros totais: $erros');
      }

      if (perguntaNumero == perguntasEmbaralhadas.length) {
        Navigator.pushNamed(
          context,
          'Resultados',
          arguments: Argumentos(acertos, perguntasEmbaralhadas.length),
        );
      } else {
        perguntaNumero++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verificação de segurança
    if (perguntasEmbaralhadas.isEmpty ||
        perguntaNumero > perguntasEmbaralhadas.length) {
      return const Scaffold(
        body: Center(child: Text('Nenhuma pergunta disponível')),
      );
    }

    final perguntaAtual = perguntasEmbaralhadas[perguntaNumero - 1];
    final respostas = perguntaAtual['respostas'] as List<String>;

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
                  'Pergunta $perguntaNumero de ${perguntasEmbaralhadas.length}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  'Pergunta: \n\n${perguntaAtual['pergunta']}',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              ...respostas.asMap().entries.map((entry) {
                final index = entry.key;
                final resposta = entry.value;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      respondeu(index + 1);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      resposta,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
