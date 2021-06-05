class WorkCenterOperation {
  String id;
  String workCenterId;
  String operationId;
  String speed;

  WorkCenterOperation();

  WorkCenterOperation.fromWorkCenterOperations(
    this.id,
    this.workCenterId,
    this.operationId,
    this.speed,
  );
}
