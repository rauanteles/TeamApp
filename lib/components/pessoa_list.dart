import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:groupapp/components/pessoa_form.dart';

import '../models/pessoa.dart';

class PessoaList extends StatefulWidget {
  const PessoaList({super.key});

  @override
  State<PessoaList> createState() => _PessoaListState();
}

class _PessoaListState extends State<PessoaList> {
  bool checkedJoker = false;
  bool selecionado = false;
  bool filterList = false;
  int qtdSelecionada = 0;
  late String swipeDirection;
  TextEditingController controller = TextEditingController();
  List<Pessoa> pessoa = pessoas;

  static List<Pessoa> pessoas = [];
  addPessoa(String nome, double nivel) {
    final newPessoa = Pessoa(
      id: Random().nextDouble().toString(),
      nome: nome,
      nivel: nivel,
      coringa: false,
      selecionado: true,
    );

    setState(() {
      pessoas.add(newPessoa);
    });

    int x = 0;
    for (Pessoa p in pessoas) {
      if (p.selecionado) {
        x++;
      }
    }
    qtdSelecionada = x;
  }

  _removePessoa(String id) {
    setState(() {
      pessoas.removeWhere(
        (cd) => cd.id == id,
      );
    });
  }

  _openPessoaFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.68,
          child: (PessoaForm(addPessoa, pessoas)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //
          //INFO DAS LISTAS
          //

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Total: ${pessoas.length} ',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  height: 35,
                  width: 200,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        labelText: "Players",
                        hintText: "Search",
                        hintStyle: TextStyle(height: 3.2),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                    onChanged: searchPessoa,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'Selected: $qtdSelecionada',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Double Click for captain',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          //INICIO DA LISTA

          Expanded(
            child: ListView.builder(
              itemCount: (filterList ? listarOrdenado() : pessoas).length,
              itemBuilder: (_, int index) {
                Pessoa c = (filterList ? listarOrdenado() : pessoas)[index];
                return cardModel(c);
              },
            ),
          )
        ],
      ),

      // NAV BAR
      //BOTÃO RANDOM
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.shuffle),
      ),
      //BOTOES SECUNDARIOS
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
              icon: const Icon(
                Icons.person_add_alt,
                color: Colors.white,
              ),
              onPressed: () => _openPessoaFormModal(context),
            ),
            IconButton(
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  filterList = !filterList;
                  setState(() {});
                }),
          ],
        ),
      ),
    );
  }

  cardModel(Pessoa cd) {
    return InkWell(
      onDoubleTap: () {
        cd.coringa = !cd.coringa;
        setState(() {});
      },

      // SLIDE

      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: ((context) {
                _removePessoa(cd.id!);
                cd.selecionado ? qtdSelecionada-- : null;
              }),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          color: cd.coringa
              ? const Color.fromARGB(255, 255, 0, 179)
              : Colors.white,
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 20,
                        child: FittedBox(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            cd.nome.toString(),
                            style: TextStyle(
                                color:
                                    cd.coringa ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      // RATING BAR

                      RatingBar.builder(
                        initialRating: cd.nivel!,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                        itemSize: 24.5,
                        glowColor: Colors.amber,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          cd.nivel = rating;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //VERIFICA SER SORTEADO

            trailing: InkWell(
              onTap: () {
                cd.selecionado = !cd.selecionado;
                cd.selecionado ? qtdSelecionada++ : qtdSelecionada--;
                setState(() {});
              },
              child: Builder(builder: (context) {
                if (cd.selecionado) {
                  return Icon(
                    Icons.check_circle,
                    color: cd.coringa ? Colors.white : Colors.black,
                  );
                } else {
                  return Icon(
                    Icons.check_circle_outlined,
                    color: cd.coringa ? Colors.white : Colors.black,
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }

  //ORDENA QUEM TA MARCADO PARA CIMA
  List<Pessoa> listarOrdenado() {
    pessoas
        .sort((a, b) => a.selecionado ? 0 : 1.compareTo(b.selecionado ? 0 : 1));
    return pessoas;
  }

  void searchPessoa(String query) {
    final suggestions = pessoa.where((pessoas) {
      final pessoasNome = pessoas.nome!.toLowerCase();
      final input = query.toLowerCase();
      return pessoasNome.contains(input);
    }).toList();
    setState(() {
      pessoas = suggestions;
    });
  }
}
