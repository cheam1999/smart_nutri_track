import 'dart:convert';

class Ur {
  final int? id;
  final int? ur_breakfast;
  final int? ur_lunch;
  final int? ur_snacks;
  final int? ur_dinner;
  final int? users_id;
  final String? ur_date;
  Ur({
     this.id,
     this.ur_breakfast,
     this.ur_lunch,
     this.ur_snacks,
     this.ur_dinner,
     this.users_id,
     this.ur_date,
  });

  Ur copyWith({
    int? id,
    int? ur_breakfast,
    int? ur_lunch,
    int? ur_snacks,
    int? ur_dinner,
    int? users_id,
    String? ur_date,
  }) {
    return Ur(
      id: id ?? this.id,
      ur_breakfast: ur_breakfast ?? this.ur_breakfast,
      ur_lunch: ur_lunch ?? this.ur_lunch,
      ur_snacks: ur_snacks ?? this.ur_snacks,
      ur_dinner: ur_dinner ?? this.ur_dinner,
      users_id: users_id ?? this.users_id,
      ur_date: ur_date ?? this.ur_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ur_breakfast': ur_breakfast,
      'ur_lunch': ur_lunch,
      'ur_snacks': ur_snacks,
      'ur_dinner': ur_dinner,
      'users_id': users_id,
      'ur_date': ur_date,
    };
  }

  factory Ur.fromMap(Map<String, dynamic> map) {
    return Ur(
      id: map['id'].toInt() as int,
      ur_breakfast: map['ur_breakfast'].toInt() as int,
      ur_lunch: map['ur_lunch'].toInt() as int,
      ur_snacks: map['ur_snacks'].toInt() as int,
      ur_dinner: map['ur_dinner'].toInt() as int,
      users_id: map['users_id'].toInt() as int,
      ur_date: map['ur_date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ur.fromJson(String source) => Ur.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ur(id: $id, ur_breakfast: $ur_breakfast, ur_lunch: $ur_lunch, ur_snacks: $ur_snacks, ur_dinner: $ur_dinner, users_id: $users_id, ur_date: $ur_date)';
  }

  @override
  bool operator ==(covariant Ur other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.ur_breakfast == ur_breakfast &&
      other.ur_lunch == ur_lunch &&
      other.ur_snacks == ur_snacks &&
      other.ur_dinner == ur_dinner &&
      other.users_id == users_id &&
      other.ur_date == ur_date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      ur_breakfast.hashCode ^
      ur_lunch.hashCode ^
      ur_snacks.hashCode ^
      ur_dinner.hashCode ^
      users_id.hashCode ^
      ur_date.hashCode;
  }
}