import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_luna/src/models/order.dart';
import 'package:pedidos_luna/src/providers/FirestoreProvider.dart';

class OrderRepository {
  OrderModel orderModel;
  final FirestoreProvider _firestoreProvider = FirestoreProvider();

  Stream<QuerySnapshot> getOrder() {
    return _firestoreProvider.getCurrentOrder();
//    orderModel = OrderModel.fromSnapshot(document);
//    return document;
  }

  void mapToUserModel(QuerySnapshot snapshot) {
    orderModel = OrderModel.fromSnapshot(snapshot.documents[0]);
    //print(orderModel.startDate);
  }

  Stream<DocumentSnapshot> getCustomer() {
    return _firestoreProvider.getCustomerRequest();
  }
}