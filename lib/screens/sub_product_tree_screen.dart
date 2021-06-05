import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/sub_product_tree.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/sub_product_tree_service.dart';

class SubProductTreeScreen extends StatefulWidget {
  @override
  _SubProductTreeScreenState createState() => _SubProductTreeScreenState();
}

class _SubProductTreeScreenState extends State<SubProductTreeScreen> {
  CollectionReference subProductTrees =
      FirebaseFirestore.instance.collection('subproducttrees');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  var _amountController = TextEditingController();
  String _productId;
  String _subProductId;

  // FloatingActionBtton 'a tiklandiginde alert olarak contact form u vermesi icin olusturulan fonksiyon
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
                  SubProductTree subProductTree =
                      new SubProductTree.fromSubProductTrees(
                    subProductTrees.doc().id,
                    _subProductId,
                    _productId,
                    _amountController.text,
                  );
                  SubProductTreeService().add(subProductTree);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add SubProductTree'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: products.orderBy('type').get(),
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
                              value: _productId,
                              items: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                    onTap: () {},
                                    value: document.id,
                                    child: Text(document.get('name')));
                              }).toList(),
                              onChanged: (changedValue) {
                                setState(() {
                                  _productId = changedValue;
                                });
                              });
                        },
                      );
                    },
                  ),
                  FutureBuilder(
                    future: products.where('isSalable', isEqualTo: false).get(),
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
                              value: _subProductId,
                              items: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return DropdownMenuItem(
                                    onTap: () {},
                                    value: document.id,
                                    child: Text(document.get('name')));
                              }).toList(),
                              onChanged: (changedValue) {
                                setState(() {
                                  _subProductId = changedValue;
                                });
                              });
                        },
                      );
                    },
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      labelText: 'Amount',
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
        title: Text('SubProductTrees Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: subProductTrees.orderBy('productId').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        Text("Product id : " + document.get('productId')),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text("SubProduct id : " + document.get('subProductId')),
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Text("Amount : " + document.get('amount')),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        SubProductTreeService().delete(document.get('id'));
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
