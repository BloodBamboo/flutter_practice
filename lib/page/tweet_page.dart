import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/page/new_message_page.dart';
import 'package:flutter_app/utils/data_util.dart';

class TweetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TweetPageState();
  }
}

class _TweetPageState extends State<TweetPage> {
  List<String> _tabList = ["最新", "热门"];
  bool _isLogin = false;
  NewHotMessagePage _messagePage = NewHotMessagePage(isHot: false,);
  NewHotMessagePage _hotMessagePage = NewHotMessagePage(isHot: true,);

  @override
  void initState() {
    DataUtil.isLogin().then((isLogin) {
      if (mounted) {
        setState(() {
          _isLogin = isLogin;
        });
      }
    });
    eventBus.on<LoginEvent>().listen((event) {
      _isLogin = true;
      if (mounted) {
       setState(() {
       });
      }
    });
    eventBus.on<LogoutEvent>().listen((event) {
      _isLogin = false;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLogin) {
      return Center(
        child: Text("请登录"),
      );
    }

    return DefaultTabController(
      length: _tabList.length,
      child: Column(
        children: <Widget>[
          Container(
            child: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: _tabList.map((title) {
                return Tab(
                  text: title,
                );
              }).toList(),
            ),
            color: AppColor.APP_THEME,
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[_messagePage, _hotMessagePage],
            ),
          )
        ],
      ),
    );
  }
}
