import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/services/service.dart';

class EntretienService extends ChangeNotifier implements Service {
  final List<Entretien> _items = <Entretien>[];

  // Service lifecycle
  bool _initialized = false;
  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> init() async {
    // load if needed
    _initialized = true;
  }

  @override
  Future<void> dispose() async {
    // dispose ChangeNotifier first
    super.dispose(); // <- ChangeNotifier.dispose()
    _initialized = false;
  }

  // API
  UnmodifiableListView<Entretien> get items => UnmodifiableListView(_items);

  void add(Entretien e) {
    _items.add(e);
    notifyListeners();
  }

  void update(Entretien e) {
    final i = _items.indexWhere((x) => x.id == e.id);
    if (i != -1) {
      _items[i] = e;
      notifyListeners();
    }
  }

  void delete(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void replaceAll(Iterable<Entretien> list) {
    _items
      ..clear()
      ..addAll(list);
    notifyListeners();
  }
}
