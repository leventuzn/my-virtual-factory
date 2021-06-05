import 'package:web_programlama_hw3_1306160014_1306160046/controllers/MenuController.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/dashboard/components/header.dart';

import 'customer_side_menu.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: CustomerSideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: CustomerSideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Header(
                title: 'Home',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
