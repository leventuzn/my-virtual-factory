import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/product.dart';

class ProductService {
  CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  Future<void> add(Product product) {
    return productsRef
        .doc(product.id)
        .set({
          'id': product.id,
          'name': product.name,
          'type': product.type,
          'isSalable': product.isSalable,
        })
        .then((value) => print("Product added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  Future<void> update(Product product) {
    return productsRef
        .doc(product.id)
        .update({
          'name': product.name,
          'type': product.type,
          'isSalable': product.isSalable,
        })
        .then((value) => print("Product updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }

  Future<void> delete(String id) {
    return productsRef
        .doc(id)
        .delete()
        .then((value) => print("Product deleted"))
        .catchError((error) => print("Failed to delete product: $error"));
  }

  Stream<QuerySnapshot> getProducts() {
    return productsRef.snapshots();
  }
}
