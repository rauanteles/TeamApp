// import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pessoa.dart';

// ignore: must_be_immutable
class SorteioPage extends StatefulWidget {
  final List<Pessoa> list;
  final int selecionados;
  const SorteioPage(this.selecionados, this.list, {super.key});

  @override
  State<SorteioPage> createState() => _SorteioTelaState();
}

class _SorteioTelaState extends State<SorteioPage> {
  TextEditingController controllerNumJogadores = TextEditingController();

  // gerarMapasTimes(int nJogadores, int selecionados, list) {
  //   if (nJogadores == 0 || (selecionados % nJogadores) > 0) {
  //     return showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => const Dialog(
  //         child: Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Text(
  //                 'Número de jogadores inválido para o número de times',
  //                 style: TextStyle(fontSize: 20),
  //               ),
  //               SizedBox(height: 15),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     int x = (selecionados ~/ nJogadores);
  //     List<List<String>> times = [];
  //     List<String> time = [];
  //     List<String> nomesSelecionados = [];

  //     for (Pessoa p in widget.list) {
  //       if (p.selecionado) {
  //         nomesSelecionados.add(p.nome!);
  //       }
  //     }
  //     for (var i = 0; i < x; i++) {
  //       times.add(time);
  //     }
  //     // List<int> listaLixo = [];
  //     // for (var i = 0; i < x; i++) {
  //     //   for (var i = 0; i < nJogadores; i++) {
  //     //     var intValue = Random().nextInt(nomesSelecionados.length);
  //     //     if (!listaLixo.contains(intValue)) {
  //     //       times[0].add(nomesSelecionados[intValue]);
  //     //       listaLixo.add(intValue);
  //     //     } else {
  //     //       i--;
  //     //     }
  //     //   }
  //     // }

  //     debugPrint("nomes selecionados: $nomesSelecionados");
  //     debugPrint("qtd de times: $times");
  //     debugPrint("qtd de time: $time");

  //     // debugPrint("Time 1: ${times[0]}");
  //     // debugPrint("Time 2: ${times[1]}");
  //   }
  // }
  List<List<Pessoa>> criarTimes(
      int pessoasPorTime, int pessoasSelecionadas, List<Pessoa> pessoas) {
    if (pessoasSelecionadas % pessoasPorTime != 0) {
      throw Exception('Não é possível formar times igualmente distribuídos.');
    }

    // Embaralhar a lista de pessoas
    pessoas.shuffle();

    List<List<Pessoa>> times = [];
    int numTimes = pessoasSelecionadas ~/ pessoasPorTime; // Número de times

    for (int i = 0; i < numTimes; i++) {
      List<Pessoa> time = [];
      for (int j = 0; j < pessoasPorTime; j++) {
        int index = i * pessoasPorTime + j;
        time.add(pessoas[index]);
      }
      times.add(time);
    }
    debugPrint("$times");
    return times;
  }

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
                        onPressed: () {
                          if (int.parse(controllerNumJogadores.text) %
                                  widget.selecionados !=
                              0) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => const Dialog(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Número de jogadores inválido para o número de times',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            return;
                          }
                          criarTimes(int.parse(controllerNumJogadores.text),
                              widget.selecionados, widget.list);
                        },
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
