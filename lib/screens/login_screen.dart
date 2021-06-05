import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/customer.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/repository/customer_service.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/responsive.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // sifrenin visibilty'sini kontrol edebilmek icin boolean degisken
  bool hidePassword = true;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential userCredential;
  bool add = true;

  List<String> adminAccounts = [
    'admin@admin.com',
    'admin1@admin.com',
  ];

  @override
  void initState() {
    super.initState();
    add = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: Responsive.isMobile(context) ? double.infinity : 500,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "My Virtual Factory",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        // Email girilecek TextField
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.face,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        // Password'un girilecegi TextField
                        TextField(
                          controller: _passwordController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),
                            // Visibilty kontrolu icin suffixIcon
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    userCredential = await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text)
                                        .then((value) {
                                      adminAccounts
                                              .contains(_emailController.text)
                                          ? Navigator.pushNamed(
                                              context, '/home_admin')
                                          : Navigator.pushNamed(
                                              context, '/home_customer');
                                      return value;
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'No user found for that email.'),
                                        duration: Duration(seconds: 1),
                                      ));
                                      _emailController.text = "";
                                      _passwordController.text = "";
                                    } else if (e.code == 'invalid-email') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Email is invalid.'),
                                        duration: Duration(seconds: 1),
                                      ));
                                      _emailController.text = "";
                                      _passwordController.text = "";
                                    } else if (e.code == 'wrong-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Wrong password provided for that user.'),
                                        duration: Duration(seconds: 1),
                                      ));
                                      _emailController.text = "";
                                      _passwordController.text = "";
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).accentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    userCredential = await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text);

                                    CollectionReference customers =
                                        FirebaseFirestore.instance
                                            .collection('customers');
                                    Customer customer =
                                        new Customer.fromCustomers(
                                            customers.doc().id,
                                            _emailController.text,
                                            _passwordController.text);
                                    CustomerService().add(customer);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('User Created'),
                                      duration: Duration(seconds: 1),
                                    ));
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'The password provided is too weak.'),
                                        duration: Duration(seconds: 1),
                                      ));
                                      _emailController.text = "";
                                      _passwordController.text = "";
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'The account already exists for that email.'),
                                        duration: Duration(seconds: 1),
                                      ));
                                      _emailController.text = "";
                                      _passwordController.text = "";
                                    } else if (e.code == 'invalid-email') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Email is invalid.'),
                                        duration: Duration(seconds: 1),
                                      ));
                                      _emailController.text = "";
                                      _passwordController.text = "";
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).accentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
