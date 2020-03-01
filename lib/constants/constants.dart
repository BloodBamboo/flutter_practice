import 'package:flutter/material.dart';

abstract class StringConst {
  static const List<String> MENUS = ["咨询","动弹","发现","我的"];
  static const DRAWER_MENU = ["发布动弹", "动弹小黑屋", "关于", "设置"];
  static const PROFILE_MENU = ["我的消息",
    "阅读记录",
    "我的博客",
    "我的问答",
    "我的活动",
    "我的团队",
    "邀请好友"];
}

abstract class AppColor {
  //应用主题色
  static const APP_THEME = Colors.green;
//  static const APPBAR = 0xffffffff;
}

abstract class AppInfo {
  static const String CLIENT_ID = '6i4Yu6IUqXnR64em0rsJ'; //应用id
  static const String CLIENT_SECRET = 'Pb9t3prZqBYDeB9DjTvmCzGLu7EFJyt9'; //应用密钥
  static const String REDIRECT_URI = 'https://www.dongnaoedu.com/'; //回调地址
}

abstract class AppUrl {
  static const String HOST = 'https://www.oschina.net';

  //授权登录 ctrl shift u
  static const String OAUTH2_AUTHORIZE = HOST + '/action/oauth2/authorize';
  //获取token
  static const String OAUTH2_TOKEN = HOST + '/action/openapi/token';
  //获取用户信息
  static const String OPENAPI_USER = HOST + '/action/openapi/user';

  static const String MY_INFORMATION = HOST + '/action/openapi/my_information';
  static const String MESSAGE_LIST = HOST + '/action/openapi/message_list';
  static const String NEWS_LIST = HOST + '/action/openapi/news_list';
  static const String NEWS_DETAIL = HOST + '/action/openapi/news_detail';
  static const String TWEET_LIST = HOST + '/action/openapi/tweet_list';
  static const String TWEET_PUB = HOST + '/action/openapi/tweet_pub';
}