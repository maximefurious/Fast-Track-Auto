import 'package:flutter/foundation.dart';

abstract class Service {
  bool _initialized = false;

  @mustCallSuper
  Future<void> init() async {
    _initialized = true;
  }

  @mustCallSuper
  Future<void> dispose() async {
    _initialized = false;
  }

  bool get isInitialized => _initialized;
}
