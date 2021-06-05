import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class OrdersDashboard extends StatefulWidget {
  final String status;
  const OrdersDashboard({
    Key key,
    @required this.status,
  }) : super(key: key);

  @override
  _OrdersDashboardState createState() => _OrdersDashboardState();
}

class _OrdersDashboardState extends State<OrdersDashboard> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    String _status = widget.status;

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
            "$_status ORDERS",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
                stream: orders.where('status', isEqualTo: _status).snapshots(),
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
                            label: Text("Order"),
                          ),
                          DataColumn(
                            label: Text("Date"),
                          ),
                          DataColumn(
                            label: Text("Deadline"),
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

List<DataRow> _createRows(QuerySnapshot snapshot) {
  final dateFormat = new DateFormat('yyyy-MM-dd HH:mm');
  return snapshot.docs.map((DocumentSnapshot document) {
    Icon _icon = Icon(Icons.description);
    switch (document.get('status')) {
      case 'PROCESSING':
        _icon = Icon(
          Icons.description,
          color: primaryColor,
        );
        break;
      case 'PENDING':
        _icon = Icon(
          Icons.pending_actions,
          color: Color(0xFF26E5FF),
        );
        break;
      case 'COMPLETED':
        _icon = Icon(
          Icons.task,
          color: Color(0xFFFFCF26),
        );
        break;
      case 'EXPIRED':
        _icon = Icon(
          Icons.error_outline,
          color: Color(0xFFEE2727),
        );
        break;
      default:
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
        DataCell(Text(
            dateFormat.format((document.get('date').toDate())).toString())),
        DataCell(Text(
            dateFormat.format((document.get('deadline').toDate())).toString())),
      ],
    );
  }).toList();
}
