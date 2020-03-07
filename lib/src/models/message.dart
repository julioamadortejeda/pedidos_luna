import 'package:flutter/material.dart';

class Message {
  final int id;
  final int typeMessage;
  final String title;
  final String subTitle;
  final String message;
  final bool active;
  String imageType;
  Color color;

  Message(
      {this.id,
        this.typeMessage,
        this.title,
        this.subTitle,
        this.message,
        this.active}) {
    switch (typeMessage) {
      case 1:
        imageType = 'assets/images/info.png';
        color = Colors.green;
        break;
      case 2:
        imageType = 'assets/images/warning.png';
        color = Colors.yellow;
        break;
      case 3:
        imageType = 'assets/images/danger.png';
        color = Colors.red;
        break;
      default:
        imageType = 'assets/images/info.png';
        color = Colors.green;
    }
  }
}
