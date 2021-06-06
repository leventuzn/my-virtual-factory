import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/work_center.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/work_center_service.dart';

class WorkCenterManagement {
  CollectionReference workCenters =
      FirebaseFirestore.instance.collection('workcenters');
  CollectionReference workCenterOperations =
      FirebaseFirestore.instance.collection('workcenteroperations');
  CollectionReference workQueues =
      FirebaseFirestore.instance.collection('workQueues');

  void listenWorkQueue(String workCenterId) {
    workQueues
        .where('workCenterId', isEqualTo: workCenterId)
        .snapshots()
        .map((doc) {
      while (doc.size > 0) {
        workCenters.doc(workCenterId).get().then((value) {
          if (value.get('active') == false) {
            startOperation(workCenterId, doc.docs.first.get('amount'));
            workQueues.doc(doc.docs.first.id).delete();
          }
        });
      }
    });
  }

  void startOperation(String workCenterId, String amount) async {
    WorkCenter workCenter;
    await workCenters.doc(workCenterId).get().then((value) {
      workCenter.id = value.get('id');
      workCenter.name = value.get('name');
      workCenter.active = true;
    });
    WorkCenterService().update(workCenter);
    processing(workCenterId, amount);
  }

  void processing(String workCenterId, String amount) async {
    double _speed;
    await workCenterOperations
        .where('workCenterId', isEqualTo: workCenterId)
        .get()
        .then((value) {
      _speed = double.parse(value.docs.first.get('speed'));
    });
    int _minutes = (double.parse(amount) / _speed).ceil();
    Duration _sleepTime = Duration(minutes: _minutes);
    sleep(_sleepTime);
    endOperation(workCenterId);
  }

  void endOperation(String workCenterId) async {
    WorkCenter workCenter;
    await workCenters.doc(workCenterId).get().then((value) {
      workCenter.id = value.get('id');
      workCenter.name = value.get('name');
      workCenter.active = false;
    });
    WorkCenterService().update(workCenter);
  }
}
