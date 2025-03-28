import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  double get porcentagem => (acertos / totalPerguntas) * 100;
}

class Argumentos {
  final List<ResultadoQuiz> resultadosPorNivel;

  Argumentos(this.resultadosPorNivel, int length);
}

class Resultado extends StatelessWidget {
  static const routeName = 'Resultados';

  const Resultado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)?.settings.arguments as Argumentos;

// Calcula totais consolidados
    final totalAcertos = argumentos.resultadosPorNivel
        .fold<int>(0, (int sum, ResultadoQuiz item) => sum + item.acertos);

    final totalPerguntas = argumentos.resultadosPorNivel.fold<int>(
        0, (int sum, ResultadoQuiz item) => sum + item.totalPerguntas);

    final double porcentagemTotal =
        totalPerguntas > 0 ? (totalAcertos / totalPerguntas) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Consolidados',
            style: TextStyle(fontSize: 18)),
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
          children: [
            // Resultado geral
            Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Total Geral',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      '$totalAcertos / $totalPerguntas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            porcentagemTotal >= 60 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${porcentagemTotal.toStringAsFixed(1)}% de acerto',
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            porcentagemTotal >= 60 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Resultados por nível
            Expanded(
              child: ListView.builder(
                itemCount: argumentos.resultadosPorNivel.length,
                itemBuilder: (context, index) {
                  final resultado = argumentos.resultadosPorNivel[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Nível ${resultado.nivel}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${resultado.acertos}/${resultado.totalPerguntas} perguntas'),
                          Text(
                            '${resultado.porcentagem.toStringAsFixed(1)}% de acerto',
                            style: TextStyle(
                              color: resultado.porcentagem >= 60
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        resultado.porcentagem >= 60
                            ? Icons.check_circle
                            : Icons.warning,
                        color: resultado.porcentagem >= 60
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botões de ação
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, 'Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Jogar Novamente',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => SystemNavigator.pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.red[400],
                    ),
                    child: const Text('Sair', style: TextStyle(fontSize: 16)),
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
    return DefaultTabController(
      length: argumentos.resultadosPorNivel.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes por Nível'),
          bottom: TabBar(
            tabs: argumentos.resultadosPorNivel
                .map((resultado) => Tab(text: resultado.nivel))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: argumentos.resultadosPorNivel.map((resultado) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: resultado.totalPerguntas,
              itemBuilder: (context, index) {
                final pergunta = resultado.perguntas[index];
                final respostaUsuario = resultado.respostasUsuario[index];
                final respostaCorreta = pergunta['alternativa_correta'] as int;
                final acertou = respostaUsuario == respostaCorreta;

                return Card(
                  margin: const EdgeInsets.all(4),
                  child: ExpansionTile(
                    title: Text('Pergunta ${index + 1}'),
                    leading: Icon(
                      acertou ? Icons.check : Icons.close,
                      color: acertou ? Colors.green : Colors.red,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pergunta['pergunta'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sua resposta: ${pergunta['respostas'][respostaUsuario - 1]}',
                              style: TextStyle(
                                color: acertou ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Resposta correta: ${pergunta['respostas'][respostaCorreta - 1]}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
