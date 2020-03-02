import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/page/profile_detail_page.dart';
import 'package:flutter_app/utils/data_util.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'my_message_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  var menuIcons = [
    Icons.message,
    Icons.content_paste,
    Icons.print,
    Icons.error,
    Icons.phone_iphone,
    Icons.people,
    Icons.person,
  ];

  String userAvatar;
  String userName = "点击头像登录";
  var _isLogin = false;

  @override
  void initState() {
    //尝试显示用户信息
    _showUerInfo();
    eventBus.on<LoginEvent>().listen((event) {
      _isLogin = false;
      //获取用户信息并显示
      _getUerInfo();
    });
    eventBus.on<LogoutEvent>().listen((event) {
      _isLogin = true;
      _showUerInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
          itemBuilder: (context, index) {
            if (index > 0) {
              index -= 1;
              return ListTile(
                leading: Icon(menuIcons[index]),
                title: Text(StringConst.PROFILE_MENU[index]),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _navPage(index),
              );
            } else {
              return _buildHeader();
            }
          },
          separatorBuilder: (context, index) {
            if (index > 0) {
              return Divider(
                height: 1.2,
              );
            }
            return Divider(height: 0);
          },
          itemCount: menuIcons.length + 1),
    );
  }

  void _login() {
    DataUtil.isLogin().then((islogin) async {
      if (islogin) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileDetailPage()));
      } else {
        final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        print("登录返回结果$result");
        if (result != null && result == 'refresh') {
          //登录成功
          eventBus.fire(LoginEvent());
        }
      }
    });
  }

  Container _buildHeader() {
    return Container(
      height: 150,
      color: AppColor.APP_THEME,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: userAvatar == null
                  ? Image.asset(
                      "assets/images/ic_avatar_default.png",
                      width: 60,
                      height: 60,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xffffffff),
                            width: 2.0,
                          ),
                          image: DecorationImage(
                              image: NetworkImage(userAvatar),
                              fit: BoxFit.cover))),
              onTap: () => _login(),
            ),
            Text(
              userName,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void _showUerInfo() {
    if (mounted) {
      DataUtil.getUserInfo().then((user) {
        setState(() {
          if (user != null) {
            userName = user.name;
            userAvatar = user.avatar;
          } else {
            userAvatar = null;
            userName = "点击头像登录";
          }
        });
      });
    }
  }

  void _getUerInfo() {
    DataUtil.getAccessToken().then((accessToken) {
      if (accessToken == null || accessToken.length == 0) {
        return;
      }
      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = accessToken;
      params['dataType'] = 'json';
      print('accessToken: $accessToken');
      NetUtil.instance.get(AppUrl.OPENAPI_USER, params).then((map) {
        print('data: ${map.toString()}');
        if (mounted) {
          setState(() {
            userAvatar = map['avatar'];
            userName = map['name'];
          });
        }
        DataUtil.saveUserInfo(map);
      });
    });
  }

  _navPage(int index) {
    DataUtil.isLogin().then((isLogin) {
      if (isLogin) {
        switch (index) {
          case 0:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyMessagePage()));
            break;
//      case 1:
//        break;
//      case 2:
//        break;
//      case 3:
//        break;
//      case 4:
//        break;
//      case 5:
//        break;
//      case 6:
//        break;
          default:
            {
              Fluttertoast.showToast(msg: "${StringConst.PROFILE_MENU[index]}");
            }
            break;
        }
      }
    });
  }
}
