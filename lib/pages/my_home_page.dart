import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/widget/car_info_widget.dart';
import 'package:furious_app/widget/line_chart_widget.dart';

class MyHomePage extends StatelessWidget {
  final List<Compteur> compteurList;
  final List<Entretien> entList;

  final HashMap<String, Color> colorMap;
  final Map<String, dynamic> vehiculeMap;

  const MyHomePage(
      this.vehiculeMap,
      this.entList,
      this.compteurList,
      this.colorMap,
      // this.connection,
      {Key? key})
      : super(key: key);

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
            vehiculeMap,
            entList,
            compteurList,
            colorMap,
          ),
          LineChartWidget(colorMap, compteurList),
        ],
      ),
    );
  }
}
