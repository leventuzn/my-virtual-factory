import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  final dateFormat = new DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('orders Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/order_items_screen",
                      arguments: document.get('id'));
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    tileColor: Colors.red,
                    title: Row(
                      children: <Widget>[
                        Text('Order ID: ' + document.get('id')),
                      ],
                    ),
                    subtitle: Text('Order date: ' +
                        dateFormat
                            .format((document.get('date').toDate()))
                            .toString()),
                    trailing: Text('Deadline: ' +
                        dateFormat
                            .format((document.get('deadline').toDate()))
                            .toString()),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
