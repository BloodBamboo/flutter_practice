import 'package:flutter/material.dart';
import 'package:flutter_app/page/discovery_page.dart';
import 'package:flutter_app/page/new_page.dart';
import 'package:flutter_app/page/profile_page.dart';
import 'package:flutter_app/page/tweet_page.dart';
import 'package:flutter_app/weight/my_drawer.dart';

import 'constants/constants.dart';
import 'model/navigation_icon_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '开源中国',
      theme: ThemeData(
        primarySwatch: AppColor.APP_THEME,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<NavigationIconView> _bottomItems;
  List<Widget> _pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomItems = [
      NavigationIconView(
          StringConst.MENUS[0],
          'assets/images/ic_nav_news_normal.png',
          'assets/images/ic_nav_news_actived.png'),
      NavigationIconView(
          StringConst.MENUS[1],
          'assets/images/ic_nav_tweet_normal.png',
          'assets/images/ic_nav_tweet_actived.png'),
      NavigationIconView(
          StringConst.MENUS[2],
          'assets/images/ic_nav_discover_normal.png',
          'assets/images/ic_nav_discover_actived.png'),
      NavigationIconView(
          StringConst.MENUS[3],
          'assets/images/ic_nav_my_normal.png',
          'assets/images/ic_nav_my_pressed.png'),
    ];

    _pages = [NewPage(), TweetPage(), DiscoveryPage(), ProfilePage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringConst.MENUS[_currentIndex]),
        ),
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _pages[_currentIndex];
          },
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _currentIndex,
          items: _bottomItems.map((bottom) => bottom.item).toList(),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        drawer: Container(
          width: 270,
          child: MyDrawer(),
        ));
  }
}
