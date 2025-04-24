import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/moeda.dart';
import '../models/preco_historico.dart';

class ApiService {
  static const baseUrl = 'https://api.coingecko.com/api/v3';

  static Future<List<Moeda>> buscarMoedas() async {
    final url = Uri.parse('$baseUrl/coins/list');
    final resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      final List<dynamic> lista = json.decode(resposta.body);
      return lista.map((e) => Moeda.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar moedas");
    }
  }

  static Future<Map<String, dynamic>> buscarDetalhes(String id) async {
    final url = Uri.parse('$baseUrl/coins/$id');
    final resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      throw Exception("Erro ao buscar detalhes da moeda");
    }
  }

  static Future<List<PrecoHistorico>> buscarDadosGrafico(String id) async {
    final url = Uri.parse('$baseUrl/coins/$id/market_chart?vs_currency=brl&days=1');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final json = jsonDecode(resposta.body);
      final List<dynamic> prices = json['prices'];
      return prices.map((p) => PrecoHistorico.fromList(p)).toList();
    } else {
      throw Exception('Erro ao buscar histórico de preços');
    }
  }
}
