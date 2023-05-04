// ignore_for_file: file_names

import 'dart:ffi';

class Voiture {
  final int id;
  final String title;
  final String immatriculation;
  final String cylindrer;
  final String dateMiseEnCirculation;
  final String carburant;
  
  Voiture({
    required this.id,
    required this.title,
    required this.immatriculation,
    required this.cylindrer,
    required this.dateMiseEnCirculation,
    required this.carburant,
  });

  factory Voiture.fromJson2(Map<String, dynamic> json) {
    return Voiture(
      id: int.parse(json['all'][0]['idVehicule']),
      title: json['all'][0]['brand']['label'] + ' ' + json['all'][0]['model']['label'],
      immatriculation: json['all'][0]['immatAttributes'][6]['value'],
      cylindrer: json['all'][0]['cyl']['label'],
      dateMiseEnCirculation: json['all'][0]['immatAttributes'][1]['value'],
      carburant: json['all'][0]['immatAttributes'][10]['value'],
    );
  }
}
