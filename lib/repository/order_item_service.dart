import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/order_item.dart';

class OrderItemService {
  CollectionReference orderItemsRef =
      FirebaseFirestore.instance.collection('orderItems');

  Future<void> add(OrderItem orderItem) {
    return orderItemsRef
        .doc(orderItem.id)
        .set({
          'id': orderItem.id,
          'orderId': orderItem.orderId,
          'productId': orderItem.productId,
          'amount': orderItem.amount,
        })
        .then((value) => print("OrderItem added"))
        .catchError((error) => print("Failed to add OrderItem: $error"));
  }

  Future<void> update(OrderItem orderItem) {
    return orderItemsRef
        .doc(orderItem.id)
        .update({
          'orderId': orderItem.orderId,
          'productId': orderItem.productId,
          'amount': orderItem.amount,
        })
        .then((value) => print("OrderItem updated"))
        .catchError((error) => print("Failed to update OrderItem: $error"));
  }

  Future<void> delete(String id) {
    return orderItemsRef
        .doc(id)
        .delete()
        .then((value) => print("OrderItem deleted"))
        .catchError((error) => print("Failed to delete OrderItem: $error"));
  }

  Stream<QuerySnapshot> getOrderItems() {
    return orderItemsRef.snapshots();
  }
}
