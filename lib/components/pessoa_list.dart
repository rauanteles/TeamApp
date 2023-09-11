import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:groupapp/components/funcao_buttom_list.dart';
import 'package:groupapp/components/pessoa_form.dart';

import '../models/pessoa.dart';
import '../sorteio/sorteio_page.dart';

class PessoaList extends StatefulWidget {
  const PessoaList({super.key});

  @override
  State<PessoaList> createState() => _PessoaListState();
}

class _PessoaListState extends State<PessoaList> {
  //DECLARAÇÃO DE VARIAVEIS

  bool checkedJoker = false;
  bool selecionado = false;
  bool filterList = false;
  bool colorFilter = false;
  int qtdSelecionada = 0;
  int qtdCoringas = 0;
  late String swipeDirection;
  TextEditingController controller = TextEditingController();
  TextEditingController controllerEditName = TextEditingController();

  //LISTAS

  static List<Pessoa> pessoas = [];
  static List<Pessoa> pessoasFiltrado = [];
  // ---------------------------------------------------------------------------
  // --------------------------INICIO BUILDER-----------------------------------
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // -------------------------------------------------------------------
          //-----------------------INFO DAS LISTAS------------------------------
          // -------------------------------------------------------------------

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
                  width: 170,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        hintText: "Pesquisar",
                        hintStyle: TextStyle(height: 3.2),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                    onChanged: (value) {
                      pesquisaPessoa(value);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'Selecionados: $qtdSelecionada',
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
                  'Duplo click para selecionar o capitão',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          // -------------------------------------------------------------------
          //------------------------VIEW DA LISTA-------------------------------
          // -------------------------------------------------------------------
          Expanded(
            child: ListView.builder(
              itemCount:
                  (filterList ? listarOrdenado() : pessoasFiltrado).length,
              itemBuilder: (_, int index) {
                Pessoa c =
                    (filterList ? listarOrdenado() : pessoasFiltrado)[index];
                return cardModel(c);
              },
            ),
          ),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
      // ---------------------------------------------------------------------
      // -------------------------NAV BAR-------------------------------------
      // ---------------------------------------------------------------------
      //BOTÃO RANDOM
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pageSorteio(pessoas);
        },
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
                  Icons.import_export,
                  color: Colors.white,
                ),
                onPressed: () {
                  openImportModal(context);
                }),
            IconButton(
              icon: const Icon(
                Icons.person_add_alt,
                color: Colors.white,
              ),
              onPressed: () {
                controller.text = '';
                openPessoaFormModal(context);
              },
            ),
            IconButton(
                icon: const Icon(
                  Icons.arrow_drop_up,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  _openFuncoesBottonModal(context);
                }),
            IconButton(
                icon: Icon(
                  colorFilter
                      ? Icons.filter_list_rounded
                      : Icons.filter_list_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  filterList = !filterList;
                  colorFilter = !colorFilter;

                  setState(() {});
                }),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ---------------------CARD DE PESSOAS---------------------------------------
  // ---------------------------------------------------------------------------

  cardModel(Pessoa cd) {
    return InkWell(
      onTap: () {
        _openPessoaEditModal(context, cd);
      },
      onDoubleTap: () {
        cd.coringa = !cd.coringa;
        cd.coringa ? qtdCoringas++ : qtdCoringas--;
        setState(() {});
      },
      // -----------------------------------------------------------------------
      // ------------------------------SLIDE------------------------------------
      // -----------------------------------------------------------------------
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: ((context) {
                removePessoa(cd.id!);
                cd.selecionado ? qtdSelecionada-- : null;
                cd.coringa ? qtdCoringas-- : null;
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
                      // ------------------------------------------------------
                      // -------------------RATING BAR-------------------------
                      // ------------------------------------------------------
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
            // -----------------------------------------------------------------
            //--------------------VERIFICA SER SORTEADO-------------------------
            // -----------------------------------------------------------------
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

  //----------------------------------------------------------------------------
  //----------------------------FUNÇÕES-----------------------------------------
  //----------------------------------------------------------------------------
  //ABRIR PAGINA DE SORTEIO
  pageSorteio(pessoas) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SorteioPage(pessoas, qtdSelecionada, qtdCoringas),
        ));
  }

  // ADICIONAR PESSOA
  addPessoa(String nome, double nivel) {
    final newPessoa = Pessoa(
      id: Random().nextInt(100).toString(),
      nome: nome,
      nivel: nivel,
      coringa: false,
      selecionado: true,
    );

    setState(() {
      pessoas.add(newPessoa);
      pessoasFiltrado = pessoas;
    });

    int x = 0;
    for (Pessoa p in pessoas) {
      if (p.selecionado) {
        x++;
      }
    }
    qtdSelecionada = x;
  }

  // REMOVER PESSOA
  removePessoa(String id) {
    setState(() {
      pessoas.removeWhere(
        (cd) => cd.id == id,
      );
      pessoasFiltrado = pessoas;
    });
  }

  // ABRIR MODAL DE CADASTRO
  openPessoaFormModal(BuildContext context) {
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

  // LISTAR ORDENADO QUEM TA MARCADO
  List<Pessoa> listarOrdenado() {
    pessoas
        .sort((a, b) => a.selecionado ? 0 : 1.compareTo(b.selecionado ? 0 : 1));
    return pessoas;
  }

  // FUNÇÃO PARA CRIAÇÃO DA SEGUNDA LISTA DE PESSOAS PESQUISADAS
  pesquisaPessoa(String query) {
    pessoasFiltrado = pessoas;

    pessoasFiltrado = pessoasFiltrado.where((element) {
      return element.nome!.contains(query.toUpperCase());
    }).toList();

    setState(() {});
  }

  // ABRIR MODAL PARA MEXER NA LISTA
  _openFuncoesBottonModal(BuildContext context) {
    editList(bool selecionado, int contador, caso) {
      switch (caso) {
        case 3:
          for (Pessoa e in pessoas) {
            e.selecionado = !e.selecionado;
            if (e.selecionado) {
              qtdSelecionada++;
            } else {
              qtdSelecionada--;
            }
          }
          break;
        case 4:
          for (Pessoa p in pessoas) {
            if (p.selecionado == true) {
              pessoas.removeWhere((item) => item.selecionado == true);
              qtdSelecionada = 0;
              qtdCoringas = 0;
            }
            setState(() {});
          }
          break;
        default:
          for (Pessoa e in pessoas) {
            e.selecionado = selecionado;
            qtdSelecionada = contador;
          }
      }
      setState(() {});
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
            alignment: Alignment.bottomRight,
            widthFactor: 0.4,
            heightFactor: 0.3,
            child: (FuncaoButtomList(editList, pessoas)));
      },
    );
  }

  // ABRIR MODAL PARA EDITAR PESSOA
  _openPessoaEditModal(BuildContext context, cd) {
    controllerEditName.text = cd.nome!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        submit() {
          cd.nome = controllerEditName.text;
          if (controllerEditName.text != '') {
            atualizarLista(cd);
            Navigator.pop(context);
          }
        }

        return FractionallySizedBox(
          alignment: Alignment.center,
          widthFactor: 0.75,
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 300.0),
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.white),
                              color: Colors.purple,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Edit Name",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: Card(
                          elevation: 5,
                          child: TextField(
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.done,
                            autofocus: true,
                            controller: controllerEditName,
                            onSubmitted: (value) => submit(),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          submit();
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(color: Colors.blue, fontSize: 25),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ATUALIZAR A LISTA
  atualizarLista(Pessoa pessoa) {
    for (Pessoa p in pessoas) {
      if (p.id == pessoa.id) {
        p.nome = pessoa.nome!.toUpperCase();
      }
      setState(() {});
    }
  }

  //importar lista
  openImportModal(context) {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.getData(Clipboard.kTextPlain).then((value) {
                          controller.text = controller.text + value!.text!;
                        });
                      },
                    ),
                    const Text(
                      "Importar Lista de Jogadores",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () {
                        controller.text = '';
                      },
                    ),
                  ],
                ),
                Card(
                  elevation: 5,
                  child: TextField(
                    maxLines: 10,
                    enabled: true,
                    autofocus: false,
                    controller: controller,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.import_export),
                  label: const Text("Importar"),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Esse Processo irá apagar todos os jogadores da lista atual!',
                                style: TextStyle(fontSize: 20),
                              ),
                              const Text(
                                ' ',
                                style: TextStyle(fontSize: 20),
                              ),
                              const Text(
                                'Deseja continuar?',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      String texto = controller.text;
                                      pessoas.clear();
                                      pessoasFiltrado = pessoas;
                                      final splitLine = texto.split('\n');
                                      for (int i = 0;
                                          i < splitLine.length;
                                          i++) {
                                        addPessoa(
                                            splitLine[i].toUpperCase(), 0.5);
                                      }
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Confirmar"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
