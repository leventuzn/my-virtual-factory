import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/operation.dart';

class OperationService {
  CollectionReference operationsRef =
      FirebaseFirestore.instance.collection('operations');

  Future<void> add(Operation operation) {
    return operationsRef
        .doc(operation.id)
        .set({
          'id': operation.id,
          'name': operation.name,
          'type': operation.type,
        })
        .then((value) => print("Operation added"))
        .catchError((error) => print("Failed to add operation: $error"));
  }

  Future<void> update(Operation operation) {
    return operationsRef
        .doc(operation.id)
        .update({
          'name': operation.name,
          'type': operation.type,
        })
        .then((value) => print("Operation updated"))
        .catchError((error) => print("Failed to update operation: $error"));
  }

  Future<void> delete(String id) {
    return operationsRef
        .doc(id)
        .delete()
        .then((value) => print("Operation deleted"))
        .catchError((error) => print("Failed to delete operation: $error"));
  }

  Stream<QuerySnapshot> getoperations() {
    return operationsRef.snapshots();
  }
}
