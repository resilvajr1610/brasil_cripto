class PrecoHistorico {
  final DateTime hora;
  final double preco;

  PrecoHistorico({required this.hora, required this.preco});

  factory PrecoHistorico.fromList(List<dynamic> json) {
    final hora = DateTime.fromMillisecondsSinceEpoch(json[0]);
    return PrecoHistorico(
      hora: hora,
      preco: (json[1] as num).toDouble(),
    );
  }
}
