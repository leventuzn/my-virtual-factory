import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  String id;
  DocumentReference order;
  DocumentReference product;
  int amount;

  OrderItem();

  OrderItem.fromOrderItems(
    this.id,
    this.order,
    this.product,
    this.amount,
  );
}
