import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/services/service.dart';

class CompteurService extends ChangeNotifier implements Service {
  final List<Compteur> _items = <Compteur>[];

  // Service lifecycle
  bool _initialized = false;
  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> init() async {
    _initialized = true;
  }

  @override
  Future<void> dispose() async {
    super.dispose(); // ChangeNotifier.dispose()
    _initialized = false;
  }

  // API
  UnmodifiableListView<Compteur> get items => UnmodifiableListView(_items);

  void add(Compteur c) {
    _items.add(c);
    notifyListeners();
  }

  void update(Compteur c) {
    final i = _items.indexWhere((x) => x.id == c.id);
    if (i != -1) {
      _items[i] = c;
      notifyListeners();
    }
  }

  void delete(String id) {
    _items.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void replaceAll(Iterable<Compteur> list) {
    _items
      ..clear()
      ..addAll(list);
    notifyListeners();
  }
}
