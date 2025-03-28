import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Argumentos {
  final int acertos;
  final int totalPerguntas;
  final List<Map<String, dynamic>> perguntas;
  final List<int> respostasUsuario;

  Argumentos(
      this.acertos, this.totalPerguntas, this.perguntas, this.respostasUsuario);
}

class Resultado extends StatelessWidget {
  static const routeName = 'Resultados';

  const Resultado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)?.settings.arguments as Argumentos;
    final double porcentagem =
        (argumentos.acertos / argumentos.totalPerguntas) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Resultados', style: TextStyle(fontSize: 18)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetalhesResultados(argumentos: argumentos),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  'Resultado Final',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '${argumentos.acertos} / ${argumentos.totalPerguntas}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: porcentagem >= 60 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${porcentagem.toStringAsFixed(1)}% de acerto',
                  style: TextStyle(
                    fontSize: 20,
                    color: porcentagem >= 60 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'Quiz');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Jogar Novamente',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalhesResultados(argumentos: argumentos),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Ver Detalhes',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Sair do Aplicativo',
                            style: TextStyle(fontSize: 16),
                          ),
                          content: const Text(
                            'Deseja realmente sair do quiz?',
                            style: TextStyle(fontSize: 14),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            TextButton(
                              onPressed: () => SystemNavigator.pop(),
                              child: const Text(
                                'Sair',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Sair',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetalhesResultados extends StatelessWidget {
  final Argumentos argumentos;

  const DetalhesResultados({Key? key, required this.argumentos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes das Respostas'),
      ),
      body: ListView.builder(
        itemCount: argumentos.totalPerguntas,
        itemBuilder: (context, index) {
          final pergunta = argumentos.perguntas[index];
          final respostaUsuario = argumentos.respostasUsuario[index];
          final respostaCorreta = pergunta['alternativa_correta'] as int;
          final acertou = respostaUsuario == respostaCorreta;

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Pergunta ${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pergunta['pergunta']),
                  const SizedBox(height: 8),
                  Text(
                    'Sua resposta: ${pergunta['respostas'][respostaUsuario - 1]}',
                    style: TextStyle(
                      color: acertou ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Resposta correta: ${pergunta['respostas'][respostaCorreta - 1]}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              trailing: Icon(
                acertou ? Icons.check : Icons.close,
                color: acertou ? Colors.green : Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
