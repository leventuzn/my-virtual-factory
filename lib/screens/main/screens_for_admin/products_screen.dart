import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/product.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/product_service.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  var _productNameController = TextEditingController();
  var _productTypeController = TextEditingController();
  bool isSalableCheckBoxValue = false;

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
                  Product product = new Product.fromProducts(
                    products.doc().id,
                    _productNameController.text,
                    _productTypeController.text,
                    isSalableCheckBoxValue,
                  );
                  ProductService().add(product);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add Product'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      hintText: 'Write a Product Name',
                      labelText: 'Product Name',
                    ),
                  ),
                  TextField(
                    controller: _productTypeController,
                    decoration: InputDecoration(
                      hintText: 'Write a Product Type',
                      labelText: 'Product Type',
                    ),
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Row(
                        children: <Widget>[
                          Text('Is Salable?'),
                          Checkbox(
                            value: isSalableCheckBoxValue,
                            onChanged: (value) {
                              setState(() {
                                isSalableCheckBoxValue = value;
                              });
                            },
                          ),
                        ],
                      );
                    },
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
        title: Text('Products Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: products.orderBy('type').snapshots(),
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
                        Text("Product name : " + document.get('name')),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text("Is salable? : " +
                            document.get('isSalable').toString()),
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Text("Type : " + document.get('type')),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        ProductService().delete(document.get('id'));
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
