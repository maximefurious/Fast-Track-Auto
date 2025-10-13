import 'service.dart';

class ServiceManager {
  ServiceManager._();
  static final ServiceManager instance = ServiceManager._();

  final Map<Type, Service> _services = {};

  void register<T extends Service>(T service) {
    _services[T] = service;
  }

  T get<T extends Service>() {
    final s = _services[T];
    if (s == null) {
      throw StateError('Service ${T.toString()} non enregistré');
    }
    return s as T;
  }

  Future<void> initAll() async {
    for (final s in _services.values) {
      if (!s.isInitialized) {
        await s.init();
      }
    }
  }

  Future<void> disposeAll() async {
    for (final s in _services.values) {
      await s.dispose();
    }
  }
}
