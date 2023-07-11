class Pessoa {
  final String? id;
  String? nome;
  double? nivel;
  bool coringa;
  bool selecionado;

  Pessoa({
    required this.id,
    required this.nome,
    required this.nivel,
    required this.coringa,
    required this.selecionado,
  });

  @override
  String toString() {
    return '$nome';
  }
}
