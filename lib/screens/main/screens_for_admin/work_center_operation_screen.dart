import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/work_center_operation.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/work_center_operation_service.dart';

class WorkCenterOperationsScreen extends StatefulWidget {
  @override
  _WorkCenterOperationsScreenState createState() =>
      _WorkCenterOperationsScreenState();
}

class _WorkCenterOperationsScreenState
    extends State<WorkCenterOperationsScreen> {
  CollectionReference workCenterOperations =
      FirebaseFirestore.instance.collection('workcenteroperations');
  CollectionReference operations =
      FirebaseFirestore.instance.collection('operations');
  CollectionReference workCenters =
      FirebaseFirestore.instance.collection('workcenters');
  String _workCenterId;
  String _operationId;
  TextEditingController _speedController = TextEditingController();

  // FloatingActionBtton 'a tiklandiginde alert olarak contact form u vermesi icin olusturulan fonksiyon
  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        // ekrana tiklandiginda alerti dismiss etmek icin true veriyoruz ozellige
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  WorkCenterOperation workCenterOperation =
                      new WorkCenterOperation.fromWorkCenterOperations(
                    workCenterOperations.doc().id,
                    _workCenterId,
                    _operationId,
                    _speedController.text,
                  );
                  WorkCenterOperationService().add(workCenterOperation);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add WorkCenterOperation'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: workCenters.orderBy('name').get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(" ");
                      }
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButton(
                              isExpanded: true,
                              menuMaxHeight: 300,
                              value: _workCenterId,
                              items: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                    onTap: () {},
                                    value: document.id,
                                    child: Text(document.get('name')));
                              }).toList(),
                              onChanged: (changedValue) {
                                setState(() {
                                  _workCenterId = changedValue;
                                });
                              });
                        },
                      );
                    },
                  ),
                  FutureBuilder(
                    future: operations.orderBy('name').get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(" ");
                      }
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButton(
                              isExpanded: true,
                              menuMaxHeight: 300,
                              value: _operationId,
                              items: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                    onTap: () {},
                                    value: document.id,
                                    child: Text(document.get('name')));
                              }).toList(),
                              onChanged: (changedValue) {
                                setState(() {
                                  _operationId = changedValue;
                                });
                              });
                        },
                      );
                    },
                  ),
                  TextField(
                    controller: _speedController,
                    decoration: InputDecoration(
                      hintText: 'Speed',
                      labelText: 'Speed',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Center Operations Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: workCenterOperations.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return Text('No data');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    tileColor: Colors.red,
                    leading: Text(document.get('speed') + ' m/dk'),
                    title: Row(
                      children: <Widget>[
                        Text(document.get('id')),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text("Work Center : " + document.get('workCenterId')),
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Text("Operation : " + document.get('operationId')),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        WorkCenterOperationService().delete(document.get('id'));
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showFormDialog(context);
        },
      ),
    );
  }
}
