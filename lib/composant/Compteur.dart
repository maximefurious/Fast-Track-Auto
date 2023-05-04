// ignore_for_file: file_names

class Compteur {
  final String id;
  final int kilometrage;
  final DateTime date;
  final int kilometrageParcouru;
  final double moyConsommation;

  Compteur({
    required this.id,
    required this.date,
    required this.kilometrage,
    required this.kilometrageParcouru,
    required this.moyConsommation,
  });

  int get getKilometrage {
    return kilometrage;
  }

  double get getMoyConsommation {
    return moyConsommation;
  }
}