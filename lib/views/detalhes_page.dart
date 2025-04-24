import 'dart:async';
import 'package:translator/translator.dart';
import 'package:brasil_cripto/models/cores.dart';
import 'package:brasil_cripto/models/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/moeda.dart';
import '../models/preco_historico.dart';
import '../services/api_service.dart';
import '../widgets/grafico.dart';

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
        traduzirDescricao();
    }).onError((erro, e){
      print('erro = = = = ${erro.toString()}');
      carregando = false;
      setState(() {});
    });
  }

  Future<void> traduzirDescricao() async {
    final translator = GoogleTranslator();
    final traducao = await translator.translate(crypto!.description, to: 'pt');
    setState(() {
      crypto!.description = traducao.text;
      carregando = false;
      setState(() {});
    });
  }

  carregarPrecos(){
    historico = ApiService.buscarDadosGrafico(widget.moeda.id);
    print(historico);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Cores.amarelo),
        backgroundColor: Cores.azul,
        title: Row(
          children: [
            Container(
                child: Text(
                  '${widget.moeda.name} (${widget.moeda.symbol.toUpperCase()})',
                    style: TextStyle(color: Cores.amarelo),
                ),
                width: MediaQuery.of(context).size.width*0.6,
            ),
            Spacer(),
            crypto==null || crypto!.logo==''?Container():CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(crypto!.logo,),
              backgroundColor: Colors.white,
            )
          ],
        ),
      ),
      body: carregando
          ? Center(child: CircularProgressIndicator(color: Cores.azul,))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Preço Atual:',
              style: TextStyle(fontWeight: FontWeight.bold,color: Cores.azul),
            ),
            Text(crypto==null?'R\$ 0,00':'R\$ ${NumberFormat('#,##0.00', 'pt_BR').format(crypto!.price)}',style: TextStyle(color: Cores.azulClaro),),
            SizedBox(height: 16),
            Text(
              'Variação 24h:',
              style: TextStyle(fontWeight: FontWeight.bold,color: Cores.azul),
            ),
            Text(crypto==null?'0 %':'${crypto!.changePercent24h.toStringAsFixed(2).replaceAll('.', ',')}%',style: TextStyle(color: Cores.azulClaro),),
            SizedBox(height: 16),
            Text(
              'Volume:',
              style: TextStyle(fontWeight: FontWeight.bold,color: Cores.azul),
            ),
            Text(crypto==null?'0':'${NumberFormat('00,000').format(crypto!.volume.toInt()).replaceAll(',', '.')}',style: TextStyle(color: Cores.azulClaro),),
            SizedBox(height: 16),
            Text(
              'Descrição:',
              style: TextStyle(fontWeight: FontWeight.bold,color: Cores.azul),
            ),
            SizedBox(height: 8),
            Text(crypto==null?'':'${crypto!.description}',
              textAlign: TextAlign.justify,
              style: TextStyle(color: Cores.azulClaro,),
            ),
            SizedBox(height: 15),
            FutureBuilder<List<PrecoHistorico>>(
              future: historico,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Falha ao carregar os dados'));
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
