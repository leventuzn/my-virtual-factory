import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderItemsScreen extends StatefulWidget {
  @override
  _OrderItemsScreenState createState() => _OrderItemsScreenState();
}

class _OrderItemsScreenState extends State<OrderItemsScreen> {
  CollectionReference orderItems =
      FirebaseFirestore.instance.collection('orderItems');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    final _orderId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("OrderItems for this OrderID: $_orderId"),
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
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/sub_products_screen",
                      arguments: document.get('productId'));
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
                        Text('Product : ' + document.get('productId')),
                      ],
                    ),
                    trailing: Text('Amount: ' + document.get('amount')),
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
