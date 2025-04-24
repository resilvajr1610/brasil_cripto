import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/preco_historico.dart';

Widget buildGrafico(List<PrecoHistorico> dados) {

  double minY = dados.map((e) => e.preco).reduce((a, b) => a < b ? a : b);
  double maxY = dados.map((e) => e.preco).reduce((a, b) => a > b ? a : b);

  return LineChart(
    LineChartData(
      minY: minY * 0.997,
      maxY: maxY * 1.003,
      lineBarsData: [
        LineChartBarData(
          spots: dados.map((p) => FlSpot(
            p.hora.millisecondsSinceEpoch.toDouble(), // aqui!
            p.preco,
          )).toList(),
          isCurved: true,
          color: Colors.deepPurple,
          barWidth: 2,
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 60,
            getTitlesWidget: (value, meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: true),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot)=> Colors.grey,
          tooltipRoundedRadius: 8,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final timestamp = spot.x.toInt();
              final valor = spot.y;
              final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
              final dataFormatada = "${date.day.toString().padLeft(2, '0')}/"
                  "${date.month.toString().padLeft(2, '0')} "
                  "${date.hour.toString().padLeft(2, '0')}:"
                  "${date.minute.toString().padLeft(2, '0')}";

              return LineTooltipItem(
                '$dataFormatada\nR\$ ${valor.toStringAsFixed(2)}',
                TextStyle(
                  color: Colors.black, // texto bem visível
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
    ),
  );
}
