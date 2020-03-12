import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//custom imports
import 'package:pedidos_luna/src/pages/customer/home_page.dart';
import 'package:pedidos_luna/src/pages/customer/user_not_enabled_page.dart';
import 'package:pedidos_luna/src/pages/error_page.dart';
import 'package:pedidos_luna/src/repositories/customer_repository.dart';
import 'package:pedidos_luna/src/pages/loading_page.dart';
import 'package:pedidos_luna/src/repositories/user_repository.dart';
import 'package:provider/provider.dart';

class PreHomePage extends StatelessWidget {
  final CustomerRepository _customer = CustomerRepository();

    @override
    Widget build(BuildContext context) {
      // ignore: close_sinks
      final UserRepository user = Provider.of<UserRepository>(context);

      return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: _customer.getCustomerInfo(user.firebaseUser.uid),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if(snapshot.hasError) return ErrorPage();

            if(snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            }

            if(snapshot.hasData && snapshot.data.data != null) {
              final DocumentSnapshot document = snapshot.data;
              _customer.mapCutomerToModel(snapshot.data);

              if(!document.exists || (document.data['active'] as bool) == false) {
                return UserNotEnabledPage();
              }

              //_customer.mapCutomerToModel(snapshot.data);
              return CustomerHomePage(customer: _customer,);
            }

            return UserNotEnabledPage();
          }
        ),
      );
  }
}
