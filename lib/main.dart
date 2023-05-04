import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:furious_app/bluetooth/BluetoothScanPage.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/composant/Voiture.dart';
import 'package:furious_app/pages/account_page.dart';
import 'package:furious_app/pages/compteur/compteur_page.dart';
import 'package:furious_app/pages/entretien/entretien_list.dart';
import 'package:furious_app/pages/entretien/entretien_page.dart';
import 'package:furious_app/pages/my_home_page.dart';
import 'package:furious_app/pages/compteur/compteur_list.dart';
import 'package:furious_app/pages/compteur/new_compteur.dart';
import 'package:furious_app/pages/entretien/new_entretien.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
void main() {
  // locked the app in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

Future<Voiture> fetchCarData(immatriculation) async {
  // https://www.norauto.fr/next-e-shop/car-selector/identification/reg-vin/FW696-BY?shop=9902&reg-country=FR
  String url =
      'https://www.norauto.fr/next-e-shop/car-selector/identification/reg-vin/$immatriculation?shop=9902&reg-country=FR';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return Voiture.fromJson2(jsonDecode(response.body));
  }
  return Voiture(
      id: 0,
      title: 'Aucune voiture trouvée',
      immatriculation: immatriculation,
      cylindrer: 'Inconnue',
      dateMiseEnCirculation: 'Inconnue',
      carburant: 'Inconnue');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Entretien> _entretienList = [];
  final List<Compteur> _compteurList = [];
  late Future<Voiture> futureVoiture;
  int _index = 0;

  String vehiculeTitle = '';
  String vehiculeImmatriculation = '';
  String vehiculeCylinder = '';
  String vehiculeDateMiseEnCirculation = '';
  String vehiculeCarburant = '';

  bool _isDark = false;

  Color _textColor = Colors.black;
  Color _backgroundColor = Colors.white;

  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    _requestPermission();

    // TODO Faire une page de configuration pour choisir la voiture
    futureVoiture = fetchCarData('FW-696-BY');
    futureVoiture.then((value) {
      setState(() {
        vehiculeTitle = value.title;
        vehiculeImmatriculation = value.immatriculation;
        vehiculeCylinder = value.cylindrer;
        vehiculeDateMiseEnCirculation = value.dateMiseEnCirculation;
        vehiculeCarburant = value.carburant;
      });
    });
    initSharedPrefs();
  }

  void _requestPermission() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  void _updateData() {
    futureVoiture = fetchCarData(vehiculeImmatriculation);
    futureVoiture.then((value) {
      setState(() {
        vehiculeTitle = value.title;
        vehiculeCylinder = value.cylindrer;
        vehiculeDateMiseEnCirculation = value.dateMiseEnCirculation;
        vehiculeCarburant = value.carburant;
      });
    });
  }

  void initSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  void _setIsDark(bool isDark) {
    // save the value in shared preferences
    setState(() {
      _isDark = isDark;
      _textColor = isDark ? Colors.white : Colors.black;
      _backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    });
  }

  void _setVehiculeImmatriculation(String immatriculation) {
    setState(() {
      vehiculeImmatriculation = immatriculation.toUpperCase();
    });
  }

  void _addNewEntretien(
    int newKilometrage, String newType, double newPrix, DateTime newDate) {
    final newEntretien = Entretien(
      id: DateTime.now().toString(),
      kilometrage: newKilometrage,
      type: newType,
      prix: newPrix,
      date: DateTime.now(),
    );

    setState(() {
      _entretienList.add(newEntretien);
    });
  }

  void _addNewCompteur(int newKilometrage, DateTime newDate,
      int newKilometrageParcouru, double newMoyConsommation) {
    final newCompteur = Compteur(
      id: DateTime.now().toString(),
      kilometrage: newKilometrage,
      date: DateTime.now(),
      kilometrageParcouru: newKilometrageParcouru,
      moyConsommation: newMoyConsommation,
    );

    setState(() {
      _compteurList.add(newCompteur);
    });
  }

  void _deleteEntretien(String id) {
    setState(() {
      _entretienList.removeWhere((entretien) => entretien.id == id);
    });
  }

  void _deleteCompteur(String id) {
    setState(() {
      _compteurList.removeWhere((compteur) => compteur.id == id);
    });
  }

  void _startAddNewEntretien(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewEntretien(_addNewEntretien, _isDark),
        );
      },
    );
  }

  void _startAddNewCompteur(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewCompteur(_addNewCompteur, _isDark),
        );
      },
    );
  }

  void _addBluetoothConnection(connexion) {
    setState(() {
      connection = connexion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entListWidget =
        EntretienList(_entretienList, _deleteEntretien, _isDark);
    final compteurListWidget =
        CompteurList(_compteurList, _deleteCompteur, _isDark);

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          color: [
            const Color(0xFFE5E5E5),
            Colors.grey[800],
          ][_isDark ? 1 : 0],
          child: [
            MyHomePage(
              vehiculeTitle,
              vehiculeImmatriculation,
              vehiculeCylinder,
              vehiculeDateMiseEnCirculation,
              vehiculeCarburant,
              _entretienList,
              _compteurList,
              _isDark,
              _backgroundColor,
              connection
            ),
            EntretienPage(
              entListWidget,
              _startAddNewEntretien,
              _isDark,
              _backgroundColor,
            ),
            CompteurPage(
              compteurListWidget,
              _startAddNewCompteur,
              _isDark,
              _backgroundColor,
            ),
            AccountPage(
              _setIsDark,
              _setVehiculeImmatriculation,
              _updateData,
              _isDark,
              vehiculeImmatriculation,
              _textColor,
              _backgroundColor,
              vehiculeTitle,
              vehiculeCylinder,
              vehiculeDateMiseEnCirculation,
              vehiculeCarburant,
              _entretienList,
              _compteurList,
            ),
            BluetoothScanPage(
              _addNewCompteur,
              _addBluetoothConnection
            ),
          ][_index],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: [
              Colors.white,
              Colors.grey[900],
            ][_isDark ? 1 : 0],
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (index) => _setCurrentIndex(index),
            selectedItemColor: Colors.deepPurpleAccent,
            unselectedItemColor: Colors.grey,
            elevation: 5,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.car_repair),
                label: 'Entretien',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.speed),
                label: 'Kilomètrage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              )
            ],
          ),
        ),
      ),
    );
  }
}
