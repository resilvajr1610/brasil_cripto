import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favoritos_viewmodel.dart';
import '../viewmodels/moeda_viewmodel.dart';
import 'detalhes_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pesquisar Criptomoedas")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: context.read<MoedaViewModel>().filtrar,
              decoration: InputDecoration(
                hintText: "Buscar por nome ou símbolo",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<MoedaViewModel>(
              builder: (context, vm, _) {
                if (vm.carregando) return Center(child: CircularProgressIndicator());
                if (vm.filtradas.isEmpty) return Center(child: Text("Nenhuma criptomoeda encontrada"));

                return ListView.builder(
                  itemCount: vm.filtradas.length,
                  itemBuilder: (context, index) {
                    final moeda = vm.filtradas[index];
                    final favVm = context.read<FavoritosViewModel>();
                    final isFav = favVm.isFavorito(moeda.id);

                    return ListTile(
                      title: Text(moeda.name),
                      subtitle: Text(moeda.symbol.toUpperCase()),
                      trailing: IconButton(
                        icon: Icon(isFav ? Icons.star : Icons.star_border),
                        onPressed: () => favVm.toggleFavorito(moeda.id),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalhesPage(moeda: moeda),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
