import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedidos_luna/src/auth/bloc.dart';

class LogOutButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _showDialog(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Text('Salir'),
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Cerrar Sesion"),
          content: new Text("Estas seguro de que quieres salir?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoggedOut(),
                );
                Navigator.of(context).pop();
              },
              child: Text('Si'),
            )
          ],
        );
      },
    );
  }
}
