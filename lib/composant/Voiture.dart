// ignore_for_file: file_names
class Voiture {
  final String id;
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
    String id = json['vehicule'][0]['id'].toString();
    String libelle = json['vehicule'][0]['libelle'];
    String immatriculation = json['numberPlate'].toString().toUpperCase();
    List<String> libelleSplit = json['vehicule'][0]['libelle'].split(' ');
    String cylindrer = "${libelleSplit[libelleSplit.length - 3]} ${libelleSplit[libelleSplit.length - 2]} ${libelleSplit[libelleSplit.length - 1]}";
    String dateMiseEnCirculation = json['firstRegistrationDate'];
    String carburant = json['vehicule'][0]['carburant'];

    return Voiture(
      id: id,
      title: libelle,
      immatriculation: immatriculation,
      cylindrer: cylindrer,
      dateMiseEnCirculation: dateMiseEnCirculation,
      carburant: carburant,
    );
  }
}
