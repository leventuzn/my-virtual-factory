import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/work_center.dart';

class WorkCenterService {
  CollectionReference workCentersRef =
      FirebaseFirestore.instance.collection('workcenters');

  Future<void> add(WorkCenter workCenter) {
    return workCentersRef
        .doc(workCenter.id)
        .set({
          'id': workCenter.id,
          'name': workCenter.name,
          'active': workCenter.active,
        })
        .then((value) => print("WorkCenter added"))
        .catchError((error) => print("Failed to add workCenter: $error"));
  }

  Future<void> update(WorkCenter workCenter) {
    return workCentersRef
        .doc(workCenter.id)
        .update({
          'active': workCenter.active,
        })
        .then((value) => print("workCenter updated"))
        .catchError((error) => print("Failed to update workCenter: $error"));
  }

  Future<void> delete(String id) {
    return workCentersRef
        .doc(id)
        .delete()
        .then((value) => print("workCenter deleted"))
        .catchError((error) => print("Failed to delete workCenter: $error"));
  }

  Stream<QuerySnapshot> getworkCenters() {
    return workCentersRef.snapshots();
  }
}
