import 'package:flutter/material.dart';

import '../models/pessoa.dart';

class SorteioPage extends StatefulWidget {
  List<Pessoa> list;
  SorteioPage(this.list, {super.key});

  @override
  State<SorteioPage> createState() => _SorteioTelaState();
}

class _SorteioTelaState extends State<SorteioPage> {
  TextEditingController controllerNumJogadores = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Sorteio"),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 2, 0),
                child: Row(
                  children: [
                    const Text("Número de Jogadores por time: "),
                    SizedBox(
                      height: 20,
                      width: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: controllerNumJogadores,
                        autofocus: false,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: ElevatedButton(
                        child: const Text("Sortear"),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
