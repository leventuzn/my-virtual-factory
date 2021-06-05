class SubProductTree {
  String id;
  String subProductId;
  String productId;
  String amount;

  SubProductTree();

  SubProductTree.fromSubProductTrees(
    this.id,
    this.subProductId,
    this.productId,
    this.amount,
  );
}
