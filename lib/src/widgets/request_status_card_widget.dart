import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_luna/src/pages/customer/pre_request_detail_page.dart';

import 'package:pedidos_luna/src/repositories/customer_repository.dart';
import 'package:provider/provider.dart';

class RequestStatusCard extends StatelessWidget {
  final CustomerRepository customer;

  RequestStatusCard({Key key, this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final orderModel = customer.orderModel;

    return Container(
      padding: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
      ),
      //height: size.height * (size.height < 600 ? 0.65 : 0.60),---------
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: InkWell(
          splashColor: orderModel.color.withAlpha(100),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<CustomerRepository>.value(
                  value: customer,
              child: PreRequestDetailPage(),)
            ));

           // Navigator.push(context, MaterialPageRoute(builder: (context)=>PreRequestDetailPage()));
           // Navigator.pushNamed(context, 'check_customer_request');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: customer.getCustomerRequest(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                String validationText = 'Cargando';
                DocumentSnapshot data;

                if(snapshot.hasError) validationText = 'Error al cargar';

                if(snapshot.hasData) {
                  if(snapshot.data.documents.length == 0){
                      validationText = 'Sin pedido creado';}
                  else {
                    data = snapshot.data.documents[0];

                    customer.fillCustomerInfo(data);
                    validationText =customer.customerInfo.request.status;

                  }
                }

                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          validationText,
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
