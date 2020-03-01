import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/utils/data_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(StringConst.DRAWER_MENU[3])),
        body: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(20),
            child: RaisedButton(
              child: Text("退出登录"),
              color: AppColor.APP_THEME,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                DataUtil.clearLoginInfo();
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "退出成功");
                eventBus.fire(LogoutEvent());
              },
            ),
        ));
  }
}
