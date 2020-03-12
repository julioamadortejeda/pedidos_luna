import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_luna/src/models/request.dart';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  String id;
  bool active;
  String phone;
  CustomerRequest request;

  Customer({
    this.id,
    this.active,
    this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        active: json["active"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "active": active,
        "phone": phone,
      };

  Customer.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        phone = snapshot['phoneNumber'],
        active = snapshot['active'],
        request = CustomerRequest();


  fillOrderInfo(DocumentSnapshot doc){
    request = CustomerRequest.fromSnapshot(doc);
  }
}
