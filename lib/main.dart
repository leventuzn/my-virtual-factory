import 'package:web_programlama_hw3_1306160014_1306160046/constants.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/controllers/MenuController.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/customers_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/login_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/main/screens_for_admin/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/operations_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/orders_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/products_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/sub_product_tree_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/users_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/work_center_operation_screen.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/screens/work_centers_screen.dart';

import 'screens/main/screens_for_home_customer/cart_screen.dart';
import 'screens/main/screens_for_home_customer/choose_products_screen.dart';
import 'screens/main/screens_for_home_customer/customer_home_screen.dart';
import 'screens/main/screens_for_home_customer/my_orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter web_programlama_hw3_1306160014_1306160046 Panel',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/home_admin': (context) => UserHomeScreen(),
          '/home_customer': (context) => CustomerHomeScreen(),
          '/customers_screen': (context) => CustomersScreen(),
          '/users_screen': (context) => UsersScreen(),
          '/orders_screen': (context) => OrdersScreen(),
          '/products_screen': (context) => ProductsScreen(),
          '/sub_product_tree_screen': (context) => SubProductTreeScreen(),
          '/operations_screen': (context) => OperationsScreen(),
          '/work_centers_screen': (context) => WorkCentersScreen(),
          '/work_center_operation_screen': (context) =>
              WorkCenterOperationScreen(),
          '/my_orders_screen': (context) => MyOrdersScreen(),
          '/cart_screen': (context) => CartScreen(),
          '/choose_products_screen': (context) => ChooseProductsScreen(),
        },
      ),
    );
  }
}
