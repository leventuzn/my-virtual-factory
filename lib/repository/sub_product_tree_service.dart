import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/sub_product_tree.dart';

class SubProductTreeService {
  CollectionReference subProductTreesRef =
      FirebaseFirestore.instance.collection('subproducttrees');

  Future<void> add(SubProductTree subProductTree) {
    return subProductTreesRef
        .doc(subProductTree.id)
        .set({
          'id': subProductTree.id,
          'product': subProductTree.product,
          'amount': subProductTree.amount,
        })
        .then((value) => print("SubProductTree added"))
        .catchError((error) => print("Failed to add SubProductTree: $error"));
  }

  Future<void> update(SubProductTree subProductTree) {
    return subProductTreesRef
        .doc(subProductTree.id)
        .update({
          'product': subProductTree.product,
          'amount': subProductTree.amount,
        })
        .then((value) => print("SubProductTree updated"))
        .catchError(
            (error) => print("Failed to update SubProductTree: $error"));
  }

  Future<void> delete(String id) {
    return subProductTreesRef
        .doc(id)
        .delete()
        .then((value) => print("SubProductTree deleted"))
        .catchError(
            (error) => print("Failed to delete subProductTree: $error"));
  }

  Stream<QuerySnapshot> getSubProductTrees() {
    return subProductTreesRef.snapshots();
  }
}
