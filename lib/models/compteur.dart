// ignore_for_file: file_names

class Compteur {
  final String id;
  final int kilometrage;
  final DateTime date;
  final int kilometrageParcouru;
  final double moyConsommation;

  const Compteur({
    required this.id,
    required this.date,
    required this.kilometrage,
    required this.kilometrageParcouru,
    required this.moyConsommation,
  });

  // copyWith: tous les params sont optionnels
  Compteur copyWith({
    String? id,
    int? kilometrage,
    DateTime? date,
    int? kilometrageParcouru,
    double? moyConsommation,
  }) {
    return Compteur(
      id: id ?? this.id,
      date: date ?? this.date,
      kilometrage: kilometrage ?? this.kilometrage,
      kilometrageParcouru: kilometrageParcouru ?? this.kilometrageParcouru,
      moyConsommation: moyConsommation ?? this.moyConsommation,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'kilometrage': kilometrage,
    'kilometrageParcouru': kilometrageParcouru,
    'moyConsommation': moyConsommation,
  };

  factory Compteur.fromJson(Map<String, dynamic> j) => Compteur(
    id: j['id'] as String,
    date: DateTime.parse(j['date'] as String),
    kilometrage: (j['kilometrage'] as num).toInt(),
    kilometrageParcouru: (j['kilometrageParcouru'] as num).toInt(),
    moyConsommation: (j['moyConsommation'] as num).toDouble(),
  );

  @override
  String toString() => 'Compteur('
      'id: $id, '
      'km: $kilometrage, '
      'date: $date, '
      'kmParcouru: $kilometrageParcouru, '
      'conso: $moyConsommation)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Compteur &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              kilometrage == other.kilometrage &&
              date == other.date &&
              kilometrageParcouru == other.kilometrageParcouru &&
              moyConsommation == other.moyConsommation;

  @override
  int get hashCode =>
      id.hashCode ^
      kilometrage.hashCode ^
      date.hashCode ^
      kilometrageParcouru.hashCode ^
      moyConsommation.hashCode;
}
