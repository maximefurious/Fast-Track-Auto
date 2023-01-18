import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/widget/car_info_widget.dart';
import 'package:furious_app/widget/line_chart_widget.dart';

class MyHomePage extends StatelessWidget {
  final int isDark;
  final String vehiculeTitle;
  final String vehiculeImmatriculation;
  final String vehiculeDateConstructeur;
  final String vehiculeDateMiseEnCirculation;
  final String vehiculeCarburant;
  final List<Compteur> compteurList;
  final List<Entretien> entList;

  MyHomePage(
    this.vehiculeTitle,
    this.vehiculeImmatriculation,
    this.vehiculeDateConstructeur,
    this.vehiculeDateMiseEnCirculation,
    this.vehiculeCarburant,
    this.entList,
    this.compteurList,
    this.isDark,
  );

  // TODO : Faire un bloque de rappel des entretiens réguliers
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Material(
              elevation: 20,
              child: Image.asset(
                'assets/images/images.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          CarInfo(
            vehiculeTitle,
            vehiculeImmatriculation,
            vehiculeDateConstructeur,
            vehiculeDateMiseEnCirculation,
            vehiculeCarburant,
            entList,
            compteurList,
            isDark,
          ),
          LineChartWidget(isDark),
        ],
      ),
    );
  }
}
