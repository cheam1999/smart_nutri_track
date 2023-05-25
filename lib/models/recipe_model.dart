import 'dart:convert';

class Recipe {
  final int? recipe_id;
  final String? recipe_name;
  final String? recipe_image;
  final String? recipe_ingredients;
  final String? recipe_instructions;
  final String? recipe_source;
  final int? recipe_meal;
  Recipe({
     this.recipe_id,
     this.recipe_name,
     this.recipe_image,
     this.recipe_ingredients,
     this.recipe_instructions,
     this.recipe_source,
     this.recipe_meal,
  });

  Recipe copyWith({
    int? recipe_id,
    String? recipe_name,
    String? recipe_image,
    String? recipe_ingredients,
    String? recipe_instructions,
    String? recipe_source,
    int? recipe_meal,
  }) {
    return Recipe(
      recipe_id: recipe_id ?? this.recipe_id,
      recipe_name: recipe_name ?? this.recipe_name,
      recipe_image: recipe_image ?? this.recipe_image,
      recipe_ingredients: recipe_ingredients ?? this.recipe_ingredients,
      recipe_instructions: recipe_instructions ?? this.recipe_instructions,
      recipe_source: recipe_source ?? this.recipe_source,
      recipe_meal: recipe_meal ?? this.recipe_meal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recipe_id': recipe_id,
      'recipe_name': recipe_name,
      'recipe_image': recipe_image,
      'recipe_ingredients': recipe_ingredients,
      'recipe_instructions': recipe_instructions,
      'recipe_source': recipe_source,
      'recipe_meal': recipe_meal,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      recipe_id: map['recipe_id'].toInt() as int,
      recipe_name: map['recipe_name'] as String,
      recipe_image: map['recipe_image'] as String,
      recipe_ingredients: map['recipe_ingredients'] as String,
      recipe_instructions: map['recipe_instructions'] as String,
      recipe_source: map['recipe_source'] as String,
      recipe_meal: map['recipe_meal'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Recipe(recipe_id: $recipe_id, recipe_name: $recipe_name, recipe_image: $recipe_image, recipe_ingredients: $recipe_ingredients, recipe_instructions: $recipe_instructions, recipe_source: $recipe_source, recipe_meal: $recipe_meal)';
  }

  @override
  bool operator ==(covariant Recipe other) {
    if (identical(this, other)) return true;
  
    return 
      other.recipe_id == recipe_id &&
      other.recipe_name == recipe_name &&
      other.recipe_image == recipe_image &&
      other.recipe_ingredients == recipe_ingredients &&
      other.recipe_instructions == recipe_instructions &&
      other.recipe_source == recipe_source &&
      other.recipe_meal == recipe_meal;
  }

  @override
  int get hashCode {
    return recipe_id.hashCode ^
      recipe_name.hashCode ^
      recipe_image.hashCode ^
      recipe_ingredients.hashCode ^
      recipe_instructions.hashCode ^
      recipe_source.hashCode ^
      recipe_meal.hashCode;
  }
}