class DetalhesMoeda {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final double marketCap;
  final String? description;

  DetalhesMoeda({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.marketCap,
    this.description,
  });

  factory DetalhesMoeda.fromJson(Map<String, dynamic> json) {
    return DetalhesMoeda(
      name: json['name'],
      symbol: json['symbol'],
      price: json['market_data']['current_price']['usd']?.toDouble() ?? 0,
      change: json['market_data']['price_change_percentage_24h']?.toDouble() ?? 0,
      marketCap: json['market_data']['market_cap']['usd']?.toDouble() ?? 0,
      description: json['description']['en'] ?? '',
    );
  }
}
