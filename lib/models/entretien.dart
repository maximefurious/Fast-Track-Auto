// ignore_for_file: file_names

class Entretien {
  final String id;
  final String type;
  final int kilometrage;
  final DateTime date;
  final double prix;

  const Entretien({
    required this.id,
    required this.date,
    required this.kilometrage,
    required this.type,
    required this.prix,
  });

  // copyWith: tous les params sont optionnels
  Entretien copyWith({
    String? id,
    String? type,
    int? kilometrage,
    DateTime? date,
    double? prix,
  }) {
    return Entretien(
      id: id ?? this.id,
      type: type ?? this.type,
      kilometrage: kilometrage ?? this.kilometrage,
      date: date ?? this.date,
      prix: prix ?? this.prix,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'kilometrage': kilometrage,
    'date': date.toIso8601String(),
    'prix': prix,
  };

  factory Entretien.fromJson(Map<String, dynamic> j) => Entretien(
    id: j['id'] as String,
    type: j['type'] as String,
    kilometrage: (j['kilometrage'] as num).toInt(),
    date: DateTime.parse(j['date'] as String),
    prix: (j['prix'] as num).toDouble(),
  );

  @override
  String toString() =>
      'Entretien(id: $id, type: $type, km: $kilometrage, date: $date, prix: $prix)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Entretien &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              type == other.type &&
              kilometrage == other.kilometrage &&
              date == other.date &&
              prix == other.prix;

  @override
  int get hashCode =>
      id.hashCode ^ type.hashCode ^ kilometrage.hashCode ^ date.hashCode ^ prix.hashCode;
}
