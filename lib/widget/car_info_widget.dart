import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/widget/box_info_widget.dart';

class CarInfo extends StatelessWidget {
  final List<Compteur> compteurList;
  final List<Entretien> entList; // gardé si tu l’utilises ailleurs
  final Map<String, dynamic> vehiculeMap;

  const CarInfo(
      this.vehiculeMap,
      this.entList,
      this.compteurList, {
        super.key,
      });

  int get maxKilometrage {
    if (compteurList.isEmpty) return 0;
    int max = 0;
    for (final c in compteurList) {
      if (c.kilometrage > max) max = c.kilometrage;
    }
    return max;
  }

  String get consoMoyenneStr {
    if (compteurList.isEmpty) return '0.00';
    double sum = 0;
    for (final c in compteurList) {
      sum += c.moyConsommation;
    }
    final moy = sum / compteurList.length;
    return moy.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: cs.onSurface,
    );

    final titre = (vehiculeMap['title'] ?? 'Ma voiture').toString();
    final immat = (vehiculeMap['immatriculation'] ?? 'Inconnue').toString();
    final carburant = (vehiculeMap['carburant'] ?? 'Inconnue').toString();
    // La clé d’origine est "cylindrer" dans ton modèle — on la conserve
    final cylindrer = (vehiculeMap['cylindrer'] ?? 'Inconnue').toString();
    final dateMC = (vehiculeMap['dateMiseEnCirculation'] ?? 'Inconnue').toString();

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          // En-tête
          Card(
            color: cs.surface,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(titre, style: titleStyle),
            ),
          ),
          const SizedBox(height: 10),

          // Ligne 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BoxInfoWidget(
                icon: Icons.directions_car,
                title: 'Immatriculation',
                value: immat,
              ),
              const SizedBox(width: 10),
              BoxInfoWidget(
                icon: Icons.local_gas_station,
                title: 'Carburant',
                value: carburant,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Ligne 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BoxInfoWidget(
                icon: Icons.speed,
                title: 'Cylindrer', // conserve l’intitulé d’origine
                value: cylindrer,
              ),
              const SizedBox(width: 10),
              BoxInfoWidget(
                icon: Icons.shopping_cart,
                title: 'Date de mise en circulation',
                value: dateMC,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Ligne 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BoxInfoWidget(
                icon: Icons.text_snippet,
                title: 'Kilométrage',
                value: '$maxKilometrage Km',
              ),
              const SizedBox(width: 10),
              BoxInfoWidget(
                icon: Icons.bar_chart_sharp,
                title: 'Consommation moyenne',
                value: '$consoMoyenneStr L/100Km',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
