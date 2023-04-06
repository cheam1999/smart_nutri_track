import 'dart:convert';

class Food_intakes {
  final int? id;
  final String? meal;
  final int? intake_serving_size;
  final int? users_id;
  final int? food_id;
  final String? intake_date;
  final String? food_name;
  Food_intakes({
    this.id,
    this.meal,
    this.intake_serving_size,
    this.users_id,
    this.food_id,
    this.intake_date,
    this.food_name,
  });

  Food_intakes copyWith({
    int? id,
    String? meal,
    int? intake_serving_size,
    int? users_id,
    int? food_id,
    String? intake_date,
    String? food_name,
  }) {
    return Food_intakes(
      id: id ?? this.id,
      meal: meal ?? this.meal,
      intake_serving_size: intake_serving_size ?? this.intake_serving_size,
      users_id: users_id ?? this.users_id,
      food_id: food_id ?? this.food_id,
      intake_date: intake_date ?? this.intake_date,
      food_name: food_name ?? this.food_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'meal': meal,
      'intake_serving_size': intake_serving_size,
      'users_id': users_id,
      'food_id': food_id,
      'intake_date': intake_date,
      'food_name': food_name,
    };
  }

  factory Food_intakes.fromMap(Map<String, dynamic> map) {
    return Food_intakes(
      id: map['id'].toInt() as int,
      meal: map['meal'] as String,
      intake_serving_size: map['intake_serving_size'].toInt() as int,
      users_id: map['users_id'].toInt() as int,
      food_id: map['food_id'].toInt() as int,
      intake_date: map['intake_date'] as String,
      food_name: map['food_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Food_intakes.fromJson(String source) =>
      Food_intakes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Food_intakes(id: $id, meal: $meal, intake_serving_size: $intake_serving_size, users_id: $users_id, food_id: $food_id, intake_date: $intake_date, food_name: $food_name)';
  }

  @override
  bool operator ==(covariant Food_intakes other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.meal == meal &&
        other.intake_serving_size == intake_serving_size &&
        other.users_id == users_id &&
        other.food_id == food_id &&
        other.intake_date == intake_date &&
        other.food_name == food_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        meal.hashCode ^
        intake_serving_size.hashCode ^
        users_id.hashCode ^
        food_id.hashCode ^
        intake_date.hashCode ^
        food_name.hashCode;
  }
}
