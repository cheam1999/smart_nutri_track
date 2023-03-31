import 'dart:convert';

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? created_at;
  final String? updated_at;
  final String? accessToken;
  final String? tokenType;
  final bool isLogin;
  User({
    this.id,
    this.name,
    this.email,
    this.created_at,
    this.updated_at,
    this.accessToken,
    this.tokenType,
    this.isLogin = false,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? created_at,
    String? updated_at,
    String? accessToken,
    String? tokenType,
    bool? isLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      isLogin: isLogin ?? this.isLogin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'created_at': created_at,
      'updated_at': updated_at,
      'accessToken': accessToken,
      'tokenType': tokenType,
      'isLogin': isLogin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      email: map['email'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      accessToken: map['accessToken'] as String,
      tokenType: map['tokenType'] as String,
      isLogin: map['isLogin'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, created_at: $created_at, updated_at: $updated_at, accessToken: $accessToken, tokenType: $tokenType, isLogin: $isLogin)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.accessToken == accessToken &&
        other.tokenType == tokenType &&
        other.isLogin == isLogin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        accessToken.hashCode ^
        tokenType.hashCode ^
        isLogin.hashCode;
  }
}
