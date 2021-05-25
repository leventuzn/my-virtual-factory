import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/work_center.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/work_center_service.dart';

class WorkCentersScreen extends StatefulWidget {
  @override
  _WorkCentersScreenState createState() => _WorkCentersScreenState();
}

class _WorkCentersScreenState extends State<WorkCentersScreen> {
  CollectionReference workCenters =
      FirebaseFirestore.instance.collection('workcenters');

  var _workCenterNameController = TextEditingController();

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
                  WorkCenter workCenter = new WorkCenter.fromWorkCenters(
                    workCenters.doc().id,
                    _workCenterNameController.text,
                    false,
                  );
                  WorkCenterService().add(workCenter);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add Work Center'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _workCenterNameController,
                    decoration: InputDecoration(
                      hintText: 'Write a Work Center Name',
                      labelText: 'Work Center Name',
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
        title: Text('Work Centers Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: workCenters.orderBy('name').snapshots(),
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
                    title: Row(
                      children: <Widget>[
                        Text(document.get('name')),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        WorkCenterService().delete(document.get('id'));
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
