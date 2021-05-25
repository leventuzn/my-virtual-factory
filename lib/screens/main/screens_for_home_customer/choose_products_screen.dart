import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChooseProductsScreen extends StatefulWidget {
  @override
  _ChooseProductsScreenState createState() => _ChooseProductsScreenState();
}

class _ChooseProductsScreenState extends State<ChooseProductsScreen> {
  var count = 5;
  var _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Products Screen'),
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
                  Text('Product Name'),
                ],
              ),
              leading: SizedBox(
                width: 100,
                child: TextField(
                  controller: _amountController,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    hintText: 'Amount/m',
                    labelText: 'Amount/m',
                  ),
                ),
              ),
              subtitle: Text("Product Type"),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
