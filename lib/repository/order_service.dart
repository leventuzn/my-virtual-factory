import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/order.dart';

class OrderService {
  CollectionReference ordersRef =
      FirebaseFirestore.instance.collection('orders');

  Future<void> add(Order order) {
    return ordersRef
        .doc(order.id)
        .set({
          'id': order.id,
          'name': order.name,
          'customer': order.customer,
          'date': order.date.toString(),
          'deadline': order.deadline.day.toString(),
        })
        .then((value) => print("Order added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  Future<void> update(Order order) {
    return ordersRef
        .doc(order.id)
        .update({
          'name': order.name,
          'customer': order.customer,
          'date': order.date,
          'deadline': order.deadline,
        })
        .then((value) => print("Order updated"))
        .catchError((error) => print("Failed to update order: $error"));
  }

  Future<void> delete(String id) {
    return ordersRef
        .doc(id)
        .delete()
        .then((value) => print("Order deleted"))
        .catchError((error) => print("Failed to delete order: $error"));
  }

  Stream<QuerySnapshot> getOrders() {
    return ordersRef.snapshots();
  }
}
