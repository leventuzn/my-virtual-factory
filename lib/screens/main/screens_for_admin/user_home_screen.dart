import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/controllers/MenuController.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/responsive.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_side_menu.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User is signed in!'),
          duration: Duration(seconds: 1),
        ));
      }
    });
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: UserSideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: UserSideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
