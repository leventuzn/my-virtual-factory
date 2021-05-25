import 'package:cloud_firestore/cloud_firestore.dart';

class WorkCenterOperation {
  String id;
  DocumentReference workCenter;
  DocumentReference operation;
  double speed;

  WorkCenterOperation();

  WorkCenterOperation.fromWorkCenterOperations(
    this.id,
    this.workCenter,
    this.operation,
    this.speed,
  );
}
