import 'dart:convert';

class Meal_category {
  final int? id;
  final String? category;
  Meal_category({
    this.id,
    this.category,
  });

  Meal_category copyWith({
    int? id,
    String? category,
  }) {
    return Meal_category(
      id: id ?? this.id,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
    };
  }

  factory Meal_category.fromMap(Map<String, dynamic> map) {
    return Meal_category(
      id: map['id'].toInt() as int,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meal_category.fromJson(String source) => Meal_category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Meal_category(id: $id, category: $category)';

  @override
  bool operator ==(covariant Meal_category other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.category == category;
  }

  @override
  int get hashCode => id.hashCode ^ category.hashCode;
}