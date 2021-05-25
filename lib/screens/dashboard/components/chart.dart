import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart extends StatefulWidget {
  const Chart({
    Key key,
  }) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  int numberOfPending = 0,
      numberOfProcessing = 0,
      numberOfCompleted = 0,
      numberOfExpired = 0,
      numberOfOrders = 0;

  Future setNumbers() async {
    numberOfPending =
        await orders.where('status', isEqualTo: 'PENDING').snapshots().length;
    numberOfProcessing = await orders
        .where('status', isEqualTo: 'PROCESSING')
        .snapshots()
        .length;
    numberOfCompleted =
        await orders.where('status', isEqualTo: 'COMPLETED').snapshots().length;
    numberOfExpired =
        await orders.where('status', isEqualTo: 'EXPIRED').snapshots().length;
    numberOfOrders = await orders.snapshots().length;
  }

  @override
  Widget build(BuildContext context) {
    setNumbers();
    return StreamBuilder<QuerySnapshot>(
        stream: orders.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('No Orders');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading..');
          }
          List<PieChartSectionData> paiChartSelectionDatas = [
            PieChartSectionData(
              color: primaryColor,
              value: numberOfProcessing.toDouble(),
              showTitle: false,
              radius: 25,
            ),
            PieChartSectionData(
              color: Color(0xFF26E5FF),
              value: numberOfPending.toDouble(),
              showTitle: false,
              radius: 22,
            ),
            PieChartSectionData(
              color: Color(0xFFFFCF26),
              value: numberOfCompleted.toDouble(),
              showTitle: false,
              radius: 19,
            ),
            PieChartSectionData(
              color: Color(0xFFEE2727),
              value: numberOfExpired.toDouble(),
              showTitle: false,
              radius: 16,
            ),
          ];
          return SizedBox(
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    startDegreeOffset: -90,
                    sections: paiChartSelectionDatas,
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: defaultPadding),
                      Text(
                        "$numberOfOrders",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 0.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
