import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:furious_app/composant/Compteur.dart';

class LineChartWidget extends StatefulWidget {
  final List<Compteur> compteurList;
  final HashMap<String, Color> colorMap;

  const LineChartWidget(this.colorMap, this.compteurList,  {Key? key}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> _getSpots() {
    widget.compteurList.sort((a, b) => a.kilometrage.compareTo(b.kilometrage));
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.compteurList.length; i++) {
      Compteur compteur = widget.compteurList[i];
      spots.add(FlSpot(compteur.kilometrage.toDouble(), compteur.moyConsommation));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.colorMap['cardColor'],
        ),
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: true,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: Text(
                  'Kilométrage',
                  style: TextStyle(
                    color: widget.colorMap['text'],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: widget.colorMap['text'],
                      fontSize: 10,
                    ),
                  )
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: Text(
                  'Consommation',
                  style: TextStyle(
                    color: widget.colorMap['text'],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                    '${double.parse(value.toStringAsFixed(2))}',
                    style: TextStyle(
                      color: widget.colorMap['text'],
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  )
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(),
                isCurved: true,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff27b6fc),
                    Color(0xff2d98da),
                    Color(0xff2d98da),
                  ],
                ),
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 4,
                    strokeColor: [
                      const Color(0xff27b6fc),
                      const Color(0xff2d98da),
                      const Color(0xff2d98da)
                    ][index],
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xff00f6fe).withOpacity(0.1),
                      const Color(0xff00f6fe).withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
