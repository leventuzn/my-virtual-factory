import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  String _customerEmail;
  String _customerId;
  final dateFormat = new DateFormat('yyyy-MM-dd HH:mm');

  Future getCustomerId() async {
    await customers
        .where('name', isEqualTo: _customerEmail)
        .get()
        .then((value) => _customerId = value.docs.first.id);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      _customerEmail = auth.currentUser.email;
    }
    getCustomerId();
    print(_customerId);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders.where('customerId', isEqualTo: _customerId).snapshots(),
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
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: ListTile(
                  tileColor: Colors.red,
                  title: Row(
                    children: <Widget>[
                      Text('Order: ' + document.get('id')),
                    ],
                  ),
                  subtitle: Text('Order date: ' +
                      dateFormat
                          .format((document.get('date').toDate()))
                          .toString()),
                  trailing: Text('Status: ' + document.get('status')),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
