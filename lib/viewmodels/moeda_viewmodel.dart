import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../services/api_service.dart';

class MoedaViewModel extends ChangeNotifier {
  List<Moeda> todas = [];
  List<Moeda> filtradas = [];
  bool carregando = false;

  Future<void> carregarMoedas() async {
    carregando = true;
    notifyListeners();

    todas = await ApiService.buscarMoedas();
    filtradas = List.from(todas);

    carregando = false;
    notifyListeners();
  }

  void filtrar(String query) {
    if (query.isEmpty) {
      filtradas = List.from(todas);
    } else {
      final q = query.toLowerCase();
      filtradas = todas.where((moeda) {
        return moeda.name.toLowerCase().contains(q) ||
            moeda.symbol.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }
}
