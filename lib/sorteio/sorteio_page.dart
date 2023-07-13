import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pessoa.dart';

class SorteioPage extends StatefulWidget {
  final int selecionados;
  final List<Pessoa> list;
  const SorteioPage(this.selecionados, this.list, {super.key});

  @override
  State<SorteioPage> createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {
  int pessoasPorTime = 2;

  List<List<Pessoa>> gerarTimes(List<Pessoa> pessoas, int tamanhoTime) {
    final pessoasSelecionadas =
        List<Pessoa>.from(pessoas.where((pessoa) => pessoa.selecionado));
    final random = Random();
    final times = <List<Pessoa>>[];
    final somaTotalNiveis = pessoasSelecionadas.fold(
        0.0, (soma, pessoa) => soma + (pessoa.nivel ?? 0.0));

    while (pessoasSelecionadas.isNotEmpty) {
      final time = <Pessoa>[];
      for (var i = 0; i < tamanhoTime && pessoasSelecionadas.isNotEmpty; i++) {
        final index = random.nextInt(pessoasSelecionadas.length);
        final pessoa = pessoasSelecionadas.removeAt(index);
        time.add(pessoa);
      }

      times.add(time);
      final somaTimes = somaTotalNiveis ~/ time.length;
      print(somaTimes);
    }

    print(somaTotalNiveis);
    print(times.length);
    print(times);

    return times;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorteio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quantidade de pessoas por time:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<int>(
              value: pessoasPorTime,
              onChanged: (newValue) {
                setState(() {
                  pessoasPorTime = newValue!;
                });
              },
              items: List.generate(14, (index) => index + 2)
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => gerarTimes(widget.list, pessoasPorTime),
              child: const Text('Sortear'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pessoas sorteadas:',
              style: TextStyle(fontSize: 16),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: pessoasSorteadas.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text(pessoasSorteadas[index]),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
