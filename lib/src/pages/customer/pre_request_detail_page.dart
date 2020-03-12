import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_luna/src/pages/customer/order_not_available.dart';
import 'package:pedidos_luna/src/pages/customer/user_not_enabled_page.dart';
import 'package:pedidos_luna/src/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

import '../error_page.dart';
import '../loading_page.dart';

class PreRequestDetailPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final CustomerRepository customer = Provider.of<CustomerRepository>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: customer.getCustomerInfo(customer.customerInfo.id),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasError) return ErrorPage();

        if(snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }

        if(snapshot.hasData && snapshot.data.data != null) {
          final DocumentSnapshot document = snapshot.data;
          customer.mapCutomerToModel(snapshot.data);

          if(!document.exists || (document.data['active'] as bool) == false) {
            return UserNotEnabledPage();
          }

          //_customer.mapCutomerToModel(snapshot.data);
          return OrderNotAvailablePage();
        }


        return LoadingWidget();
      }
    );
//    return Consumer<CustomerRepository>(
  }
}
