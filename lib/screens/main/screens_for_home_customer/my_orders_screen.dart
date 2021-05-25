import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  var count = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders Screen'),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: ListTile(
              tileColor: Colors.red,
              title: Row(
                children: <Widget>[
                  Text('Order Name'),
                ],
              ),
              subtitle: Text('Order Date'),
              trailing: Text('Deadline'),
            ),
          );
        },
      ),
    );
  }
}
