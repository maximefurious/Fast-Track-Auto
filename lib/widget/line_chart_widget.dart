import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatefulWidget {
  final int isDark;

  LineChartWidget(this.isDark);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
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
          color: widget.isDark == 1 ? Colors.grey[900] : Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (context, value) => TextStyle(
                  color: widget.isDark == 1 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                // Permet de customiser les titres sur les cotés pour évité le surplu d'information
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 2:
                      return '20000';
                    case 5:
                      return '50000';
                    case 8:
                      return '80000';
                  }
                  return '';
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (context, value) => TextStyle(
                  color: widget.isDark == 1 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                // Permet de customiser les titres sur les cotés pour évité le surplu d'information
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 1:
                      return '1';
                    case 3:
                      return '3';
                    case 5:
                      return '5';
                  }
                  return '';
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 3),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3),
                  FlSpot(11, 4),
                ],
                isCurved: true,
                colors: const [
                  Color(0xff27b6fc),
                  Color(0xff2d98da),
                  Color(0xff2d98da),
                ],
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  colors: [
                    const Color(0xff00f6fe).withOpacity(0.1),
                    const Color(0xff00f6fe).withOpacity(0.1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
