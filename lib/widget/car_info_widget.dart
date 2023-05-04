import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';

class CarInfo extends StatelessWidget {
  final bool isDark;
  final String vehiculeTitle;
  final String vehiculeImmatriculation;
  final String vehiculeCylinder;
  final String vehiculeDateMiseEnCirculation;
  final String vehiculeCarburant;
  final List<Compteur> compteurList;
  final List<Entretien> entList;

  const CarInfo(
      this.vehiculeTitle,
      this.vehiculeImmatriculation,
      this.vehiculeCylinder,
      this.vehiculeDateMiseEnCirculation,
      this.vehiculeCarburant,
      this.entList,
      this.compteurList,
      this.isDark,
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark ? Colors.grey[900] : Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: Text(
                  vehiculeTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
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
                      Text(
                        vehiculeImmatriculation,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
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
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black,
                        ),
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
                        Icons.speed,
                        color: Colors.grey,
                      ),
                      Text(
                        vehiculeCylinder,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
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
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black,
                        ),
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
                      Text(
                        "$maxKilometrage Km",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bar_chart_sharp,
                        color: Colors.grey,
                      ),
                      Text(
                        "$consoMoyenne L/100Km",
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
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
