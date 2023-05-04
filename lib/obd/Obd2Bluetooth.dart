import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

class Obd2Bluetooth {
  static const String engineCoolantTemperature = "0105"; 
  static const String fuelPressure = "010A";
  static const String intakeManifoldPressure = "010B";
  static const String engineRPM = "010C";
  static const String vehicleSpeed = "010D";
  static const String intakeAirTemperature = "010F";
  static const String mafAirFlowRate = "0110";
  static const String runTimeSinceEngineStart = "011F";
  static const String fuelLevelInput = "012F";
  static const String distanceTraveledWithMILOn = "0131";
  static const String barometricPressure = "0133";
  static const String ambientAirTemperature = "0146";

  BluetoothConnection? connection;
  BuildContext context;

  Obd2Bluetooth({
    required this.context,
    required this.connection,
  });


  Future<bool>sendOBD2Command(String command) async {
    try {
      if (connection == null) {
        SnackBar snackBar = const SnackBar(
          content: Text('Pas de connexion Bluetooth'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }

      // Add \r character at the end of the command
      command += '\r';

      // Convert the command to bytes and send to the device
      connection!.output.add(Uint8List.fromList(utf8.encode(command)));
      await connection!.output.allSent;

      // Read the response from the device
      String response = '';
      await connection!.input?.forEach((Uint8List data) {
        response += utf8.decode(data);
      });      

      return true;
    } catch (ex) {
      SnackBar snackBar = SnackBar(
        content: Text('Erreur lors de l\'envoi de la commande au périphérique : $ex'),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

   // Send a command and read the response from the device
  Future<String?> sendAndRead(String command) async {
    try {
      // Send the command to the device
      bool success = await sendOBD2Command(command);
      if (!success) {
        return null;
      }

      // Wait for the response from the device
      List<int> bytes = [];
      StreamSubscription subscription = connection!.input!.listen((data) {
        bytes.addAll(data);
      });

      await Future.delayed(const Duration(milliseconds: 500));
      await subscription.cancel();

      // Convert the bytes to a string and return the response
      String response = utf8.decode(Uint8List.fromList(bytes));
      return response;
    } catch (ex) {
      SnackBar snackBar = SnackBar(
        content: Text('Erreur lors de l\'envoi de la commande au périphérique : $ex'),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  // Get the value of a specific OBD2 parameter
  Future<String?> getParameterValue(String parameter) async {
    String command = '$parameter\r';
    String? response = await sendAndRead(command);

    if (response == null || response.isEmpty) {
      return null;
    }

    // Extract the value from the response
    List<String> parts = response.split(' ');
    if (parts.length < 2) {
      return null;
    }

    String value = parts[2];
    return value;
  }

  // Get the supported OBD2 parameters for a specific mode
  Future<List<String>?> getSupportedParameters(int mode) async {
    String command = '01 $mode\r';
    String? response = await sendAndRead(command);

    if (response == null || response.isEmpty) {
      return null;
    }

    // Extract the supported parameters from the response
    List<String> parts = response.split('\r');
    if (parts.length < 2) {
      return null;
    }

    String supportedParams = parts[1];
    List<String> params = supportedParams.split(' ');
    params.removeAt(0); // Remove the mode byte from the list
    params.removeLast(); // Remove the checksum byte from the list

    return params;
  }

  double getVehicleSpeed(vehicleSpeed) {
    // Ignore first two bytes [hh hh] of the response.
    return (int.parse(vehicleSpeed.substring(4, 6) + vehicleSpeed.substring(2, 4), radix: 16)) / 100;
  }

  double getInstantConsumption(vehicleSpeed, pressionAbsolutAdmission, tempLiquideRefroidissement) {
    double maf = (pressionAbsolutAdmission * 120) / (tempLiquideRefroidissement + 273) * 100 / 60;
    return (14.7 * maf) / (3.785 * getVehicleSpeed(vehicleSpeed) * 0.6214);
  }
}
