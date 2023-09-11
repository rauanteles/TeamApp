import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pessoa.dart';

class SorteioPage extends StatefulWidget {
  final List<Pessoa> list;
  final int qtdSelecionada;
  final int qtdCoringas;
  const SorteioPage(this.list, this.qtdSelecionada, this.qtdCoringas,
      {super.key});

  @override
  State<SorteioPage> createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {
  var times = [];
  int pessoasPorTime = 2;

  List<List<Pessoa>> gerarTimes(List<Pessoa> pessoas, int tamanhoTime) {
    final times = <List<Pessoa>>[];
    List<List<Pessoa>> sorteados = [];

    final pessoasSelecionadas =
        List<Pessoa>.from(pessoas.where((pessoa) => pessoa.selecionado));

    final random = Random();

    final numTimes = (pessoasSelecionadas.length / tamanhoTime).ceil();

    final somaTotalNiveis =
        pessoasSelecionadas.fold(0.0, (soma, pessoa) => soma + pessoa.nivel!);

    final somaNiveisDesejada = (somaTotalNiveis / numTimes).abs().floor();

    var somaNiveisTime = double.infinity;

    bool deuCerto = false;
    List<Pessoa> organizaCoringa =
        pessoasSelecionadas.where((pessoa) => pessoa.coringa).toList();
    pessoasSelecionadas.shuffle(random);
    pessoasSelecionadas.removeWhere(
        (pessoasSelecionadas) => organizaCoringa.contains(pessoasSelecionadas));

    while (!deuCerto) {
      final coringas = organizaCoringa;

      for (int i = 0; i < coringas.length; i++) {
        pessoasSelecionadas.insert(i * tamanhoTime, coringas[i]);
      }

      for (var i = 0; i < numTimes; i++) {
        final time = pessoasSelecionadas.sublist(0, tamanhoTime);

        times.add(time);

        somaNiveisTime = time.fold(0.0, (soma, pessoa) => soma + pessoa.nivel!);
        print(coringas);
        bool verificaUltimo = i == 3;
        print("DESEJADA: $somaNiveisDesejada");
        print("TIMES: $times");
        print("TIME: $time");
        print("ULTIMO: ${verificaUltimo ? "SIM" : "NAO"}");
        print("SOMA TIME: $somaNiveisTime");

        if ((somaNiveisTime - somaNiveisDesejada).abs() <=
            ((verificaUltimo) ? 100 : 1.5)) {
          sorteados.add(time);
          print("SORTEADOS: $sorteados");
          pessoasSelecionadas.removeWhere(
              (pessoasSelecionadas) => time.contains(pessoasSelecionadas));
        } else {
          print("REINICIANDO");
          i--;
          pessoasSelecionadas.shuffle();
        }
        if (sorteados.length == numTimes) {
          deuCerto = true;
          break;
        }
      }
    }

    sorteados.shuffle(random);

    return sorteados;
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
        padding: const EdgeInsets.fromLTRB(16, 2, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Quantidade de pessoas por time:',
                  style: TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: DropdownButton<int>(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      final numTimes = widget.qtdSelecionada / pessoasPorTime;
                      if (widget.list.isEmpty ||
                          ((widget.qtdSelecionada % pessoasPorTime) > 0) ||
                          widget.qtdCoringas > numTimes) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text(
                                    'Valor Inválido!\nUm ou mais desses problemas foram encontrados'),
                                content: Text(
                                    '>> Lista ta vazia\n>> Vai ter time com pouca pessoa\n>> Mais capitães que times.\n\n!!calcula direito ai meu fi :(  !!'),
                              );
                            });
                      } else {
                        times = gerarTimes(widget.list, pessoasPorTime);
                        setState(() {});
                      }
                    },
                    child: const Text('Sortear'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: times.isEmpty
                  ? const Text("")
                  : ListView.builder(
                      itemCount: times.length,
                      itemBuilder: (BuildContext context, int index) {
                        final time = times[index];
                        final somaEstrelasTime =
                            time.fold(0, (soma, pessoa) => soma + pessoa.nivel);

                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Time ${index + 1}:',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        '$somaEstrelasTime',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              for (final pessoa in time)
                                ListTile(
                                  dense: true,
                                  title: Row(
                                    children: [
                                      Text(
                                        "${pessoa.nome}",
                                        style: TextStyle(
                                            color: pessoa.coringa
                                                ? Colors.pink
                                                : Colors.black),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "${pessoa.nivel}",
                                          style: TextStyle(
                                              color: pessoa.coringa
                                                  ? Colors.purple
                                                  : Colors.grey),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
