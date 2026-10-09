enum FruitKind { 
  apple, 
  banana, 
  orange, 
  mango, 
  grapes, 
  strawberry,
  kiwi,
  chickoo,
  cherry,
}

class Fruit {
  const Fruit({
    this.id,
    required this.name,
    required this.scientificName,
    required this.kind,
    required this.kcal,
    required this.fiber,
    required this.sugar,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.vitaminC,
    required this.score,
    required this.servingSize,
    this.isFavorite = false,
  });

  final int? id;
  final String name;
  final String scientificName;
  final FruitKind kind;
  final double kcal;
  final double fiber;
  final double sugar;
  final double carbs;
  final double protein;
  final double fat;
  final double vitaminC;
  final int score;
  final String servingSize;
  final bool isFavorite;

  Fruit copyWith({bool? isFavorite}) {
    return Fruit(
      id: id,
      name: name,
      scientificName: scientificName,
      kind: kind,
      kcal: kcal,
      fiber: fiber,
      sugar: sugar,
      carbs: carbs,
      protein: protein,
      fat: fat,
      vitaminC: vitaminC,
      score: score,
      servingSize: servingSize,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static Fruit fromJson(Map<String, dynamic> json) {
    return Fruit(
      id: json['id'] as int?,
      name: json['name'] as String,
      scientificName: json['scientificName'] as String,
      kind: FruitKind.values.firstWhere((e) => e.name == json['kind']),
      kcal: (json['kcal'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      vitaminC: (json['vitaminC'] as num).toDouble(),
      score: json['healthScore'] as int,
      servingSize: json['servingSize'] as String,
      isFavorite: json['isFavorite'] == 1,
    );
  }
}
