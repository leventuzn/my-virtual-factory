import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'order_info_card.dart';

class OrdersSummary extends StatefulWidget {
  const OrdersSummary({
    Key key,
  }) : super(key: key);

  @override
  _OrdersSummaryState createState() => _OrdersSummaryState();
}

class _OrdersSummaryState extends State<OrdersSummary> {
  int numberOfPending = 0,
      numberOfProcessing = 0,
      numberOfCompleted = 0,
      numberOfExpired = 0,
      numberOfOrders = 0;

  @override
  Widget build(BuildContext context) {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: orders.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('No Orders');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading..');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Orders Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: defaultPadding),
                Chart(),
                OrderInfoCard(
                  icon: Icon(
                    Icons.description,
                    color: primaryColor,
                  ),
                  status: "Processing",
                  numOfOrders: numberOfProcessing,
                ),
                OrderInfoCard(
                  icon: Icon(
                    Icons.pending_actions,
                    color: Color(0xFF26E5FF),
                  ),
                  status: "Pending",
                  numOfOrders: numberOfPending,
                ),
                OrderInfoCard(
                  icon: Icon(
                    Icons.task,
                    color: Color(0xFFFFCF26),
                  ),
                  status: "Completed",
                  numOfOrders: numberOfCompleted,
                ),
                OrderInfoCard(
                  icon: Icon(
                    Icons.error_outline,
                    color: Color(0xFFEE2727),
                  ),
                  status: "Expired",
                  numOfOrders: numberOfExpired,
                ),
              ],
            );
          }),
    );
  }
}
