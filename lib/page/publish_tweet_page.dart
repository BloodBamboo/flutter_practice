import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';

class PublishTweetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PublishTweetPageState();
  }
}

class _PublishTweetPageState extends State<PublishTweetPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringConst.DRAWER_MENU[0])),
      body: Container(
        color: Colors.green,
      ),
    );
  }
}