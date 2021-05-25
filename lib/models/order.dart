import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  DocumentReference customer;
  String name;
  DateTime date;
  DateTime deadline;
  String status;

  Order();

  Order.fromOrders(
    this.id,
    this.customer,
    this.name,
    this.date,
    this.deadline,
    this.status,
  );
}
