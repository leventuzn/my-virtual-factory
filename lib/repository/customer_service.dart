import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/customer.dart';

class CustomerService {
  CollectionReference customersRef =
      FirebaseFirestore.instance.collection('customers');

  Future<void> add(Customer customer) {
    return customersRef
        .doc(customer.id)
        .set({
          'id': customer.id,
          'name': customer.name,
          'password': customer.password,
        })
        .then((value) => print("Customer added"))
        .catchError((error) => print("Failed to add customer: $error"));
  }

  Future<void> update(Customer customer) {
    return customersRef
        .doc(customer.id)
        .update({
          'name': customer.name,
          'password': customer.password,
        })
        .then((value) => print("Customer updated"))
        .catchError((error) => print("Failed to update customer: $error"));
  }

  Future<void> delete(String id) {
    return customersRef
        .doc(id)
        .delete()
        .then((value) => print("Customer deleted"))
        .catchError((error) => print("Failed to delete customer: $error"));
  }

  Stream<QuerySnapshot> getCustomers() {
    return customersRef.snapshots();
  }
}
