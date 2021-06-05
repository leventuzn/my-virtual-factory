class OrderItem {
  String id;
  String orderId;
  String productId;
  String amount;

  OrderItem();

  OrderItem.fromOrderItems(
    this.id,
    this.orderId,
    this.productId,
    this.amount,
  );
}
