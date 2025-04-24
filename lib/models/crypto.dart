class Crypto {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double changePercent24h;
  final String logo;
  final String description;
  final double volume;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercent24h,
    required this.logo,
    required this.description,
    required this.volume,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      price: (json['market_data']['current_price']['brl'] ?? 0).toDouble(),
      changePercent24h: (json['market_data']['price_change_percentage_24h'] ?? 0).toDouble(),
      logo: json['image']['small'],
      description: json['description']['en'],
      volume: json['market_data']['total_volume']['brl'].toDouble(),
    );
  }
}
