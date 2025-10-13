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

  factory Voiture.fromJson(Map<String, dynamic> j) => Voiture(
    id: j['id'] ?? '0',
    title: j['title'] ?? 'Inconnu',
    immatriculation: j['immatriculation'] ?? 'Inconnue',
    cylindrer: j['cylindrer'] ?? 'Inconnue',
    dateMiseEnCirculation: j['dateMiseEnCirculation'] ?? 'Inconnue',
    carburant: j['carburant'] ?? 'Inconnue',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'immatriculation': immatriculation,
    'cylindrer': cylindrer,
    'dateMiseEnCirculation': dateMiseEnCirculation,
    'carburant': carburant,
  };

  // Compat avec ton ancien fromJson2
  factory Voiture.fromJson2(Map<String, dynamic> j) => Voiture.fromJson(j);
}
