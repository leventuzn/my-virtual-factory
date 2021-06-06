import 'package:cloud_firestore/cloud_firestore.dart';

class WorkCenterManagement {
  CollectionReference workCenters =
      FirebaseFirestore.instance.collection('workcenters');
  CollectionReference workCenterOperations =
      FirebaseFirestore.instance.collection('workcenteroperations');
  CollectionReference workQueues =
      FirebaseFirestore.instance.collection('workQueues');

  void checkWorkQueue() {
    workCenters.get().then((workCenter) {
      workCenter.docs.forEach((element) {
        workQueues
            .where('workCenterId', isEqualTo: element.id)
            .get()
            .then((workQueue) {
          if (workQueue.size > 0 && element.get('active') != true) {
            startOperation(element.id, workQueue.docs.first.get('amount'));
            workQueues.doc(workQueue.docs.first.id).delete();
          }
        });
      });
    });
  }

  void startOperation(String workCenterId, String amount) async {
    await workCenters.doc(workCenterId).update({'active': true});

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

    await Future.delayed(_sleepTime);

    endOperation(workCenterId);
  }

  void endOperation(String workCenterId) async {
    await workCenters.doc(workCenterId).update({'active': false});
  }
}
