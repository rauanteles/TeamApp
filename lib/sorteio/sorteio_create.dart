import 'package:flutter/material.dart';

import '../models/pessoa.dart';

class Sorteio extends StatefulWidget {
  final List<Pessoa> list;
  const Sorteio(this.list, {super.key});

  @override
  State<Sorteio> createState() => _SorteioState();
}

class _SorteioState extends State<Sorteio> {
  gerarMapasTimes(nJogadores, selecionados, list) {
    int x = selecionados / nJogadores;
    Map<List<String>, List<Pessoa>> times = <List<String>, List<Pessoa>>{};
    for (var i = 0; i < x; i++) {
      for (Pessoa p in widget.list) {
        times[['Time $i']] = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
