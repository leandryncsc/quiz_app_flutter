import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Quiz extends StatefulWidget {
  final List<Map<String, dynamic>> quizFacil;
  final List<Map<String, dynamic>> quizMedio;
  final List<Map<String, dynamic>> quizDificil;
  final String nivelInicial;

  const Quiz({
    Key? key,
    required this.quizFacil,
    required this.quizMedio,
    required this.quizDificil,
    this.nivelInicial = 'fácil',
  }) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int perguntaNumero = 1;
  int acertos = 0;
  int erros = 0;
  late List<Map<String, dynamic>> perguntasEmbaralhadas;
  List<int> respostasUsuario = [];
  String nivelAtual = 'fácil';
  List<ResultadoQuiz> resultadosAcumulados = [];

  @override
  void initState() {
    super.initState();
    nivelAtual = widget.nivelInicial;
    _carregarPerguntas();
  }

  void _carregarPerguntas() {
    List<Map<String, dynamic>> perguntas;

    switch (nivelAtual) {
      case 'médio':
        perguntas = widget.quizMedio;
        break;
      case 'difícil':
        perguntas = widget.quizDificil;
        perguntas =
            perguntas.length > 20 ? perguntas.sublist(0, 20) : perguntas;
        break;
      default:
        perguntas = widget.quizFacil;
    }

    perguntasEmbaralhadas = List<Map<String, dynamic>>.from(perguntas);
    _embaralharPerguntas();
    respostasUsuario = List.filled(perguntasEmbaralhadas.length, -1);
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

  void responder(int respostaNumero) {
    setState(() {
      final perguntaAtual = perguntasEmbaralhadas[perguntaNumero - 1];
      respostasUsuario[perguntaNumero - 1] = respostaNumero;

      if (perguntaAtual['alternativa_correta'] == respostaNumero) {
        acertos++;
      } else {
        erros++;
      }

      if (kDebugMode) {
        print('Acertos totais: $acertos | Erros totais: $erros');
      }

      // Correção: Adicionados parênteses externos para agrupar toda a condição
      if ((perguntaNumero == 10 && nivelAtual == 'fácil') ||
          (perguntaNumero == 20 &&
              (nivelAtual == 'médio' || nivelAtual == 'difícil'))) {
        _mostrarDialogoMudancaNivel();
      } else if (perguntaNumero == perguntasEmbaralhadas.length) {
        _finalizarQuiz();
      } else {
        perguntaNumero++;
      }
    });
  }

  Future<void> _mostrarDialogoMudancaNivel() async {
    resultadosAcumulados.add(ResultadoQuiz(
      nivel: nivelAtual,
      acertos: acertos,
      totalPerguntas: nivelAtual == 'fácil' ? 10 : 20,
      perguntas: perguntasEmbaralhadas,
      respostasUsuario: respostasUsuario,
    ));

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Você completou o nível $nivelAtual!'),
        content: const Text(
            'Deseja avançar para o próximo nível ou repetir o atual?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                perguntaNumero = 1;
                acertos = 0;
                erros = 0;
                _embaralharPerguntas();
                respostasUsuario =
                    List.filled(perguntasEmbaralhadas.length, -1);
              });
            },
            child: const Text('Repetir nível'),
          ),
          if (nivelAtual != 'difícil')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  nivelAtual = nivelAtual == 'fácil' ? 'médio' : 'difícil';
                  perguntaNumero = 1;
                  acertos = 0;
                  erros = 0;
                  _carregarPerguntas();
                });
              },
              child: Text(
                  'Ir para ${nivelAtual == 'fácil' ? 'médio' : 'difícil'}'),
            ),
        ],
      ),
    );
  }

  void _finalizarQuiz() {
    resultadosAcumulados.add(ResultadoQuiz(
      nivel: nivelAtual,
      acertos: acertos,
      totalPerguntas: perguntasEmbaralhadas.length,
      perguntas: perguntasEmbaralhadas,
      respostasUsuario: respostasUsuario,
    ));

    Navigator.pushNamed(
      context,
      'Resultados',
      arguments: Argumentos(resultadosAcumulados),
    );
  }

  void _mostrarMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.blue),
                  title: const Text('Início',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restart_alt, color: Colors.green),
                  title: const Text('Reiniciar Quiz',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    if (mounted) {
                      setState(() {
                        perguntaNumero = 1;
                        acertos = 0;
                        erros = 0;
                        _embaralharPerguntas();
                        respostasUsuario =
                            List.filled(perguntasEmbaralhadas.length, -1);
                      });
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.orange),
                  title: const Text('Sobre',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        title: const Text('Sobre o Quiz',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content: const Text(
                            'Aplicativo de Quiz desenvolvido © Leandro Bezerra.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text('Sair',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sair do Aplicativo',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content: const Text('Deseja realmente sair do quiz?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              SystemNavigator.pop();
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (perguntasEmbaralhadas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('Nenhuma pergunta disponível',
              style: TextStyle(fontSize: 18)),
        ),
      );
    }

    if (perguntaNumero > perguntasEmbaralhadas.length || perguntaNumero < 1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Pergunta inválida', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    perguntaNumero = 1;
                    acertos = 0;
                    erros = 0;
                  });
                },
                child: const Text('Reiniciar Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    final perguntaAtual = perguntasEmbaralhadas[perguntaNumero - 1];
    final respostas =
        (perguntaAtual['respostas'] as List?)?.cast<String>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Quiz - Nível $nivelAtual')),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _mostrarMenu(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Pergunta $perguntaNumero',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        perguntaAtual['pergunta'] ?? 'Pergunta não disponível',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: respostas.asMap().entries.map((entry) {
                  final index = entry.key;
                  final resposta = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => responder(index + 1),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        resposta,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: perguntaNumero / perguntasEmbaralhadas.length,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultadoQuiz {
  final String nivel;
  final int acertos;
  final int totalPerguntas;
  final List<Map<String, dynamic>> perguntas;
  final List<int> respostasUsuario;

  ResultadoQuiz({
    required this.nivel,
    required this.acertos,
    required this.totalPerguntas,
    required this.perguntas,
    required this.respostasUsuario,
  });
}

class Argumentos {
  final List<ResultadoQuiz> resultados;

  Argumentos(this.resultados);
}
