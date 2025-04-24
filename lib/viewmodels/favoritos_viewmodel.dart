import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosViewModel extends ChangeNotifier {
  List<String> idsFavoritos = [];

  FavoritosViewModel() {
    carregarFavoritos();
  }

  void toggleFavorito(String id) async {
    if (idsFavoritos.contains(id)) {
      idsFavoritos.remove(id);
    } else {
      idsFavoritos.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoritos', idsFavoritos);
  }

  bool isFavorito(String id) => idsFavoritos.contains(id);

  Future<void> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    idsFavoritos = prefs.getStringList('favoritos') ?? [];
    notifyListeners();
  }
}
