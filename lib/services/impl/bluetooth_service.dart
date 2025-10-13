import 'package:furious_app/services/service.dart';

class BluetoothService extends Service {
  bool get isAvailable => false;

  Future<void> scan() async {
    // TODO: implémenter avec ton package Bluetooth
  }

  Future<void> connect(String deviceId) async {
    // TODO
  }

  Future<void> disconnect() async {
    // TODO
  }
}
