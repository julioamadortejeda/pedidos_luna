import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String name;
  int quantity;
  double price;
  double total;
  String customerComments;
  bool validated;
  String adminComments;

  Product({
    this.name,
    this.quantity,
    this.price,
    this.total,
    this.customerComments,
    this.validated,
    this.adminComments,
  });

  Product.fromSnapshot(DocumentSnapshot snapshot)
  : name = snapshot['order'],
  quantity =snapshot['quantity'],
  price = snapshot['price'],
  total = snapshot['total'],
  customerComments = snapshot['customerComments'],
  validated = snapshot['validated'],
  adminComments = snapshot['adminComments'];

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json["name"],
    quantity: json["quantity"],
    price: json["price"].toDouble(),
    total: json["total"].toDouble(),
    customerComments: json["customerComments"],
    validated: json["validated"],
    adminComments: json["adminComments"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "price": price,
    "total": total,
    "customerComments": customerComments,
    "validated": validated,
    "adminComments": adminComments,
  };
}
