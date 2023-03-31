import 'dart:convert';

class Barcode_products {
  final int? id;
  final String? food_code;
  final String? food_name;
  final int? food_quantity;
  final int? food_serving_size;
  final int? energy_kcal_100g;
  final double? carbohydrates_100g;
  final int? proteins_100g;
  final int? fat_100g;
  final int? sodium_100g;
  final int? calcium_100g;

  Barcode_products({
    this.id,
    this.food_code,
    this.food_name,
    this.food_quantity,
    this.food_serving_size,
    this.energy_kcal_100g,
    this.carbohydrates_100g,
    this.proteins_100g,
    this.fat_100g,
    this.sodium_100g,
    this.calcium_100g,
  });

  Barcode_products copyWith({
    int? id,
    String? food_code,
    String? food_name,
    int? food_quantity,
    int? food_serving_size,
    int? energy_kcal_100g,
    double? carbohydrates_100g,
    int? proteins_100g,
    int? fat_100g,
    int? sodium_100g,
    int? calcium_100g,
  }) {
    return Barcode_products(
      id: id ?? this.id,
      food_code: food_code ?? this.food_code,
      food_name: food_name ?? this.food_name,
      food_quantity: food_quantity ?? this.food_quantity,
      food_serving_size: food_serving_size ?? this.food_serving_size,
      energy_kcal_100g: energy_kcal_100g ?? this.energy_kcal_100g,
      carbohydrates_100g: carbohydrates_100g ?? this.carbohydrates_100g,
      proteins_100g: proteins_100g ?? this.proteins_100g,
      fat_100g: fat_100g ?? this.fat_100g,
      sodium_100g: sodium_100g ?? this.sodium_100g,
      calcium_100g: calcium_100g ?? this.calcium_100g,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'food_code': food_code,
      'food_name': food_name,
      'food_quantity': food_quantity,
      'food_serving_size': food_serving_size,
      'energy_kcal_100g': energy_kcal_100g,
      'carbohydrates_100g': carbohydrates_100g,
      'proteins_100g': proteins_100g,
      'fat_100g': fat_100g,
      'sodium_100g': sodium_100g,
      'calcium_100g': calcium_100g,
    };
  }

  factory Barcode_products.fromMap(Map<String, dynamic> map) {
    return Barcode_products(
      id: map['id'].toInt() as int,
      food_code: map['food_code'] as String,
      food_name: map['food_name'] as String,
      food_quantity: map['food_quantity'].toInt() as int,
      food_serving_size: map['food_serving_size'].toInt() as int,
      energy_kcal_100g: map['energy_kcal_100g'].toInt() as int,
      carbohydrates_100g: map['carbohydrates_100g'].toDouble() as double,
      proteins_100g: map['proteins_100g'].toInt() as int,
      fat_100g: map['fat_100g'].toInt() as int,
      sodium_100g: map['sodium_100g'].toInt() as int,
      calcium_100g: map['calcium_100g'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Barcode_products.fromJson(String source) =>
      Barcode_products.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Barcode_products(id: $id, food_code: $food_code, food_name: $food_name, food_quantity: $food_quantity, food_serving_size: $food_serving_size, energy_kcal_100g: $energy_kcal_100g, carbohydrates_100g: $carbohydrates_100g, proteins_100g: $proteins_100g, fat_100g: $fat_100g, sodium_100g: $sodium_100g, calcium_100g: $calcium_100g)';
  }

  @override
  bool operator ==(covariant Barcode_products other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.food_code == food_code &&
        other.food_name == food_name &&
        other.food_quantity == food_quantity &&
        other.food_serving_size == food_serving_size &&
        other.energy_kcal_100g == energy_kcal_100g &&
        other.carbohydrates_100g == carbohydrates_100g &&
        other.proteins_100g == proteins_100g &&
        other.fat_100g == fat_100g &&
        other.sodium_100g == sodium_100g &&
        other.calcium_100g == calcium_100g;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        food_code.hashCode ^
        food_name.hashCode ^
        food_quantity.hashCode ^
        food_serving_size.hashCode ^
        energy_kcal_100g.hashCode ^
        carbohydrates_100g.hashCode ^
        proteins_100g.hashCode ^
        fat_100g.hashCode ^
        sodium_100g.hashCode ^
        calcium_100g.hashCode;
  }
}

