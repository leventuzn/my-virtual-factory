import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubProductsScreen extends StatefulWidget {
  @override
  _SubProductsScreenState createState() => _SubProductsScreenState();
}

class _SubProductsScreenState extends State<SubProductsScreen> {
  CollectionReference subproducttrees =
      FirebaseFirestore.instance.collection('subproducttrees');
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Products for this ProductID: $_productId"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: subproducttrees
            .where('productId', isEqualTo: _productId)
            .snapshots(),
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
                onTap: () {},
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    tileColor: Colors.red,
                    title: Row(
                      children: <Widget>[
                        Text(
                            'Sub Product Id : ' + document.get('subProductId')),
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
