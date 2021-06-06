import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/order_item.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/work_queue.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/order_item_service.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/work_queue_service.dart';

class ChooseProductsScreen extends StatefulWidget {
  @override
  _ChooseProductsScreenState createState() => _ChooseProductsScreenState();
}

class _ChooseProductsScreenState extends State<ChooseProductsScreen> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference orderItems =
      FirebaseFirestore.instance.collection('orderItems');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference workQueues =
      FirebaseFirestore.instance.collection('workQueues');
  CollectionReference subProductTrees =
      FirebaseFirestore.instance.collection('subproducttrees');
  var _amountController = TextEditingController();
  String _subProductId;
  double _subProductAmount;
  String _amount;
  String _type;

  Future setAmount(productId, subProductId) async {
    await products
        .where('productId', isEqualTo: productId)
        .where('subProductId', isEqualTo: subProductId)
        .get()
        .then((value) {
      _amount = value.docs.first.get('amount');
    });
  }

  Future getSubProducts(String productId) async {
    await subProductTrees
        .where('productId', isEqualTo: productId)
        .get()
        .then((value) {
      _subProductId = value.docs.first.get('subProductId');
      _subProductAmount = double.parse(value.docs.first.get('amount'));
    });
  }

  _showFormDialog(BuildContext context, String orderId, String productId) {
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
                  OrderItem orderItem = new OrderItem();
                  orderItem.id = orderItems.doc().id;
                  orderItem.orderId = orderId;
                  orderItem.amount = _amountController.text;
                  orderItem.productId = productId;
                  OrderItemService().add(orderItem);

                  await getSubProducts(productId);

                  WorkQueue workQueue = new WorkQueue();
                  workQueue.id = workQueues.doc().id;
                  workQueue.orderId = orderId;
                  workQueue.productId = productId;
                  workQueue.operationType = 'Dikim';
                  workQueue.amount =
                      (double.parse(orderItem.amount) * _subProductAmount)
                          .toString();
                  workQueue.hasSubProcess = true;
                  WorkQueueService().add(workQueue);

                  workQueue.id = workQueues.doc().id;
                  workQueue.productId = _subProductId;
                  workQueue.operationType = 'Kesim';
                  workQueue.hasSubProcess = false;
                  WorkQueueService().add(workQueue);

                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Amount'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: 'Write an Amount',
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
    final orderId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Products Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: products.where('isSalable', isEqualTo: true).snapshots(),
          builder: (context, snapshot) {
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
                        Text("Type : " + document.get('type')),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showFormDialog(context, orderId, document.id);
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
