import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/widget/car_info_widget.dart';
import 'package:furious_app/widget/line_chart_widget.dart';

class MyHomePage extends StatelessWidget {
  final List<Compteur> compteurList;
  final List<Entretien> entList;
  final Map<String, dynamic> vehiculeMap;

  const MyHomePage(
      this.vehiculeMap,
      this.entList,
      this.compteurList, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Bannière avec couleurs du thème
            Center(
              child: Material(
                color: cs.surface,
                elevation: 8,
                shadowColor: Colors.black26,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/images.jpg',
                    width: size.width,
                    height: size.height * 0.30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // CarInfo doit utiliser Theme.of(context) en interne
            CarInfo(
              vehiculeMap,
              entList,
              compteurList
            ),

            const SizedBox(height: 12),
            LineChartWidget(compteurList),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
