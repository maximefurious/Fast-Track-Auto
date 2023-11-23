import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/widget/box_info_widget.dart';

class CarInfo extends StatelessWidget {
  final List<Compteur> compteurList;
  final List<Entretien> entList;

  final HashMap<String, Color> colorMap;
  final Map<String, dynamic> vehiculeMap;

  const CarInfo(
      this.vehiculeMap, this.entList, this.compteurList, this.colorMap,
      {Key? key})
      : super(key: key);

  int get maxKilometrage {
    int max = 0;
    for (var i = 0; i < compteurList.length; i++) {
      if (compteurList[i].kilometrage > max) {
        max = compteurList[i].kilometrage;
      }
    }

    return max;
  }

  double get consoMoyenne {
    double moyenne = 0;
    if (compteurList.isNotEmpty) {
      for (var i = 0; i < compteurList.length; i++) {
        moyenne += compteurList[i].moyConsommation;
      }
      moyenne = moyenne / (compteurList.length);
    }
    String moy = moyenne.toStringAsExponential(2);
    moyenne = double.parse(moy);
    return moyenne;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: colorMap['cardColor'],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                vehiculeMap['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BoxInfoWidget(
                icon: Icons.directions_car,
                title: 'Immatriculation',
                value: vehiculeMap['immatriculation']!,
              ),
              const SizedBox(
                width: 10,
              ),
              BoxInfoWidget(
                icon: Icons.local_gas_station,
                title: 'Carburant',
                value: vehiculeMap['carburant']!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BoxInfoWidget(
                icon: Icons.speed,
                title: 'Cylindrer',
                value: vehiculeMap['cylindrer']!,
              ),
              const SizedBox(
                width: 10,
              ),
              BoxInfoWidget(
                icon: Icons.shopping_cart,
                title: 'Date de mise en circulation',
                value: vehiculeMap['dateMiseEnCirculation']!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BoxInfoWidget(
                icon: Icons.text_snippet,
                title: 'Kilometrage',
                value: "$maxKilometrage Km",
              ),
              const SizedBox(
                width: 10,
              ),
              BoxInfoWidget(
                icon: Icons.bar_chart_sharp,
                title: 'Consommation moyenne',
                value: "$consoMoyenne L/100Km",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
