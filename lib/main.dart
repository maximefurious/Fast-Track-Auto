import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:furious_app/bluetooth/BluetoothScanPage.dart';
// import 'package:furious_app/bluetooth/DiscoveryPage.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:furious_app/composant/Voiture.dart';
import 'package:furious_app/pages/account_page.dart';
import 'package:furious_app/pages/carnet_page.dart';
import 'package:furious_app/pages/entretien/entretien_list.dart';
import 'package:furious_app/pages/my_home_page.dart';
import 'package:furious_app/pages/compteur/compteur_list.dart';
import 'package:furious_app/pages/compteur/new_compteur.dart';
import 'package:furious_app/pages/entretien/new_entretien.dart';
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
  // https://www.norauto.fr/next-e-shop/car-selector/identification/reg-vin/FW696-BY?shop=9902&reg-country=FR
  print('Requesting data for $immatriculation');
  // String url = 'https://www.norauto.fr/next-e-shop/car-selector/identification/reg-vin/external/FW696BY?shop=9902&reg-country=FR';
  String url = 'https://www.mister-auto.com/nwsAjax/Plate?captcha_token=&family_id=0&generic_id=0&category_id=0&locale=fr_FR&device=desktop&pageType=homepage&country=FR&lang=fr&captchaVersion=v3&plate_selector_vof=&immatriculation=fw-696-BY';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*'
  };
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  if (response.statusCode == 200) {
    return Voiture.fromJson2(jsonDecode(response.body));
  }
  print('Request failed with status: ${response.statusCode}.');
  return Voiture(
      id: "0",
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

  bool _isDark = false;

  HashMap<String, Color> colorMap = HashMap();
  Map<String, dynamic> vehiculeMap = {
    'title': 'Aucune voiture trouvée',
    'immatriculation': 'Inconnue',
    'cylindrer': 'Inconnue',
    'dateMiseEnCirculation': 'Inconnue',
    'carburant': 'Inconnue'
  };

  // BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();

    // TODO Faire une page de configuration pour choisir la voiture
    futureVoiture = fetchCarData('FW-696-BY');
    futureVoiture.then((value) {
      setState(() {
        vehiculeMap['title'] = value.title.toString();
        vehiculeMap['immatriculation'] = value.immatriculation.toString();
        vehiculeMap['cylindrer'] = value.cylindrer.toString();
        vehiculeMap['dateMiseEnCirculation'] =
            value.dateMiseEnCirculation.toString();
        vehiculeMap['carburant'] = value.carburant.toString();
      });
    });
    initSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    // connection?.dispose();
  }

  void _updateData() {
    futureVoiture =
        fetchCarData(vehiculeMap['immatriculation'].toString().toUpperCase());
    futureVoiture.then((value) {
      setState(() {
        vehiculeMap['title'] = value.title;
        vehiculeMap['immatriculation'] = value.immatriculation;
        vehiculeMap['cylindrer'] = value.cylindrer;
        vehiculeMap['dateMiseEnCirculation'] = value.dateMiseEnCirculation;
        vehiculeMap['carburant'] = value.carburant;
      });
    });
  }

  void initSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setIsDark(prefs.getBool('isDark') ?? false);
    _setEntretien(prefs.getString('entretienList') ?? "");
    _setCompteur(prefs.getString('compteurList') ?? "");
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  void _setIsDark(bool isDark) {
    print("Initialisation du thème");
    setState(() {
      _isDark = isDark;
      colorMap['text'] = isDark ? Colors.white : Colors.black;
      colorMap['background'] =
          isDark ? Colors.grey[800]! : const Color(0xFFE5E5E5);
      colorMap['cardColor'] = isDark ? Colors.grey[900]! : Colors.white;
      colorMap['textFieldColor'] = isDark ? Colors.black : Colors.white;
      colorMap['primaryColor'] =
          isDark ? Colors.grey[800]! : const Color.fromARGB(255, 154, 0, 149);
      colorMap['secondaryColor'] = isDark ? Colors.grey[900]! : Colors.white;
    });
  }

  void _setEntretien(String entretienList) {
    print("Chargement des entretiens depuis le cache");
    if (entretienList == "") return;
    Map<String, dynamic> data = jsonDecode(entretienList);

    data.forEach((key, value) {
      value = jsonDecode(value);
      final newEntretien = Entretien(
        id: value['id'],
        kilometrage: value['kilometrage'],
        type: value['type'],
        prix: value['prix'],
        date: DateTime.parse(value['date']),
      );

      setState(() {
        _entretienList.add(newEntretien);
        saveEntretien();
      });
    });
  }

  void _setCompteur(String compteurList) {
    print("Chargement des compteurs depuis le cache");
    if (compteurList == "") return;
    Map<String, dynamic> data = jsonDecode(compteurList);

    data.forEach((key, value) {
      value = jsonDecode(value);
      final newCompteur = Compteur(
        id: value['id'],
        kilometrage: value['kilometrage'],
        date: DateTime.parse(value['date']),
        kilometrageParcouru: value['kilometrageParcouru'],
        moyConsommation: value['moyConsommation'],
      );

      setState(() {
        _compteurList.add(newCompteur);
        saveCompteur();
      });
    });
  }

  void _setVehiculeImmatriculation(String immatriculation) {
    setState(() {
      vehiculeMap['immatriculation'] = immatriculation.toUpperCase();
    });
  }

  void _addNewEntretien(int newKilometrage, String newType, double newPrix, DateTime newDate) {
    final newEntretien = Entretien(
      id: DateTime.now().toString(),
      kilometrage: newKilometrage,
      type: newType,
      prix: newPrix,
      date: DateTime.now(),
    );

    setState(() {
      _entretienList.add(newEntretien);
      saveEntretien();
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
      saveCompteur();
    });
  }

  void _deleteEntretien(String id) {
    setState(() {
      _entretienList.removeWhere((entretien) => entretien.id == id);
      saveEntretien();
    });
  }

  void _deleteCompteur(String id) {
    setState(() {
      _compteurList.removeWhere((compteur) => compteur.id == id);
      saveCompteur();
    });
  }

  void _updateEntretien(
      String id, int kilometrage, String type, double prix, DateTime date) {
    setState(() {
      _entretienList.removeWhere((entretien) => entretien.id == id);
      _entretienList.add(Entretien(
        id: id,
        kilometrage: kilometrage,
        type: type,
        prix: prix,
        date: date,
      ));
      saveEntretien();
    });
  }

  /// Save entretien list to shared preferences
  void saveEntretien() {
    Map<String, dynamic> data = {};

    for (var entretien in _entretienList) {
      data[entretien.id] = "{\"id\": \"${entretien.id}\", \"kilometrage\": ${entretien.kilometrage}, \"type\": \"${entretien.type}\", \"prix\": ${entretien.prix}, \"date\": \"${entretien.date}\"}";
    }

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('entretienList', jsonEncode(data));
    });
  }

  /// Save compteur list to shared preferences
  void saveCompteur() {
    Map<String, dynamic> data = {};

    for (var compteur in _compteurList) {
      data[compteur.id] = "{\"id\": \"${compteur.id}\", \"kilometrage\": ${compteur.kilometrage}, \"date\": \"${compteur.date}\", \"kilometrageParcouru\": ${compteur.kilometrageParcouru}, \"moyConsommation\": ${compteur.moyConsommation}}";
    }

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('compteurList', jsonEncode(data));
    });
  }

  void _updateCompteur(String id, int kilometrage, DateTime date,
      int kilometrageParcouru, double moyConsommation) {
    setState(() {
      _compteurList.removeWhere((compteur) => compteur.id == id);
      _compteurList.add(Compteur(
        id: id,
        kilometrage: kilometrage,
        date: date,
        kilometrageParcouru: kilometrageParcouru,
        moyConsommation: moyConsommation,
      ));
      saveCompteur();
    });
  }

  void _startAddNewEntretien(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewEntretien(_addNewEntretien, colorMap),
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
          child: NewCompteur(_addNewCompteur, colorMap),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget entListWidget = EntretienList(
        _entretienList, _deleteEntretien, _updateEntretien, colorMap);
    Widget compteurListWidget =
        CompteurList(_compteurList, _deleteCompteur, _updateCompteur, colorMap);

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          color: colorMap['background'],
          child: [
            MyHomePage(
              vehiculeMap,
              _entretienList,
              _compteurList,
              colorMap,
              // connection,
            ),
            CarnetPage(
              entListWidget,
              compteurListWidget,
              _startAddNewEntretien,
              _startAddNewCompteur,
              colorMap,
              vehiculeMap,
            ),
            AccountPage(
              _setIsDark,
              _setVehiculeImmatriculation,
              _updateData,
              _isDark,
              colorMap,
              vehiculeMap,
              _entretienList,
              _compteurList,
            ),
            // DiscoveryPage()
            // BluetoothScanPage(_addNewCompteur, _addBluetoothConnection),
          ][_index],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: colorMap['secondaryColor'],
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (index) => _setCurrentIndex(index),
            selectedItemColor: colorMap['primaryColor'],
            unselectedItemColor: Colors.grey,
            elevation: 5,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Carnet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.settings),
              //   label: 'Settings',
              // )
            ],
          ),
        ),
      ),
    );
  }
}
