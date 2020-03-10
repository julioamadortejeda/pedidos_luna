import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String id;
  int orderNumber;
  DateTime startDate;
  DateTime endDate;
  num totalCost;
  num  realCost;
  num gains;
  bool active;
  String image;
  Color color;
  String status;
  LinearGradient background;

  OrderModel({
    this.id,
    this.orderNumber,
    this.startDate,
    this.endDate,
    this.totalCost,
    this.realCost,
    this.gains,
    this.active,
    //Wthis.image,
  }) {
    if (this.active) {
      image = 'assets/images/ok.png';
      color = Colors.green;
      status = 'Abierto';

      background = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.green,
          Color.fromRGBO(100, 224, 99, 1.0)
        ],
      );
    } else {
      image = 'assets/images/cancel.png';
      color = Colors.red;
      status = 'Cerrado';

      background = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.red,
          Color.fromRGBO(255, 87, 51, 1.0)
        ],
      );
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      OrderModel(
        id: json["id"],
        orderNumber: json["order_number"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        totalCost: json["total_cost"],
        realCost: json["real_cost"],
        gains: json["gains"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "order_number": orderNumber,
        "start_date": startDate,
        "end_date": endDate,
        "total_cost": totalCost,
        "real_cost": realCost,
        "gains": gains,
        "active": active,
      };

  OrderModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        orderNumber = snapshot['orderNumber'],
        startDate = (snapshot['startDate'] as Timestamp).toDate(),
        endDate = (snapshot['endDate'] as Timestamp).toDate(),
        totalCost = double.parse(snapshot["totalCost"].toString()),
        realCost = double.parse(snapshot["realCost"].toString()),
        gains = double.parse(snapshot["gains"].toString()),
        active = snapshot["active"] {

    if (this.active) {
      image = 'assets/images/ok.png';
      color = Colors.green;
      status = 'Abierto';

      background = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.green.shade600,
          Colors.green
          //Color.fromRGBO(100, 224, 99, 1.0)
        ],
      );
    } else {
      image = 'assets/images/cancel.png';
      color = Colors.red;
      status = 'Cerrado';

      background = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.red,
          Color.fromRGBO(255, 87, 51, 1.0)
        ],
      );
    }
  }

}
