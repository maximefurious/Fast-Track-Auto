import 'package:flutter/material.dart';

import 'package:furious_app/pages/account_page.dart';
import 'package:furious_app/pages/carnet_page.dart';
import 'package:furious_app/pages/compteur/compteur_list.dart';
import 'package:furious_app/pages/entretien/entretien_list.dart';
import 'package:furious_app/pages/my_home_page.dart' as my_home; // si ton fichier s'appelle MyHomePage.dart, ajuste ce chemin

import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/pages/new_compteur.dart';
import 'package:furious_app/pages/new_entretien.dart';
import 'package:furious_app/services/impl/compteur_service.dart';
import 'package:furious_app/services/impl/entretien_service.dart';
import 'package:furious_app/services/impl/pdf_report_service.dart';

// Services/Theme
import 'package:furious_app/services/service_manager.dart';
import 'package:furious_app/services/impl/theme_service.dart';
import 'package:furious_app/services/impl/vehicle_service.dart';
import 'package:furious_app/services/impl/bluetooth_service.dart';
import 'package:furious_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enregistre les services
  final sm = ServiceManager.instance;
  sm
    ..register<ThemeService>(ThemeService())
    ..register<VehicleService>(VehicleService())
    ..register<BluetoothService>(BluetoothService())
    ..register<PdfReportService>(PdfReportService())
    ..register<EntretienService>(EntretienService()) // NEW
    ..register<CompteurService>(CompteurService());   // NEW

  await sm.initAll();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final sm = ServiceManager.instance;

  @override
  Widget build(BuildContext context) {
    final themeService = sm.get<ThemeService>();

    return AnimatedBuilder(
      animation: themeService.mode,
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeService.mode.value,
          home: const _RootTabs(),
        );
      },
    );
  }
}

/// Pont temporaire pour générer ton colorMap depuis ThemeData
Map<String, Color> colorMapFromTheme(BuildContext context) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  return {
    'primaryColor': cs.primary,
    'onPrimary': cs.onPrimary,
    'secondaryColor': cs.surface,
    'onSecondary': cs.onSurface,
    'background': theme.scaffoldBackgroundColor,
    'surface': cs.surface,
    'onSurface': cs.onSurface,
    'surfaceVariant': cs.surfaceContainerHighest,
    'onSurfaceVariant': cs.onSurfaceVariant,
    'error': cs.error,
    'onError': cs.onError,
  };
}

/// Widget racine avec la BottomNav et l’état partagé
class _RootTabs extends StatefulWidget {
  const _RootTabs();
  @override
  State<_RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<_RootTabs> {
  final sm = ServiceManager.instance;
  int _index = 0;

  bool get _isDark => sm.get<ThemeService>().mode.value == ThemeMode.dark;

  Map<String, dynamic> vehiculeMap = {
    'title': 'Ma voiture',
    'immatriculation': 'AA-123-AA',
    'cylindrer': '1.2L',
    'dateMiseEnCirculation': '2020-01-01',
    'carburant': 'Essence',
  };

  // ==== Callbacks pages, maintenant via services ====

  void _setCurrentIndex(int i) => setState(() => _index = i);

  Future<void> _setIsDark(bool v) async {
    final themeService = sm.get<ThemeService>();
    await themeService.setMode(v ? ThemeMode.dark : ThemeMode.light);
    setState(() {});
  }

  void _setVehiculeImmatriculation(String plate) {
    setState(() => vehiculeMap['immatriculation'] = plate);
  }

  Future<void> _updateData() async {
    final vehicleService = sm.get<VehicleService>();
    final plate = vehiculeMap['immatriculation']?.toString() ?? '';
    final v = await vehicleService.fetchByPlate(plate);
    setState(() {
      vehiculeMap['title'] = v.title;
      vehiculeMap['immatriculation'] = v.immatriculation;
      vehiculeMap['cylindrer'] = v.cylindrer;
      vehiculeMap['dateMiseEnCirculation'] = v.dateMiseEnCirculation;
      vehiculeMap['carburant'] = v.carburant;
    });
  }

  Future<void> _startAddNewEntretien(BuildContext ctx) async {
    final Entretien? created = await Navigator.of(ctx).push<Entretien>(
      MaterialPageRoute(builder: (_) => const NewEntretienPage()),
    );
    if (created != null) {
      sm.get<EntretienService>().add(created);
      setState(() => _index = 1);
    }
  }

  Future<void> _startAddNewCompteur(BuildContext ctx) async {
    final Compteur? created = await Navigator.of(ctx).push<Compteur>(
      MaterialPageRoute(builder: (_) => const NewCompteurPage()),
    );
    if (created != null) {
      sm.get<CompteurService>().add(created);
      setState(() => _index = 1);
    }
  }

  void _deleteEntretien(String id) => sm.get<EntretienService>().delete(id);
  void _updateEntretien(Entretien e) => sm.get<EntretienService>().update(e);

  void _deleteCompteur(String id) => sm.get<CompteurService>().delete(id);
  void _updateCompteur(Compteur c) => sm.get<CompteurService>().update(c);

  @override
  Widget build(BuildContext context) {
    final colorMap = colorMapFromTheme(context);
    final entretienSvc = sm.get<EntretienService>();
    final compteurSvc = sm.get<CompteurService>();

    // On écoute les 2 services pour reconstruire UI quand leurs listes changent
    return AnimatedBuilder(
      animation: Listenable.merge([entretienSvc, compteurSvc]),
      builder: (_, __) {
        final entListWidget =
        EntretienList(entretienSvc.items, _deleteEntretien, _updateEntretien);
        final compteurListWidget =
        CompteurList(compteurSvc.items, _deleteCompteur, _updateCompteur, colorMap);

        final pages = <Widget>[
          my_home.MyHomePage(
            vehiculeMap,
            entretienSvc.items,
            compteurSvc.items,
          ),
          CarnetPage(
            entListWidget,
            compteurListWidget,
            _startAddNewEntretien,
            _startAddNewCompteur,
            vehiculeMap,
          ),
          AccountPage(
            _setIsDark,
            _setVehiculeImmatriculation,
            _updateData,
            _isDark,
            vehiculeMap,
            entretienSvc.items,
            compteurSvc.items,
          ),
        ];

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox.expand(child: pages[_index]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: _setCurrentIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 3,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Carnet'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
            ],
          ),
        );
      },
    );
  }
}

