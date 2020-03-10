import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_luna/src/models/customer.dart';
import 'package:pedidos_luna/src/models/order.dart';
import 'package:pedidos_luna/src/providers/FirestoreProvider.dart';

class OrderRepository {
  OrderModel orderModel;
  Customer customerInfo;
  final FirestoreProvider _firestoreProvider = FirestoreProvider();

  OrderRepository() {
    print('SE CARGO LA ORDEN');
  }

  Stream<QuerySnapshot> getOrder() {
    print('getOrder');
    return _firestoreProvider.getCurrentOrder();
//    orderModel = OrderModel.fromSnapshot(document);
//    return document;
  }

  void mapToUserModel(QuerySnapshot snapshot) {
    orderModel = OrderModel.fromSnapshot(snapshot.documents[0]);
  }

  Stream<DocumentSnapshot> getCustomerInfo(String uID) {
    Stream<DocumentSnapshot> document =  _firestoreProvider.getCustomerInfo(uID);
    return document;
  }

  void mapCutomerToModel(DocumentSnapshot doc) {
    customerInfo = Customer.fromSnapshot(doc);
  }

  Stream<QuerySnapshot> getCustomerStatusRequest() {
    return _firestoreProvider.getCustomerRequest(customerInfo.id, orderModel);
  }

  void fillCustomerInfo(DocumentSnapshot snap) {
    customerInfo.fillOrderInfo(snap);
  }

}