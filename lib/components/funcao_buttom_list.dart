import 'package:flutter/material.dart';

import '../models/pessoa.dart';

class FuncaoButtomList extends StatefulWidget {
  final void Function(bool, int) onSubmit;
  final List<Pessoa> list;

  const FuncaoButtomList(this.onSubmit, this.list, {super.key});

  @override
  State<FuncaoButtomList> createState() => _FuncaoButtomListState();
}

class _FuncaoButtomListState extends State<FuncaoButtomList> {
  int contador = 0;
  bool selecionado = true;

  submitSelect(int opcao) {
    switch (opcao) {
      case 1:
        selecionado = true;
        contador = widget.list.length;

        break;
      case 2:
        selecionado = false;
        contador = 0;

        break;
      case 3:
        for (Pessoa element in widget.list) {
          element.selecionado = !element.selecionado;
          selecionado = element.selecionado;
        }
        break;
      case 4:
        // for (Pessoa element in widget.list) {
        //   setState(() {});
        // }

        break;
      default:
    }
    widget.onSubmit(selecionado, contador);
  }

  @override
  Widget build(BuildContext context) {
    return (Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    submitSelect(1);
                  },
                  child: const SizedBox(
                    width: 110,
                    child: Text('Marcar todos'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    submitSelect(2);
                  },
                  child: const SizedBox(
                    width: 110,
                    child: Text('Desmarcar todos'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    submitSelect(3);
                  },
                  child: const SizedBox(
                    width: 110,
                    child: Text('Inverter seleção'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    submitSelect(4);
                  },
                  child: const SizedBox(
                    width: 110,
                    child: Text('Excluir selecionados'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
