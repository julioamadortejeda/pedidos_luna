import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getCurrentOrder()  {
    final snapshot = _firestore.collection('orders').where('isCurrent', isEqualTo: true).limit(1).snapshots();
    return snapshot;
  }
  
  Stream<DocumentSnapshot> getCustomerRequest() {
    final snapshot = _firestore.collection('users').document('idsuario1').snapshots();
    return snapshot;
  }
}
