import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:furious_app/obd/Obd2Bluetooth.dart';

class BluetoothScanPage extends StatefulWidget {
  final Function _addNewCompteur;
  final Function _addBluetoothConnection;

  const BluetoothScanPage(this._addNewCompteur, this._addBluetoothConnection,
      {Key? key})
      : super(key: key);

  @override
  _BluetoothScanPageState createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  List<BluetoothDevice> devicesList = [];
  BluetoothConnection? _connection;
  Obd2Bluetooth? _obd2Bluetooth;

  ListView _listBluetoothDevices() {
    return ListView.builder(
      itemCount: devicesList.length,
      itemBuilder: (BuildContext context, int index) {
        BluetoothDevice device = devicesList[index];
        return ListTile(
          title: Text(device.name ?? 'Unknown device'),
          subtitle: Text(device.address),
          onTap: () {
            _connectToDevice(device);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: _listBluetoothDevices(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _startDiscovery();
                    },
                    elevation: 10,
                    child: const Icon(Icons.search),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      await _disconnect();
                    },
                    elevation: 10,
                    child: const Icon(Icons.bluetooth_disabled),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Commande OBD2',
              ),
              // enabled: _connection != null,
              onSubmitted: (String command) async {
                // Send the command to the device
                String? response = await _obd2Bluetooth?.getParameterValue(command);
                
                // show reponse in a dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Réponse'),
                      content: Text(response!),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startDiscovery() async {
    try {
      if (devicesList.isNotEmpty) {
        setState(() {
          devicesList.clear();
        });
      }

      // Get bonded devices first
      List<BluetoothDevice> bondedDevices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      // Start scanning for Bluetooth devices
      Stream<BluetoothDiscoveryResult> stream =
          FlutterBluetoothSerial.instance.startDiscovery();

      stream.listen((result) {
        BluetoothDevice device = result.device;

        if (!devicesList.contains(device)) {
          setState(() {
            if (device.name != null && device.name != "") {
              devicesList.add(device);
            }
          });
        }
      });

      // Wait for scanning to finish
      await Future.delayed(const Duration(seconds: 10));

      setState(() {
        devicesList.addAll(bondedDevices);
      });
    } catch (ex) {
      SnackBar snackBar = SnackBar(
        content:
            Text('Erreur lors de la recherche de périphériques Bluetooth: $ex'),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      // Disconnect the current connection if it exists
      await _disconnect();

      // Connect to the device and when connected set the state
      BluetoothConnection connexion = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _connection = connexion;
      });

      // Initialize the Obd2Bluetooth object if the connection is successful
      if (_connection != null) {
        setState(() {
          _obd2Bluetooth = Obd2Bluetooth(
            context: context,
            connection: _connection,
          );
        });
        widget._addBluetoothConnection(_connection!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecté à ${device.name}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (ex) {
      SnackBar snackBar = SnackBar(
        content: Text(
            'Erreur lors de la tentative de connexion à ${device.name} because of $ex'),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _disconnect() async {
    try {
      // Close the current connection if it exists
      if (_connection != null) {
        await _connection!.close();
        setState(() {
          _connection = null;
          _obd2Bluetooth = null;
        });
        widget._addBluetoothConnection(null);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Déconnecté'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (ex) {
      SnackBar snackBar = SnackBar(
        content:
            Text('Erreur lors de la tentative de déconnexion because of $ex'),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // void _getInstantConsumption(context) async {
  //   String? vehicleSpeed =
  //       await _obd2Bluetooth?.getParameterValue(Obd2Bluetooth.vehicleSpeed);
  //   String? mafAirFlowRate =
  //       await _obd2Bluetooth?.getParameterValue(Obd2Bluetooth.mafAirFlowRate);

  //   double? instantConsumption = _obd2Bluetooth?.getInstantConsumption(
  //       vehicleSpeed, mafAirFlowRate, 1.0);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('instantConsumption: $instantConsumption\n'),
  //       duration: const Duration(seconds: 10),
  //     ),
  //   );
  // }
}
