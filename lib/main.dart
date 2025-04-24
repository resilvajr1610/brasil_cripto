import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/home_page.dart';
import 'viewmodels/moeda_viewmodel.dart';
import 'viewmodels/favoritos_viewmodel.dart';

void main() {
  runApp(CryptoApp());
}

class CryptoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoedaViewModel()..carregarMoedas()),
        ChangeNotifierProvider(create: (_) => FavoritosViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CriptoTracker',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}
