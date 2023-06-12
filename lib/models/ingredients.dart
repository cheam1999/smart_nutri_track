import 'dart:convert';

class Ingredients {
  final String? ingredients_name;
  final String? amount;
  final String? measure_name;
  Ingredients({
    this.ingredients_name,
    this.amount,
    this.measure_name,
  });

  Ingredients copyWith({
    String? ingredients_name,
    String? amount,
    String? measure_name,
  }) {
    return Ingredients(
      ingredients_name: ingredients_name ?? this.ingredients_name,
      amount: amount ?? this.amount,
      measure_name: measure_name ?? this.measure_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredients_name': ingredients_name,
      'amount': amount,
      'measure_name': measure_name,
    };
  }

  factory Ingredients.fromMap(Map<String, dynamic> map) {
    return Ingredients(
      ingredients_name: map['ingredients_name'] as String,
      amount: map['amount'].toInt() as String,
      measure_name: map['measure_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredients.fromJson(String source) => Ingredients.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Ingredients(ingredients_name: $ingredients_name, amount: $amount, measure_name: $measure_name)';

  @override
  bool operator ==(covariant Ingredients other) {
    if (identical(this, other)) return true;
  
    return 
      other.ingredients_name == ingredients_name &&
      other.amount == amount &&
      other.measure_name == measure_name;
  }

  @override
  int get hashCode => ingredients_name.hashCode ^ amount.hashCode ^ measure_name.hashCode;
}