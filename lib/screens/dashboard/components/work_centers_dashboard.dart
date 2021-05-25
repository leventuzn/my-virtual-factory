import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class WorkCentersDashboard extends StatefulWidget {
  const WorkCentersDashboard({
    Key key,
  }) : super(key: key);

  @override
  _WorkCentersDashboardState createState() => _WorkCentersDashboardState();
}

class _WorkCentersDashboardState extends State<WorkCentersDashboard> {
  CollectionReference workCenters =
      FirebaseFirestore.instance.collection('workcenters');

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
            "WORK CENTERS",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: StreamBuilder<QuerySnapshot>(
                stream: workCenters.orderBy('name').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('No Work Center');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  return SingleChildScrollView(
                    child: DataTable(
                      horizontalMargin: 0,
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(
                          label: Text("ID"),
                        ),
                        DataColumn(
                          label: Text("Name"),
                        ),
                        DataColumn(
                          label: Text("Activity"),
                        ),
                      ],
                      rows: _createRows(snapshot.data),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

List<DataRow> _createRows(QuerySnapshot snapshot) {
  return snapshot.docs.map((DocumentSnapshot document) {
    Icon _icon = Icon(
      Icons.check_circle_outline,
      color: primaryColor,
    );
    if (document.get('active') == true) {
      _icon = Icon(
        Icons.do_not_disturb_on_total_silence_outlined,
        color: Color(0xFFEE2727),
      );
    }
    return new DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              _icon,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(document.get('id')),
              ),
            ],
          ),
        ),
        DataCell(Text(document.get('name'))),
        DataCell(Text(document.get('active') ? 'BUSY' : 'EMPTY')),
      ],
    );
  }).toList();
}
