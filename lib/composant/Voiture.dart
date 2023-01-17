class Voiture {
  final int id;
  final String title;
  final String immatriculation;
  final String dateConstructeur;
  final String dateMiseEnCirculation;
  final String carburant;
  
  Voiture({
    required this.id,
    required this.title,
    required this.immatriculation,
    required this.dateConstructeur,
    required this.dateMiseEnCirculation,
    required this.carburant,
  });

  factory Voiture.fromJson(Map<String, dynamic> json) {
    return Voiture(
      id: json['vehicule'][0]['id'],
      title: json['vehicule'][0]['libelle'],
      immatriculation: json['numberPlate'],
      dateConstructeur: json['vehicule'][0]['annee'],
      dateMiseEnCirculation: json['firstRegistrationDate'],
      carburant: json['vehicule'][0]['carburant'],
    );
  }
}
