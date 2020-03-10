import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_luna/src/models/order.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getCurrentOrder() {
    final snapshot = _firestore.collection('orders').where('isCurrent', isEqualTo: true)
                                                    .limit(1).snapshots();

    return snapshot;
  }



  Stream<QuerySnapshot> getCurrentOrder2() {
    final snapshot = _firestore.collection('orders').where('isCurrent', isEqualTo: true)
        .limit(1).snapshots();


    return snapshot;
  }

  Stream<DocumentSnapshot> getCustomerInfo(String uID) {
    final Stream<DocumentSnapshot> snap = _firestore.collection('users').document(uID).snapshots();

    return snap;
  }

//  Stream<QuerySnapshot> getCustomerInfo(String userID, OrderModel order) {
//    final DocumentReference snap = _firestore.collection('users').document(userID);
//
//
//    final w = snap.collection(order.id).snapshots();
//
//    return w;
//  }


  // pruebas
  Stream<DocumentSnapshot> getCustomerRequest2(String userID, OrderModel order) {
    final DocumentReference snap = _firestore.collection('users').document(userID);
    final e =  snap.snapshots();
    //final w = snap.collection(order.id).snapshots();
  e.listen((onData) {
    final red = onData.reference.collection(order.id);
    red.snapshots().listen((onData) {
      print(onData.documents[0]['status']);
    });
    
    print(onData['prueba']);
    print(onData['JGITpOLFY3VDPH4nxJnu']);
  });
    return e;
  }

  Stream<QuerySnapshot> getCustomerRequest(String userID, OrderModel order) {
    return _firestore.collection('users').document(userID).collection(order.id).limit(1).snapshots();
  }
}
