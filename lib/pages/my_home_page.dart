import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/widget/car_info_widget.dart';
import 'package:furious_app/widget/line_chart_widget.dart';

class MyHomePage extends StatelessWidget {
  final bool isDark;
  final String vehiculeTitle;
  final String vehiculeImmatriculation;
  final String vehiculeCylinder;
  final String vehiculeDateMiseEnCirculation;
  final String vehiculeCarburant;
  final List<Compteur> compteurList;
  final List<Entretien> entList;
  final Color backgroundColor;
  final BluetoothConnection? connection;

  const MyHomePage(
      this.vehiculeTitle,
      this.vehiculeImmatriculation,
      this.vehiculeCylinder,
      this.vehiculeDateMiseEnCirculation,
      this.vehiculeCarburant,
      this.entList,
      this.compteurList,
      this.isDark,
      this.backgroundColor,
      this.connection,
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
            vehiculeTitle,
            vehiculeImmatriculation,
            vehiculeCylinder,
            vehiculeDateMiseEnCirculation,
            vehiculeCarburant,
            entList,
            compteurList,
            isDark,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                connection != null
                    ? 'Connexion établie'
                    : 'Connexion non établie',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          LineChartWidget(isDark),
        ],
      ),
    );
  }
}
