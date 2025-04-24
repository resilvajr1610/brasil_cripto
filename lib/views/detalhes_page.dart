import 'dart:async';

import 'package:brasil_cripto/models/crypto.dart';
import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../models/preco_historico.dart';
import '../services/api_service.dart';
import 'grafico.dart';

class DetalhesPage extends StatefulWidget {
  final Moeda moeda;

  const DetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  Crypto? crypto;
  bool carregando = true;
  late Future<List<PrecoHistorico>> historico;

  @override
  void initState() {
    super.initState();
    carregarDetalhes();
    carregarPrecos();
  }

  Future<void> carregarDetalhes() async {
    await ApiService.buscarDetalhes(widget.moeda.id).then((detalhes){
        crypto = Crypto.fromJson(detalhes);
        carregando = false;
        setState(() {});
    }).onError((erro, e){
      print('erro = = = = ${erro.toString()}');
      carregando = false;
      setState(() {});
    });
  }

  carregarPrecos(){
    historico = ApiService.buscarDadosGrafico(widget.moeda.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
                child: Text('${widget.moeda.name} (${widget.moeda.symbol.toUpperCase()})'),
                width: MediaQuery.of(context).size.width*0.6,
            ),
            Spacer(),
            crypto==null || crypto!.logo==''?Container():Image.network(
              crypto!.logo,
              width: 50,
              height: 50,
            )
          ],
        ),
      ),
      body: carregando || crypto==null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Preço Atual: R\$ ${crypto!.price.toString().replaceAll('.', ',')}'),
            SizedBox(height: 16),
            Text('Variação 24h: ${crypto!.changePercent24h.toStringAsFixed(2).replaceAll('.', ',')}%'),
            SizedBox(height: 16),
            Text('Volume : ${crypto!.volume}'),
            SizedBox(height: 16),
            Text(
              'Descrição:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('${crypto!.description}'),
            SizedBox(height: 15),
            FutureBuilder<List<PrecoHistorico>>(
              future: historico,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar gráfico'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Sem dados de gráfico'));
                }

                return SizedBox(
                  height: 200,
                  child: buildGrafico(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
