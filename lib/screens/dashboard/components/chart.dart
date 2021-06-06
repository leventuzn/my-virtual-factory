import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart extends StatefulWidget {
  final int numberOfPending,
      numberOfProcessing,
      numberOfCompleted,
      numberOfExpired,
      numberOfOrders;

  const Chart(
      {Key key,
      this.numberOfPending,
      this.numberOfProcessing,
      this.numberOfCompleted,
      this.numberOfExpired,
      this.numberOfOrders})
      : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> paiChartSelectionDatas = [
      PieChartSectionData(
        color: primaryColor,
        value: widget.numberOfProcessing.toDouble(),
        showTitle: false,
        radius: 25,
      ),
      PieChartSectionData(
        color: Color(0xFF26E5FF),
        value: widget.numberOfPending.toDouble(),
        showTitle: false,
        radius: 22,
      ),
      PieChartSectionData(
        color: Color(0xFFFFCF26),
        value: widget.numberOfCompleted.toDouble(),
        showTitle: false,
        radius: 19,
      ),
      PieChartSectionData(
        color: Color(0xFFEE2727),
        value: widget.numberOfExpired.toDouble(),
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
                  "${widget.numberOfOrders}",
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
  }
}
