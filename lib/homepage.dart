import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Quiz')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/logo.jpg'),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'Quiz');
                    },
                    child: Text('Jogar', style: TextStyle(fontSize: 50)),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(100, 20, 100, 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
