import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/order.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/order_service.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  Timestamp _deadline;
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference orderItems =
      FirebaseFirestore.instance.collection('orderItems');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('m');
  final String todayIs = formatter.format(now);
  String _orderId;
  String _customerEmail;
  String _customerId;

  _selectedCartDate(BuildContext context) async {
    var _deadlineDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));

    var _deadlineTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    _deadline = Timestamp.fromDate(DateTime(
        _deadlineDate.year,
        _deadlineDate.month,
        _deadlineDate.day,
        _deadlineTime.hour,
        _deadlineTime.minute));
  }

  _showFormDialog(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      _customerEmail = auth.currentUser.email;
    }
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
                  await customers
                      .where('name', isEqualTo: _customerEmail)
                      .get()
                      .then((value) => _customerId = value.docs.first.id);
                  Order order = new Order();
                  order.id = _orderId;
                  order.date = Timestamp.now();
                  order.deadline = _deadline;
                  order.customerId = _customerId;
                  OrderService().add(order);

                  Navigator.popUntil(
                      context, ModalRoute.withName('/home_customer'));
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add Cart'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCartDate(context);
                      });
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _orderId = orders.doc().id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/choose_products_screen',
                  arguments: _orderId);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderItems.where('orderId', isEqualTo: _orderId).snapshots(),
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
                      Text('Product : ' + document.get('productId')),
                    ],
                  ),
                  trailing: Text('Amount: ' + document.get('amount')),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          _showFormDialog(context);
        },
      ),
    );
  }
}
