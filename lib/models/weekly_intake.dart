import 'dart:convert';

class Weekly_summary {
  final double? carb_val;
  final String? carb_level;
  final double? protein_val;
  final String? protein_level;
  final double? sodium_val;
  final String? sodium_level;
  final double? calcium_val;
  final String? calcium_level;
  final String? score;
  final DateTime? sun_date;
  final DateTime? from_date;
  Weekly_summary({
    this.carb_val,
    this.carb_level,
    this.protein_val,
    this.protein_level,
    this.sodium_val,
    this.sodium_level,
    this.calcium_val,
    this.calcium_level,
    this.score,
    this.sun_date,
    this.from_date
  });

  Weekly_summary copyWith({
    double? carb_val,
    String? carb_level,
    double? protein_val,
    String? protein_level,
    double? sodium_val,
    String? sodium_level,
    double? calcium_val,
    String? calcium_level,
    String? score,
    DateTime? sun_date,
    DateTime? from_date,
  }) {
    return Weekly_summary(
      carb_val: carb_val ?? this.carb_val,
      carb_level: carb_level ?? this.carb_level,
      protein_val: protein_val ?? this.protein_val,
      protein_level: protein_level ?? this.protein_level,
      sodium_val: sodium_val ?? this.sodium_val,
      sodium_level: sodium_level ?? this.sodium_level,
      calcium_val: calcium_val ?? this.calcium_val,
      calcium_level: calcium_level ?? this.calcium_level,
      score: score ?? this.score,
      sun_date: sun_date ?? this.sun_date,
      from_date: from_date ?? this.from_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'carb_val': carb_val,
      'carb_level': carb_level,
      'protein_val': protein_val,
      'protein_level': protein_level,
      'sodium_val': sodium_val,
      'sodium_level': sodium_level,
      'calcium_val': calcium_val,
      'calcium_level': calcium_level,
      'score': score,
      'sun_date': sun_date,
      'from_date': from_date,
    };
  }

  factory Weekly_summary.fromMap(Map<String, dynamic> map) {
    return Weekly_summary(
      carb_val: map['carb_val'].toDouble() as double,
      carb_level: map['carb_level'] as String,
      protein_val: map['protein_val'].toDouble() as double,
      protein_level: map['protein_level'] as String,
      sodium_val: map['sodium_val'].toDouble() as double,
      sodium_level: map['sodium_level'] as String,
      calcium_val: map['calcium_val'].toDouble() as double,
      calcium_level: map['calcium_level'] as String,
      score: map['score'] as String,
      sun_date: map['sun_date'] as DateTime,
      from_date: map['from_date'] as DateTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory Weekly_summary.fromJson(String source) =>
      Weekly_summary.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Weekly_summary(carb_val: $carb_val, carb_level: $carb_level, protein_val: $protein_val, protein_level: $protein_level, sodium_val: $sodium_val, sodium_level: $sodium_level, calcium_val: $calcium_val, calcium_level: $calcium_level, score: $score, sun_date: $sun_date)';
  }

  @override
  bool operator ==(covariant Weekly_summary other) {
    if (identical(this, other)) return true;

    return other.carb_val == carb_val &&
        other.carb_level == carb_level &&
        other.protein_val == protein_val &&
        other.protein_level == protein_level &&
        other.sodium_val == sodium_val &&
        other.sodium_level == sodium_level &&
        other.calcium_val == calcium_val &&
        other.calcium_level == calcium_level &&
        other.score == score &&
        other.sun_date == sun_date &&
        other.from_date == from_date;
  }

  @override
  int get hashCode {
    return carb_val.hashCode ^
        carb_level.hashCode ^
        protein_val.hashCode ^
        protein_level.hashCode ^
        sodium_val.hashCode ^
        sodium_level.hashCode ^
        calcium_val.hashCode ^
        calcium_level.hashCode ^
        score.hashCode ^
        sun_date.hashCode^
        from_date.hashCode;
  }
}
