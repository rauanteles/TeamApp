import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pessoa.dart';

import 'package:flutter/services.dart';

class SorteioPage extends StatefulWidget {
  final int qtdCoringas;
  final List<Pessoa> list;
  final int qtdSelecionada;
  const SorteioPage(this.list, this.qtdSelecionada, this.qtdCoringas,
      {super.key});

  @override
  State<SorteioPage> createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {
  var times = [];
  int pessoasPorTime = 2;
  String listaCopiar = "";
  bool verificaCoringa(List<Pessoa> time, List<Pessoa> coringas) {
    return time.any((pessoa) => coringas.contains(pessoa));
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    final snackBar = SnackBar(
      content: Text('Texto copiado para a área de transferência'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<List<Pessoa>> gerarTimes(List<Pessoa> pessoas, int tamanhoTime) {
    final pessoasSelecionadas =
        List<Pessoa>.from(pessoas.where((pessoa) => pessoa.selecionado));
    //print("SIM SELECT: $pessoasSelecionadas");
    // final pessoasNaoSelecionadas =
    List<Pessoa>.from(pessoas.where((pessoa) => pessoa.selecionado));
    // print("NAO SELECT: $pessoasNaoSelecionadas");

    final random = Random();

    final times = <List<Pessoa>>[];

    final numTimes = (pessoasSelecionadas.length / tamanhoTime).ceil();

    final somaTotalNiveis =
        pessoasSelecionadas.fold(0.0, (soma, pessoa) => soma + pessoa.nivel!);

    final somaNiveisDesejada = somaTotalNiveis / numTimes;

    var somaNiveisTime = double.infinity;

    bool deuCerto = false;
    List<List<Pessoa>> sorteados = [];
    List<Pessoa> organizaCoringa =
        pessoasSelecionadas.where((pessoa) => pessoa.coringa).toList();
    pessoasSelecionadas.shuffle(random);
    pessoasSelecionadas.removeWhere(
        (pessoasSelecionadas) => organizaCoringa.contains(pessoasSelecionadas));

    while (!deuCerto) {
      pessoasSelecionadas.shuffle(random);
      final coringas = organizaCoringa;

      for (int i = 0; i < coringas.length; i++) {
        pessoasSelecionadas.insert(i * tamanhoTime, coringas[i]);
      }

      for (var i = 0; i < numTimes; i++) {
        final time = pessoasSelecionadas.sublist(0, tamanhoTime);
        //final coringas = time.where((pessoa) => pessoa.coringa).toList();

        times.add(time);

        somaNiveisTime = time.fold(0.0, (soma, pessoa) => soma + pessoa.nivel!);

        bool verificaUltimo = (pessoasSelecionadas.length == tamanhoTime);

        if (((somaNiveisTime - somaNiveisDesejada).abs() <=
            (verificaUltimo ? 3 : 0.5))) {
          //if (time.any((pessoa) => coringas.contains(pessoa))) {}
          sorteados.add(time);
          pessoasSelecionadas.removeWhere(
              (pessoasSelecionadas) => time.contains(pessoasSelecionadas));
          coringas.removeWhere((coringas) => time.contains(coringas));
        } else {
          i--;
          pessoasSelecionadas.shuffle(random);

          pessoasSelecionadas.removeWhere(
              (pessoasSelecionadas) => coringas.contains(pessoasSelecionadas));
          for (int i = 0; i < coringas.length; i++) {
            pessoasSelecionadas.insert(i * tamanhoTime, coringas[i]);
          }
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

  String formataTimes(List<dynamic> times) {
    String result = '';

    for (int i = 0; i < times.length; i++) {
      result += '*TIME ${i + 1}*\n';
      result += times[i].map((num) => num.toString()).join('\n');
      result += '\n\n';
    }

    return result;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              copyToClipboard(listaCopiar);
            },
          )
        ],
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
                      if (widget.list.isEmpty ||
                          ((widget.qtdSelecionada % pessoasPorTime) > 0)) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text('Valor Inválido!'),
                                content: Text(
                                    'Ou a lista ta vazia ou vai ter time com pouca pessoa, calcula direito ai meu fi :('),
                              );
                            });
                      } else {
                        times = gerarTimes(widget.list, pessoasPorTime);
                        String formatado = formataTimes(times);
                        listaCopiar = formatado;
                        setState(() {});
                        print(formatado);
                      }
                    },
                    child: const Text('Sortear'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Pessoas sorteadas:',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: times.isEmpty
                  ? const Text("nada a exibir")
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
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Time ${index + 1}:',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '$somaEstrelasTime',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              for (final pessoa in time)
                                ListTile(
                                  dense: true,
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text("${pessoa.nome}",
                                      style: TextStyle(
                                          color: pessoa.coringa
                                              ? Colors.pink
                                              : Colors.black)),
                                  subtitle: Text("${pessoa.nivel}"),
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
