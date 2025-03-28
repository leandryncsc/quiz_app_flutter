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
  Argumentos(this.resultadosPorNivel);
}

class Resultado extends StatelessWidget {
  static const routeName = 'Resultados';

  const Resultado({Key? key}) : super(key: key);

  void _mostrarDetalhesNivel(BuildContext context, ResultadoQuiz resultado) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detalhes - Nível ${resultado.nivel}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: resultado.totalPerguntas,
                itemBuilder: (context, index) {
                  final pergunta = resultado.perguntas[index];
                  final respostaUsuario = resultado.respostasUsuario[index];
                  final respostaCorreta =
                      pergunta['alternativa_correta'] as int;
                  final acertou = respostaUsuario == respostaCorreta;
                  final todasRespostas = pergunta['respostas'] as List<String>;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: acertou ? Colors.green[50] : Colors.red[50],
                    child: ExpansionTile(
                      title: Text(
                        'Pergunta ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: acertou ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                      leading: Icon(
                        acertou ? Icons.check_circle : Icons.error,
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Alternativas:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...todasRespostas.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final resposta = entry.value;
                                final isRespostaUsuario =
                                    (idx + 1) == respostaUsuario;
                                final isRespostaCorreta =
                                    (idx + 1) == respostaCorreta;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isRespostaCorreta
                                        ? Colors.green[100]
                                        : isRespostaUsuario
                                            ? Colors.red[100]
                                            : Colors.grey[100],
                                    border: Border.all(
                                      color: isRespostaCorreta
                                          ? Colors.green
                                          : isRespostaUsuario
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      if (isRespostaCorreta)
                                        const Icon(Icons.check,
                                            color: Colors.green, size: 16),
                                      if (isRespostaUsuario &&
                                          !isRespostaCorreta)
                                        const Icon(Icons.close,
                                            color: Colors.red, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(resposta)),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),
                              Text(
                                acertou
                                    ? 'Você acertou!'
                                    : 'Você errou esta questão',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: acertou ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  return GestureDetector(
                    onTap: () => _mostrarDetalhesNivel(context, resultado),
                    child: Card(
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
