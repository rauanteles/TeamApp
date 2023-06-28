import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PessoaForm extends StatefulWidget {
  final void Function(String, double) onSubmit;

  PessoaForm(this.onSubmit, {super.key});

  @override
  State<PessoaForm> createState() => _PessoaFormState();
}

class _PessoaFormState extends State<PessoaForm> {
  var nomeController = TextEditingController();
  var nivelStar = 0.5;

  _submitForm() {
    final nome = nomeController.text;
    final nivel = nivelStar;
    if (nome.isEmpty || nivel <= 0) {
      return;
    }

    widget.onSubmit(nome, nivel);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              autofocus: true,
            ),
            const SizedBox(
              height: 25,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1),
              itemSize: 60,
              glowColor: Colors.amber,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                nivelStar = rating;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _submitForm();
                nomeController.text = '';
              },
              child: const Text(
                'Salvar',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
