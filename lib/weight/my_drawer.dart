import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/page/about_page.dart';
import 'package:flutter_app/page/publish_tweet_page.dart';
import 'package:flutter_app/page/settings_page.dart';
import 'package:flutter_app/page/tweet_black_house.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {
  var menuIcon = [Icons.send, Icons.label, Icons.account_box, Icons.settings];
  var headImgPath = "assets/images/cover_img.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: ListView.separated(
          padding: const EdgeInsets.all(0.0), //解决状态栏问题
          itemBuilder: (BuildContext context, int index) {
            if (index > 0) {
              index -= 1;
              return ListTile(
                leading: Icon(menuIcon[index]),
                title: Text(StringConst.DRAWER_MENU[index]),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _navPush(index),
              );
            }
            return Image.asset(
              headImgPath,
              fit: BoxFit.fitWidth,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            if (index != 0) {
              return Divider(
                height: 1.5,
              );
            }
            return Divider(
              height: 0,
            );
          },
          itemCount: menuIcon.length + 1),
    );
  }

  void _navPush(index) {
    Navigator.pop(context);
    var route;
    switch (index) {
      case 0:
        route = PublishTweetPage();
        break;
      case 1:
        route = TweetBlackHousePage();
        break;
      case 2:
        route = AboutPage();
        break;
      case 3:
        route = SettingsPage();
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }
}
