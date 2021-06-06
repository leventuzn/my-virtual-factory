import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/work_queue.dart';

class WorkQueueService {
  CollectionReference workQueuesRef =
      FirebaseFirestore.instance.collection('workQueues');

  Future<void> add(WorkQueue workQueue) {
    return workQueuesRef
        .doc(workQueue.id)
        .set({
          'id': workQueue.id,
          'orderId': workQueue.orderId,
          'productId': workQueue.productId,
          'operationId': workQueue.operationId,
          'amount': workQueue.amount,
          'hasSubProcess': workQueue.hasSubProcess,
          'workCenterId': workQueue.workCenterId,
        })
        .then((value) => print("WorkQueue added"))
        .catchError((error) => print("Failed to add WorkQueue: $error"));
  }

  Future<void> update(String workQueueId) {
    return workQueuesRef
        .doc(workQueueId)
        .update({
          'hasSubProcess': false,
        })
        .then((value) => print("WorkQueue updated"))
        .catchError((error) => print("Failed to update WorkQueue: $error"));
  }

  Future<void> delete(String id) {
    return workQueuesRef
        .doc(id)
        .delete()
        .then((value) => print("WorkQueue deleted"))
        .catchError((error) => print("Failed to delete workQueue: $error"));
  }
}
