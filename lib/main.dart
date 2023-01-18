import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/composant/Voiture.dart';
import 'package:furious_app/pages/account_page.dart';
import 'package:furious_app/pages/compteur_page.dart';
import 'package:furious_app/pages/entretien_list.dart';
import 'package:furious_app/pages/entretien_page.dart';
import 'package:furious_app/pages/my_home_page.dart';
import 'package:furious_app/widget/compteur_list.dart';
import 'package:furious_app/widget/new_compteur.dart';
import 'package:furious_app/widget/new_entretien.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // locked the app in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

Future<Voiture> fetchCarData(immatriculation) async {
  String url =
      'https://www.mister-auto.com/nwsAjax/Plate?captcha_token=&family_id=0&generic_id=0&category_id=0&locale=fr_FR&device=desktop&pageType=homepage&country=FR&lang=fr&captchaVersion=v3&plate_selector_vof=&immatriculation=';
  final response = await http.get(Uri.parse(url + immatriculation));
  if (response.statusCode == 200) {
    return Voiture.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Echec de la récupération des données');
  }
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
  int _isDark = 0;

  String vehiculeTitle = '';
  String vehiculeImmatriculation = '';
  String vehiculeDateConstructeur = '';
  String vehiculeDateMiseEnCirculation = '';
  String vehiculeCarburant = '';

  @override
  void initState() {
    super.initState();
    futureVoiture = fetchCarData('FW-696-BY');
    futureVoiture.then((value) {
      setState(() {
        vehiculeTitle = value.title;
        vehiculeImmatriculation = value.immatriculation;
        vehiculeDateConstructeur = value.dateConstructeur;
        vehiculeDateMiseEnCirculation = value.dateMiseEnCirculation;
        vehiculeCarburant = value.carburant;
      });
    });
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getInt('isDark') ?? 0;
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  void _setIsDark(bool isDark) {
    // save the value in shared preferences
    setState(() {
      isDark ? _isDark = 1 : _isDark = 0;
    });
  }

  void _addNewEntretien(
    int newKilometrage,
    String newType,
    double newPrix,
    DateTime newDate,
  ) {
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

  void _addNewCompteur(
    int newKilometrage,
    DateTime newDate,
    int newKilometrageParcouru,
    double newMoyConsommation,
  ) {
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
          child: NewEntretien(_addNewEntretien, _isDark),
          behavior: HitTestBehavior.opaque,
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
          child: NewCompteur(_addNewCompteur, _isDark),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final entListWidget = EntretienList(_entretienList, _deleteEntretien, _isDark);
    final compteurListWidget = CompteurList(_compteurList, _deleteCompteur, _isDark);

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          color: [
            Color(0xFFE5E5E5),
            Colors.grey[800],
          ][_isDark],
          child: [
            MyHomePage(
              vehiculeTitle,
              vehiculeImmatriculation,
              vehiculeDateConstructeur,
              vehiculeDateMiseEnCirculation,
              vehiculeCarburant,
              _entretienList,
              _compteurList,
              _isDark,
            ),
            EntretienPage(
              entListWidget,
              _startAddNewEntretien,
              _isDark,
            ),
            CompteurPage(
              compteurListWidget,
              _startAddNewCompteur,
              _isDark,
            ),
            AccountPage(_setIsDark, _isDark),
          ][_index],
        ),
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: [
                Colors.white,
                Colors.grey[900],
              ][_isDark],
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
              ],
            )),
        // make texte colors to white
      ),
    );
  }
}
