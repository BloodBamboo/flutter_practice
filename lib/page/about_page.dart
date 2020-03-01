import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringConst.DRAWER_MENU[2])),
      body: Container(
        color: Colors.brown,
      ),
    );
  }
}
