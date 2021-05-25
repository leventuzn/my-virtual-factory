import 'package:cloud_firestore/cloud_firestore.dart';

class SubProductTree {
  String id;
  DocumentReference product;
  double amount;

  SubProductTree();

  SubProductTree.fromSubProductTrees(
    this.id,
    this.product,
    this.amount,
  );
}
