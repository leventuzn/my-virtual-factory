import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/work_center_operation.dart';

class WorkCenterOperationService {
  CollectionReference workCenterOperationsRef =
      FirebaseFirestore.instance.collection('workcenteroperations');

  Future<void> add(WorkCenterOperation workCenterOperation) {
    return workCenterOperationsRef
        .doc(workCenterOperation.id)
        .set({
          'id': workCenterOperation.id,
          'workCenter': workCenterOperation.workCenter,
          'operation': workCenterOperation.operation,
          'speed': workCenterOperation.speed,
        })
        .then((value) => print("WorkCenterOperation added"))
        .catchError(
            (error) => print("Failed to add workCenterOperation: $error"));
  }

  Future<void> update(WorkCenterOperation workCenterOperation) {
    return workCenterOperationsRef
        .doc(workCenterOperation.id)
        .update({
          'workCenter': workCenterOperation.workCenter,
          'operation': workCenterOperation.operation,
          'speed': workCenterOperation.speed,
        })
        .then((value) => print("WorkCenterOperation updated"))
        .catchError(
            (error) => print("Failed to update workCenterOperation: $error"));
  }

  Future<void> delete(String id) {
    return workCenterOperationsRef
        .doc(id)
        .delete()
        .then((value) => print("WorkCenterOperation deleted"))
        .catchError(
            (error) => print("Failed to delete workCenterOperation: $error"));
  }

  Stream<QuerySnapshot> getworkCenterOperations() {
    return workCenterOperationsRef.snapshots();
  }
}
