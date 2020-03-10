import 'package:flutter/material.dart';
import 'package:pedidos_luna/src/widgets/logout_widget.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[_renderBackGround(), _renderIcon(context)],
        ));
  }

  Widget _renderBackGround() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.red.shade700, Colors.red],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          //color: Colors.white
        ),
      ),
    );
  }

  Widget _renderIcon(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error, color: Colors.white, size: 150.0),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            'Error en la aplicacion.',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0,),
          Text(
            'La pantalla se actualizara cuando el error haya sido corregido.',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50.0,),
          LogOutButtonWidget(),
        ],
      ),
    );
  }
}
