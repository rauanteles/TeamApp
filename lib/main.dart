import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groupapp/components/pessoa_form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'models/pessoa.dart';

main() => runApp(const GroupApp());

class GroupApp extends StatelessWidget {
  const GroupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pessoas = [];
  _addPessoa(String nome, double nivel) {
    final newPessoa = Pessoa(
      id: Random().nextDouble().toString(),
      nome: nome,
      nivel: nivel,
      coringa: false,
      serSorteada: false,
    );

    setState(() {
      _pessoas.add(newPessoa);
    });
  }

  _removePessoa(String id) {
    setState(() {
      _pessoas.removeWhere(
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
          child: (PessoaForm(_addPessoa)),
        );
      },
    );
  }

  bool checkedJoker = false;
  bool serSorteado = false;
  int qntSelecionada = 0;
  late String swipeDirection;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Team Generator')),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
            child: Card(
              color: Color.fromARGB(255, 18, 1, 65),
              elevation: 10,
              child: Text(
                'Número de Jogadores',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${_pessoas.length} ',
                ),
                Text(
                  'Selecionados: $qntSelecionada',
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 35,
            width: double.infinity,
            child: Card(
              color: Colors.purple,
              elevation: 5,
              child: Center(
                child: Text(
                  'Lista de Jogadores',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Double Click for captain',
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pessoas.length,
              itemBuilder: (_, int index) {
                Pessoa c = _pessoas[index];
                return cardModel(c);
              },
            ),
          )
        ],
      ),
      //
      //
      //
      // NAVEGATION BAR
      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.shuffle),
      ),
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
                  Icons.menu,
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
                  Icons.favorite_outline,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }

//
//
//
// FUNÇÃO INTERAÇÃO DA LISTA
//
  cardModel(Pessoa cd) {
    return InkWell(
      onDoubleTap: () {
        cd.coringa = !cd.coringa;
        setState(() {});
      },
      //
      //
      //
      // SLIDE
      //

      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          // dismissible: DismissiblePane(
          //   onDismissed: () => _removePessoa(cd.id!),
          // ),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: ((context) {
                _removePessoa(cd.id!);
                qntSelecionada--;
              }),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),

        child: Container(
          color: cd.coringa ? Color.fromARGB(255, 255, 0, 179) : Colors.white,
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
                      //
                      //
                      // RATING BAR
                      //
                      //
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
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                cd.serSorteada = !cd.serSorteada;
                cd.serSorteada ? qntSelecionada++ : qntSelecionada--;
                setState(() {});
              },
              child: Builder(builder: (context) {
                if (cd.serSorteada) {
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
}
