import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // Para SystemNavigator
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
  List<int> respostasUsuario =
      []; // Adicionei esta linha para armazenar as respostas

  @override
  void initState() {
    super.initState();
    // Garante que estamos trabalhando com uma cópia da lista original
    perguntasEmbaralhadas = List<Map<String, dynamic>>.from(widget.quiz);
    _embaralharPerguntas();
    respostasUsuario =
        List.filled(perguntasEmbaralhadas.length, 0); // Inicializa a lista
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

      // Armazena a resposta do usuário
      respostasUsuario[perguntaNumero - 1] = respostaNumero;

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
          arguments: Argumentos(
            acertos,
            perguntasEmbaralhadas.length,
            perguntasEmbaralhadas,
            respostasUsuario,
          ),
        );
      } else {
        perguntaNumero++;
      }
    });
  }

  void _mostrarMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Início'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/', // Ou o nome da rota da sua Homepage
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reiniciar Quiz'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    perguntaNumero = 1;
                    acertos = 0;
                    erros = 0;
                    _embaralharPerguntas();
                    respostasUsuario =
                        List.filled(perguntasEmbaralhadas.length, 0);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Sobre'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sobre o Quiz'),
                      content: const Text(
                          'Aplicativo de Quiz desenvolvido © Leandro Bezerra.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Novo botão de Sair
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context); // Fecha o menu
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sair do Aplicativo'),
                      content: const Text('Deseja realmente sair do quiz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fecha o diálogo
                            SystemNavigator.pop(); // Fecha o aplicativo
                          },
                          child: const Text('Sair',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
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
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _mostrarMenu(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Reduzi o padding geral
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Pergunta $perguntaNumero de ${perguntasEmbaralhadas.length}',
                  style: const TextStyle(fontSize: 18), // Fonte reduzida
                ),
              ),
              Center(
                child: Text(
                  'Pergunta: \n\n${perguntaAtual['pergunta']}',
                  style: const TextStyle(fontSize: 18), // Fonte reduzida
                  textAlign: TextAlign.center,
                ),
              ),
              ...respostas.asMap().entries.map((entry) {
                final index = entry.key;
                final resposta = entry.value;

                return SizedBox(
                  width: double.infinity,
                  height: 60, // Altura fixa para todos os botões
                  child: ElevatedButton(
                    onPressed: () {
                      respondeu(index + 1);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16), // Padding horizontal reduzido
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Borda mais suave
                      ),
                    ),
                    child: Text(
                      resposta,
                      style: const TextStyle(fontSize: 16), // Fonte reduzida
                      textAlign: TextAlign.center,
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
