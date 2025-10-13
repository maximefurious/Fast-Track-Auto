import 'dart:async';
import 'dart:convert';
import 'package:furious_app/models/voiture.dart';
import 'package:furious_app/services/service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleService extends Service {
  static const _kStorageKey = 'voiture.current';

  Voiture? _current;
  Voiture? get current => _current;

  String normalizePlate(String plate) =>
      plate.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kStorageKey);
    if (s != null) {
      _current = Voiture.fromJson(jsonDecode(s));
    }
  }

  Future<void> saveToStorage(Voiture v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStorageKey, jsonEncode(v.toJson()));
  }

  Future<Voiture> fetchByPlate(String immatriculation) async {
    final normalized = normalizePlate(immatriculation);
    final url = Uri.https('www.mister-auto.com', '/nwsAjax/Plate', {
      'captcha_token': '',
      'family_id': '0',
      'generic_id': '0',
      'category_id': '0',
      'locale': 'fr_FR',
      'device': 'desktop',
      'pageType': 'homepage',
      'country': 'FR',
      'lang': 'fr',
      'captchaVersion': 'v3',
      'plate_selector_vof': '',
      'immatriculation': normalized,
    });

    try {
      final resp = await http
          .get(url, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode == 200) {
        return Voiture.fromJson2(jsonDecode(resp.body));
      }
    } on TimeoutException {
      // log si besoin
    } catch (_) {
      // log si besoin
    }

    return Voiture(
      id: '0',
      title: 'Aucune voiture trouvée',
      immatriculation: immatriculation,
      cylindrer: 'Inconnue',
      dateMiseEnCirculation: 'Inconnue',
      carburant: 'Inconnue',
    );
  }

  Future<Voiture> updateByPlate(String immatriculation) async {
    final v = await fetchByPlate(immatriculation);
    _current = v;
    await saveToStorage(v);
    return v;
  }

  @override
  Future<void> init() async {
    await super.init();
    await loadFromStorage();
  }
}
