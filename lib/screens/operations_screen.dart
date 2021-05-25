import 'package:flutter/material.dart';

class OperationsScreen extends StatefulWidget {
  @override
  _OperationsScreenState createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operations Screen'),
      ),
    );
  }
}
