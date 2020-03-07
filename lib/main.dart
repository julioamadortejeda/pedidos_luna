import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedidos_luna/src/order/bloc/bloc.dart';
import 'package:pedidos_luna/src/repositories/order_repository.dart';
import 'package:provider/provider.dart';

import 'package:pedidos_luna/src/pages/customer/home_page.dart';
import 'package:pedidos_luna/src/pages/splash_screen_page.dart';
import 'package:pedidos_luna/src/pages/login_screen.dart';
import 'package:pedidos_luna/src/auth/bloc.dart';
import 'package:pedidos_luna/src/login/login_bloc_delegate.dart';
import 'package:pedidos_luna/src/repositories/user_repository.dart';

import 'src/pages/customer/messages_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = LoginBlocDelegate();
  final UserRepository userRepository = UserRepository();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(BlocProvider(
      create: (BuildContext context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ));
  });
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  const MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _userRepository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pedidos Luna',
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            //return SplashScreenPage();
            if (state is Uninitialized) return SplashScreenPage();

            if (state is Unauthenticated) return LoginScreen();

            if (state is Authenticated) {
              OrderRepository orderRepository = OrderRepository();
              return BlocProvider<OrderBloc>(
                create: (context) => OrderBloc( orderRepository: orderRepository),
                child: HomePage(),
              );
            }
            return Container(
              width: 100.0,
              height: 100.0,
              color: Colors.red,
            );
          },
        ),
        routes: {
          'messages': (BuildContext context) => MessagesPage(),
          //'pedido_detail': (BuildContext context) => PedidoDetail(),
          //'firetest': (BuildContext context) => TestPage()
        },
        theme: ThemeData(
          primarySwatch: Colors.pink,
          fontFamily: 'Dosis',
        ),
      ),
    );
  }
}
