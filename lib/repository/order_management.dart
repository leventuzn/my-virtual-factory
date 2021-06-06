import 'package:cloud_firestore/cloud_firestore.dart';

class OrderManagement {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference orderItems =
      FirebaseFirestore.instance.collection('orderItems');
  CollectionReference workQueues =
      FirebaseFirestore.instance.collection('workQueues');

  bool isBeforeToday(Timestamp timestamp) {
    return DateTime.now().toUtc().isAfter(DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
            isUtc: false)
        .toUtc());
  }

  void checkExpired() {
    orders.get().then((order) {
      order.docs.forEach((orderDoc) {
        if (isBeforeToday(orderDoc.get('deadline')) &&
            orderDoc.get('status') != 'COMPLETED') {
          orders.doc(orderDoc.id).update({'status': 'EXPIRED'});
          workQueues
              .where('orderId', isEqualTo: orderDoc.id)
              .get()
              .then((workQueue) {
            workQueue.docs.forEach((workDoc) {
              workQueues.doc(workDoc.id).delete();
            });
          });
        }
      });
    });
  }
}
