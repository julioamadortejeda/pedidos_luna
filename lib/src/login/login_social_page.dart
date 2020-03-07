import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:pedidos_luna/src/auth/bloc.dart';
import 'package:pedidos_luna/src/repositories/user_repository.dart';

import 'bloc/bloc.dart';

class LoginSocialPage extends StatefulWidget {
  @override
  _LoginSocialPageState createState() => _LoginSocialPageState();
}

class _LoginSocialPageState extends State<LoginSocialPage> {
  UserRepository _userRepository;
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _userRepository = Provider.of<UserRepository>(context);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        _renderBackground(context),
        _renderLoginForm(context),
      ],
    ));
  }

  Widget _renderBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backPink = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
            Color.fromRGBO(249, 83, 148, 1.0),
            Color.fromRGBO(200, 29, 115, 1.0)
          ])),
    );

    final circle = Container(
        height: size.height * 0.4 * 0.3,
        width: size.height * 0.4 * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Color.fromRGBO(255, 255, 255, 0.08)));

    return Stack(
      children: <Widget>[
        backPink,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, right: -30.0, child: circle),
        Positioned(bottom: -50.0, right: -10.0, child: circle),
        Positioned(bottom: 120.0, right: 20.0, child: circle),
        Positioned(bottom: -50.0, left: -20.0, child: circle),
        Container(
          padding: EdgeInsets.only(top: 100.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.shopping_cart, color: Colors.white, size: 120.0),
              SizedBox(
                height: 20.0,
                width: double.infinity,
              ),
              Text(
                'Pedidos Shein',
                style: TextStyle(
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _renderLoginForm(BuildContext context) {
    //final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(height: size.height * 0.4),
        ),
        Container(
          width: size.width * 0.85,
          padding: EdgeInsets.symmetric(vertical: 50.0),
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 3.0),
                    spreadRadius: 2.0)
              ]),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) => _processLoginResponse(context, state),
            child: BlocBuilder<LoginBloc, LoginState>(
                builder: (BuildContext context, LoginState state) {
              if (state.isSubmitting) {
                return Center(
                    child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 15.0),
                    Text('Iniciando sesion.....')
                  ],
                ));
              } else
                return Column(
                  children: <Widget>[
                    Text(
                      'Continuar con..',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _signInGoogleButton(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _signInFacebookButton(),
                  ],
                );
            }),
          ),
        ),
      ],
    ));
  }

  Widget _signInGoogleButton() {
    return OutlineButton(
      splashColor: Colors.pinkAccent,
      onPressed: () => _loginGoogle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Inicia con Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInFacebookButton() {
    return OutlineButton(
      highlightedBorderColor: Color.fromRGBO(59, 89, 152, 1.0),
      splashColor: Color.fromRGBO(59, 89, 152, 1.0),
      onPressed: () => _loginFacebook(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Image(
                  image: AssetImage("assets/images/facebook_logo.png"),
                  height: 30.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Inicia con Facebook',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _loginGoogle() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _loginBloc.add(LoginWithGooglePressed());
  }

  _loginFacebook() async {
    _loginBloc.add(LoginWithFacebookPressed());
  }

  void _showError(BuildContext context) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_userRepository.ErrorMessage),
            Icon(Icons.error),
          ],
        ),
        backgroundColor: Colors.red,
      ));
  }

  void _processLoginResponse(BuildContext context, LoginState state) {
    if (state.isFailure) {
      _showError(context);
    }

    if (state.isSuccess) {
      FocusScope.of(context).requestFocus(FocusNode());
      BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
    }
  }
}
