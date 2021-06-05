import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/customer.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/customer_service.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  var _customerNameController = TextEditingController();
  var _customerPasswordController = TextEditingController();

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
                  Customer customer = new Customer.fromCustomers(
                    customers.doc().id,
                    _customerNameController.text,
                    _customerPasswordController.text,
                  );
                  CustomerService().add(customer);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Add Customer'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      hintText: 'Write a Customer Name',
                      labelText: 'Customer Name',
                    ),
                  ),
                  TextField(
                    controller: _customerPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Write a Password',
                      labelText: 'Password',
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
        title: Text('Customers Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: customers.snapshots(),
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
                        Text(document.get('name')),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        CustomerService().delete(document.get('id'));
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
