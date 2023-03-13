import 'dart:convert';

class BarcodeProduct {
  final int? id;
  final String? productName;

  BarcodeProduct({
    this.id,
    this.productName,
  });

  BarcodeProduct copyWith({
    int? id,
    String? productName,
    String? expiryDate,
  }) {
    return BarcodeProduct(
      id: id ?? this.id,
      productName: productName ?? this.productName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_name': productName,
    };
  }

  factory BarcodeProduct.fromMap(Map<String, dynamic> map) {
    return BarcodeProduct(
      id: checkAndReturnInt(map['id']),
      productName: map['product_name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BarcodeProduct.fromJson(String source) =>
      BarcodeProduct.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BarcodeProduct(id: $id, productName: $productName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BarcodeProduct &&
        other.id == id &&
        other.productName == productName;
  }

  @override
  int get hashCode {
    return id.hashCode ^ productName.hashCode;
  }
}

int checkAndReturnInt(dynamic value) {
  if (value is int) return value;
  String str = value;
  return int.parse(str);
}
