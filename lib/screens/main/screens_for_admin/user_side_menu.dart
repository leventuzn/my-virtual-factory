import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserSideMenu extends StatefulWidget {
  const UserSideMenu({
    Key key,
  }) : super(key: key);
  @override
  _UserSideMenuState createState() => _UserSideMenuState();
}

class _UserSideMenuState extends State<UserSideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo.png"),
            ),
            DrawerListTile(
              title: "Customers",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                Navigator.pushNamed(context, '/customers_screen');
              },
            ),
            DrawerListTile(
              title: "Users",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                Navigator.pushNamed(context, '/users_screen');
              },
            ),
            DrawerListTile(
              title: "Orders",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {
                Navigator.pushNamed(context, '/orders_screen');
              },
            ),
            DrawerListTile(
              title: "Products",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {
                Navigator.pushNamed(context, '/products_screen');
              },
            ),
            DrawerListTile(
              title: "Sub Product Tree",
              svgSrc: "assets/icons/menu_store.svg",
              press: () {
                Navigator.pushNamed(context, '/sub_product_tree_screen');
              },
            ),
            DrawerListTile(
              title: "Operations",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {
                Navigator.pushNamed(context, '/operations_screen');
              },
            ),
            DrawerListTile(
              title: "Work Centers",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {
                Navigator.pushNamed(context, '/work_centers_screen');
              },
            ),
            DrawerListTile(
              title: "Work Center Operation",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                Navigator.pushNamed(context, '/work_center_operation_screen');
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
