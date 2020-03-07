import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:pedidos_luna/src/login/login_social_page.dart';
import '../login/bloc/bloc.dart';
import 'package:pedidos_luna/src/repositories/user_repository.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userRepository = Provider.of<UserRepository>(context);

    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginSocialPage(),
      ),
    );
  }
}
