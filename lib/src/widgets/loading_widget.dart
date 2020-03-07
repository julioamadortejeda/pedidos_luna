import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_renderBackGround(), _renderIcon(context)],
      ),
    );
  }

  Widget _renderBackGround() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.pinkAccent],
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
          Container(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
          ),
          SizedBox(height: 20.0,),
          Text(
            'Cargando....',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,

            ),
          )
        ],
      ),
    );
  }
}
