import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedidos_luna/src/order/bloc/bloc.dart';
import 'package:pedidos_luna/src/pages/customer/home_page.dart';
import 'package:pedidos_luna/src/pages/customer/user_not_enabled_page.dart';
import 'package:pedidos_luna/src/pages/error_page.dart';
import 'package:pedidos_luna/src/repositories/order_repository.dart';
import 'package:pedidos_luna/src/pages/loading_page.dart';
import 'package:pedidos_luna/src/repositories/user_repository.dart';
import 'package:provider/provider.dart';

class PreHomePage extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
      // ignore: close_sinks
      final OrderBloc orderBloc = BlocProvider.of<OrderBloc>(context);
      final UserRepository user = Provider.of<UserRepository>(context);
      final OrderRepository orderRepository = orderBloc.getOrderRepository;

      return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: orderRepository.getCustomerInfo(user.firebaseUser.uid),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasError) return ErrorPage();

            if(snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            }

            if(snapshot.hasData && snapshot.data.data != null) {
              final DocumentSnapshot document = snapshot.data;

              if(!document.exists || (document.data['active'] as bool) == false)
                return UserNotEnabledPage();

              orderRepository.mapCutomerToModel(snapshot.data);
              return CustomerHomePage();
            }

            return UserNotEnabledPage();
          }
        ),
      );
  }
}
