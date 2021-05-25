import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerSideMenu extends StatefulWidget {
  const CustomerSideMenu({
    Key key,
  }) : super(key: key);
  @override
  _CustomerSideMenuState createState() => _CustomerSideMenuState();
}

class _CustomerSideMenuState extends State<CustomerSideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerListTile(
              title: "My Orders",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                Navigator.pushNamed(context, '/my_orders_screen');
              },
            ),
            DrawerListTile(
              title: "Cart",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                Navigator.pushNamed(context, '/cart_screen');
              },
            ),
            DrawerListTile(
              title: "Choose Products",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                Navigator.pushNamed(context, '/choose_products_screen');
              },
            ),
            DrawerListTile(
              title: "Log Out",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    // For selecting those three line once press "Command+D"
    @required this.title,
    @required this.svgSrc,
    @required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
