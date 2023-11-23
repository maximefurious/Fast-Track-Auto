// ignore_for_file: file_names

class Compteur {
  final String id;
  int kilometrage;
  DateTime date;
  int kilometrageParcouru;
  double moyConsommation;

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

  int get getKilometrageParcouru {
    return kilometrageParcouru;
  }

  DateTime get getDate {
    return date;
  }
}
