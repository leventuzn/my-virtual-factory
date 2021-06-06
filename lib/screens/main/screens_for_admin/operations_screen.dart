import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/operation.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/operation_service.dart';

class OperationsScreen extends StatefulWidget {
  @override
  _OperationsScreenState createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  CollectionReference operations =
      FirebaseFirestore.instance.collection('operations');
  var _operationNameController = TextEditingController();
  var _productTypeController = TextEditingController();

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
                onPressed: () {
                  Operation operation = new Operation();
                  operation.id = operations.doc().id;
                  operation.name = _operationNameController.text;
                  operation.type = _productTypeController.text;
                  OperationService().add(operation);
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add Operation'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _operationNameController,
                    decoration: InputDecoration(
                      hintText: 'Write a Operation Name',
                      labelText: 'Operation Name',
                    ),
                  ),
                  TextField(
                    controller: _productTypeController,
                    decoration: InputDecoration(
                      hintText: 'Write a Product Type',
                      labelText: 'Product Type',
                    ),
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
        title: Text('Operations Screen'),
      ),
      body: StreamBuilder(
          stream: operations.orderBy('name').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return Text('No data');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            }
            return new ListView(
              children:
                  snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    tileColor: Colors.red,
                    title: Row(
                      children: <Widget>[
                        Text('Operation Name: ' + document.get('name')),
                      ],
                    ),
                    trailing: Text('Product Type: ' + document.get('type')),
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
