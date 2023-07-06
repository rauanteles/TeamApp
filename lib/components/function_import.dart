import 'package:flutter/material.dart';

openImportModal(context) {
  TextEditingController controller = TextEditingController();
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 1.8,
        widthFactor: 1,
        child: Card(
          child: TextField(
            controller: controller,
          ),
        ),
      );
    },
  );
}

importarLista(texto, context) {
  final split = texto.split(' / ');
  final Map<int, String> values = {
    for (int i = 0; i < split.length; i++) i: split[i]
  };
  print(values);
  final value1 = values[0];
  final value2 = values[1];
  final value3 = values[2];

  print(value1); // grubs
  print(value2); //  sheep
  print(value3); // null

  return openImportModal(context);
}
