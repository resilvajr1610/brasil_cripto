import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cores.dart';
import '../models/imagens.dart';
import '../viewmodels/favoritos_viewmodel.dart';
import '../viewmodels/moeda_viewmodel.dart';
import 'detalhes_page.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    final moedaVm = context.watch<MoedaViewModel>();

    if (moedaVm.carregando) {
      return Scaffold(
        appBar: AppBar(title: Text('CriptoTracker')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final moedas = moedaVm.moedasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Pesquisar Criptomoedas",
              style: TextStyle(color: Cores.amarelo,)
            ),
            Spacer(),
            Container(
                width: largura*0.15,
                child: Image.asset(Imagens.logo)
            ),
          ],
        ),
        backgroundColor: Cores.azul,
      ),
      body: Container(
        color: Cores.azul,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 10),
              color: Cores.azul,
              child: Row(
                children: [
                  Container(
                    width: largura*0.65,
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      onChanged: context.read<MoedaViewModel>().filtrar,
                      style: TextStyle(color: Cores.amarelo),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Buscar por nome ou símbolo",
                        hintStyle: TextStyle(color: Colors.white,fontSize: 15),
                        prefixIcon: Icon(Icons.search,color: Cores.amarelo,),
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () => moedaVm.alternarFavoritos(),
                    icon: Icon(moedaVm.mostrarFavoritos ? Icons.star : Icons.star_border, color: Cores.amarelo),
                    label: Text(
                      moedaVm.mostrarFavoritos ? 'Favoritos' : 'Todos',
                      style: TextStyle(color: Cores.amarelo, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:ListView.separated(
              itemCount: moedas.length,
              separatorBuilder: (context,index){
                return Divider(color: Colors.grey[400],height: 2,thickness: 2,);
              },
              itemBuilder: (context, index) {
                final moeda = moedas[index];

                return Container(
                  color: Colors.grey[300],
                  child: ListTile(
                    title: Text(moeda.name,style: TextStyle(color: Cores.azul),),
                    subtitle: Text(moeda.symbol.toUpperCase(),style: TextStyle(color: Cores.azulClaro),),
                    trailing: IconButton(
                      icon: Icon(moedaVm.mostrarFavoritos ?Icons.star:Icons.star_border,color: Cores.azul,),
                      onPressed: (){
                        context.read<FavoritosViewModel>().toggleFavorito(moeda.id);
                        moedaVm.alternarFavoritos();
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhesPage(moeda: moeda),
                        ),
                      );
                    },
                  ),
                );
              },
              )
            )
          ],
        ),
      ),
    );
  }
}
