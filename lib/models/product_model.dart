import 'dart:convert';

// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

ProductModel productFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productToJson(ProductModel data) => json.encode(data.toJson());

String productModelToJson(ProductModel data) => json.encode(data.toJson()); // Function to convert ProductModel to JSON

class ProductModel {
  String productName;
  String productType;
  int price;
  String unit;
  String id; // Product ID
  DateTime createdAt; // Date created
  DateTime updatedAt; // Date updated

  ProductModel({
    required this.productName,
    required this.productType,
    required this.price,
    required this.unit,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? '', // Assign default empty string if id is not provided
        createdAt = createdAt ?? DateTime.now(), // Assign current date/time if not provided
        updatedAt = updatedAt ?? DateTime.now(); // Assign current date/time if not provided

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productName: json["product_name"],
        productType: json["product_type"],
        price: json["price"],
        unit: json["unit"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
