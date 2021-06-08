import 'dart:async';

import 'package:web_programlama_hw3_1306160014_1306160046/repository/order_management.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/work_center_management.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/responsive.dart';
import 'package:flutter/material.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/dashboard/components/work_centers_dashboard.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/dashboard/components/work_queue_dashboard.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'components/orders_dashboard.dart';
import 'components/orders_summary.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      OrderManagement().checkOrders();
      WorkCenterManagement().checkWorkQueue();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: "Dashboard",
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      WorkQueuesDashboard(),
                      SizedBox(height: defaultPadding),
                      WorkCentersDashboard(),
                      SizedBox(height: defaultPadding),
                      OrdersDashboard(status: "PROCESSING"),
                      SizedBox(height: defaultPadding),
                      OrdersDashboard(status: "PENDING"),
                      SizedBox(height: defaultPadding),
                      OrdersDashboard(status: "EXPIRED"),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) OrdersSummary(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: OrdersSummary(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
