// ignore_for_file: file_names

class Entretien {
  final String id;
  final String type;
  final int kilometrage;
  final DateTime date;
  final double prix;

  Entretien({
    required this.id,
    required this.date,
    required this.kilometrage,
    required this.type,
    required this.prix,
  });
}