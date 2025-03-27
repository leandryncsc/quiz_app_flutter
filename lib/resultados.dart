import 'package:flutter/material.dart';

class Argumentos {
  int acertos = 0;

  Argumentos(this.acertos);
}

class Resultado extends StatelessWidget {
  static const routeName = 'Resultados';

  const Resultado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)?.settings.arguments as Argumentos;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Quiz')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Resultado', style: TextStyle(fontSize: 20)),
              Text('Você acertou\n${argumentos.acertos} de 10\nperguntas',
                  style: const TextStyle(fontSize: 20)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Quiz');
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: const Text(
                    'Jogar Novamente',
                    style: TextStyle(fontSize: 30),
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
