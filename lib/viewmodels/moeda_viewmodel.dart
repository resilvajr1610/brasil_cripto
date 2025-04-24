import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../services/api_service.dart';
import 'favoritos_viewmodel.dart';

class MoedaViewModel extends ChangeNotifier {
  List<Moeda> todas = [];
  List<Moeda> filtradas = [];
  bool carregando = false;

  late FavoritosViewModel _favoritosVm;

  bool _mostrarFavoritos = false;

  bool get mostrarFavoritos => _mostrarFavoritos;

  void alternarFavoritos() {
    _mostrarFavoritos = !_mostrarFavoritos;
    notifyListeners();
  }

  Future<void> carregarMoedas() async {
    carregando = true;
    notifyListeners();

    todas = await ApiService.buscarMoedas();
    filtradas = List.from(todas);

    carregando = false;
    notifyListeners();
  }

  void setFavoritosVm(FavoritosViewModel favVm) {
    _favoritosVm = favVm;
    _favoritosVm.addListener(_atualizarFavoritos);
  }
  void _atualizarFavoritos() {
    notifyListeners();
  }
  List<Moeda> get moedasFiltradas {
    if (_mostrarFavoritos) {
      return todas.where((moeda) => _favoritosVm.isFavorito(moeda.id)).toList();
    } else {
      return filtradas;
    }
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
