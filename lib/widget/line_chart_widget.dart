import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:furious_app/models/compteur.dart';

class LineChartWidget extends StatelessWidget {
  final List<Compteur> compteurList;

  const LineChartWidget(
      this.compteurList, {
        super.key,
      });

  List<FlSpot> _getSpots() {
    final sorted = List<Compteur>.of(compteurList)
      ..sort((a, b) => a.kilometrage.compareTo(b.kilometrage));
    return [
      for (final c in sorted)
        FlSpot(c.kilometrage.toDouble(), c.moyConsommation),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    final axisTextStyle =
    theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant);
    final axisTitleStyle =
    theme.textTheme.labelLarge?.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold);

    final primary = cs.primary;
    final secondary = cs.secondary;

    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardColor, // ou cs.surface
        ),
        padding: const EdgeInsets.all(10),
        height: size.height * 0.3,
        width: size.width,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1000,
              getDrawingHorizontalLine: (value) => FlLine(
                color: cs.outlineVariant,
                strokeWidth: 0.5,
              ),
              getDrawingVerticalLine: (value) => FlLine(
                color: cs.outlineVariant,
                strokeWidth: 0.5,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: Text('Kilométrage', style: axisTitleStyle),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${value.toInt()}',
                      style: axisTextStyle,
                    ),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: Text('Consommation', style: axisTitleStyle),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      value.toStringAsFixed(2),
                      style: axisTextStyle?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: cs.outlineVariant, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(),
                isCurved: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primary,
                    primary.withOpacity(0.85),
                    secondary.withOpacity(0.85),
                  ],
                ),
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primary.withOpacity(0.12),
                      primary.withOpacity(0.05),
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
