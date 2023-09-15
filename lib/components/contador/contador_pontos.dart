import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContadorPage(),
    );
  }
}

class ContadorPage extends StatefulWidget {
  @override
  _ContadorPageState createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  @override
  void initState() {
    super.initState();
    // Define a orientação para paisagem quando a tela for criada
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    // Retorna às preferências de orientação padrão quando a tela for descartada
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  int pontosTime1 = 0;
  int pontosTime2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 40,
        title: const Text('Contador de Pontos'),
        actions: [
          // Botão de configurações na AppBar
          IconButton(
              onPressed: () {
                pontosTime1 = 0;
                pontosTime2 = 0;
                setState(() {});
              },
              icon: const Icon(Icons.settings_backup_restore)),
        ],
      ),
      body: Row(
        children: [
          // Metade esquerda da tela para o Time 1
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pontosTime1++;
                });
              },
              onLongPress: () {
                setState(() {
                  pontosTime1--;
                });
              },
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    '$pontosTime1',
                    style: TextStyle(fontSize: 250, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // Metade direita da tela para o Time 2
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pontosTime2++;
                });
              },
              onLongPress: () {
                setState(() {
                  pontosTime2--;
                });
              },
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    '$pontosTime2',
                    style: TextStyle(fontSize: 250, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
