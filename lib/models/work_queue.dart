class WorkQueue {
  String id;
  String orderId;
  String productId;
  String operationId;
  String amount;
  bool hasSubProcess;
  String workCenterId = "WAITING";

  WorkQueue();
}
