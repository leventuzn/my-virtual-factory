import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class WorkQueuesDashboard extends StatefulWidget {
  const WorkQueuesDashboard({
    Key key,
  }) : super(key: key);

  @override
  _WorkQueuesDashboardState createState() => _WorkQueuesDashboardState();
}

class _WorkQueuesDashboardState extends State<WorkQueuesDashboard> {
  CollectionReference workQueues =
      FirebaseFirestore.instance.collection('workQueues');
  CollectionReference workCenters =
      FirebaseFirestore.instance.collection('workcenters');
  CollectionReference workCenterOperations =
      FirebaseFirestore.instance.collection('workcenteroperations');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference operations =
      FirebaseFirestore.instance.collection('operations');
  String _selectedWorkCenterId;

  _showFormDialog(BuildContext context, DocumentSnapshot documentSnapshot,
      List<dynamic> workCenterIds) {
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
                  await workQueues
                      .doc(documentSnapshot.get('id'))
                      .update({'workCenterId': _selectedWorkCenterId});
                  orders
                      .doc(documentSnapshot.get('orderId'))
                      .update({'status': 'PROCESSING'});
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('WorkCenters'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future:
                        workCenters.where('id', whereIn: workCenterIds).get(),
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
                              value: _selectedWorkCenterId,
                              items: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                    onTap: () {},
                                    value: document.id,
                                    child: Text(document.get('name')));
                              }).toList(),
                              onChanged: (changedValue) {
                                setState(() {
                                  _selectedWorkCenterId = changedValue;
                                });
                              });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<DataRow> _createRows(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot document) {
      Icon _icon = Icon(Icons.settings);

      return new DataRow(
        cells: [
          DataCell(
            InkWell(
              onTap: () async {
                var workCenterIds = [];
                await workCenterOperations
                    .where('operationId',
                        isEqualTo: document.get('operationId'))
                    .get()
                    .then((value) => value.docs.forEach((doc) {
                          workCenterIds.add(doc.get('workCenterId'));
                          _selectedWorkCenterId = null;
                        }));
                _showFormDialog(context, document, workCenterIds);
              },
              child: Row(
                children: [
                  _icon,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(document.get('orderId')),
                  ),
                ],
              ),
            ),
          ),
          DataCell(Text(document.get('operationId'))),
          DataCell(Text(document.get('amount'))),
          DataCell(Text(document.get('workCenterId'))),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WORK QUEUE",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
                stream: workQueues.orderBy('orderId').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('No order');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  return Container(
                    height: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        horizontalMargin: 0,
                        columnSpacing: defaultPadding,
                        columns: [
                          DataColumn(
                            label: Text("OrderId"),
                          ),
                          DataColumn(
                            label: Text("OperationId"),
                          ),
                          DataColumn(
                            label: Text("Amount"),
                          ),
                          DataColumn(
                            label: Text("WorkCenterId"),
                          ),
                        ],
                        rows: _createRows(snapshot.data),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
