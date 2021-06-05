import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String customerId;
  Timestamp date;
  Timestamp deadline;
  String status = 'PENDING';

  Order();

  Order.fromOrders(
    this.id,
    this.customerId,
    this.date,
    this.deadline,
  );
}
