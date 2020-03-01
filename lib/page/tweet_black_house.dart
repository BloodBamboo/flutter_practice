import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';

class TweetBlackHousePage extends StatefulWidget {
  @override
  _TweetBlackHousePageState createState() => _TweetBlackHousePageState();
}

class _TweetBlackHousePageState extends State<TweetBlackHousePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringConst.DRAWER_MENU[1])),
      body: Container(
        color: Colors.cyan,
      ),
    );
  }
}
