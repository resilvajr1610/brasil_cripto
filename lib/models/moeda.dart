class Moeda {
  final String id;
  final String name;
  final String symbol;

  Moeda({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory Moeda.fromJson(Map<String, dynamic> json) {
    return Moeda(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }
}
