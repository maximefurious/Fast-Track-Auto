import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';

class CarInfo extends StatelessWidget {
  final String vehiculeTitle;
  final String vehiculeImmatriculation;
  final String vehiculeDateConstructeur;
  final String vehiculeDateMiseEnCirculation;
  final String vehiculeCarburant;
  final List<Compteur> compteurList;
  final List<Entretien> entList;

  CarInfo(
    this.vehiculeTitle,
    this.vehiculeImmatriculation,
    this.vehiculeDateConstructeur,
    this.vehiculeDateMiseEnCirculation,
    this.vehiculeCarburant,
    this.entList,
    this.compteurList,
  );

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
    return moyenne;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: Text(
                  vehiculeTitle,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        color: Colors.grey,
                      ),
                      Text(vehiculeImmatriculation),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_gas_station,
                        color: Colors.grey,
                      ),
                      Text(
                        vehiculeCarburant,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.construction,
                        color: Colors.grey,
                      ),
                      Text(vehiculeDateConstructeur),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.grey,
                      ),
                      Text(
                        vehiculeDateMiseEnCirculation,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.text_snippet,
                        color: Colors.grey,
                      ),
                      Text(maxKilometrage.toString() + " Km"),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children:  [
                      const Icon(
                        Icons.bar_chart_sharp,
                        color: Colors.grey,
                      ),
                      Text(consoMoyenne.toString() + " L/100Km"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
