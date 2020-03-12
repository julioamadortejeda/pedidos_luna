import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_luna/src/models/product.dart';

CustomerRequest productFromJson(String str) => CustomerRequest.fromJson(json.decode(str));

String productToJson(CustomerRequest data) => json.encode(data.toJson());

class CustomerRequest {
  String id;
  String order;
  String status;
  DateTime creationDate;
  double totalAmount;
  bool validated;
  List<Product> items;

  CustomerRequest({
    this.id,
    this.order,
    this.status,
    this.creationDate,
    this.totalAmount,
    this.validated,
    this.items,
  });

  factory CustomerRequest.fromJson(Map<String, dynamic> json) => CustomerRequest(
    id: json["id"],
    order: json["order"],
    status: json["status"],
    creationDate: DateTime.parse(json["creationDate"]),
    totalAmount: json["totalAmount"].toDouble(),
    validated: json["validated"],
    items: List<Product>.from(json["items"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order": order,
    "status": status,
    "creationDate": "${creationDate.year.toString().padLeft(4, '0')}-${creationDate.month.toString().padLeft(2, '0')}-${creationDate.day.toString().padLeft(2, '0')}",
    "totalAmount": totalAmount,
    "validated": validated,
    "items": List<dynamic>.from(items.map((x) => x)),
  };

  CustomerRequest.fromSnapshot(DocumentSnapshot snapshot)
  : id = snapshot.documentID,
  order = snapshot['order'],
  status = snapshot['status'],
  creationDate = (snapshot['creationDate'] as Timestamp).toDate(),
  totalAmount = double.parse(snapshot['totalAmount'].toString()),
  validated = snapshot['validated'],
  items = snapshot['items'] == null ? null : List<Product>.from(snapshot['items'].map((dynamic x) => Product.fromJson(x)));
}
