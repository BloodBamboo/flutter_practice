import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart' show AppUrl, AppInfo;
import 'package:flutter_app/utils/data_util.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _webView = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    _webView.onUrlChanged.listen((url) {
      print(url);
      if (url != null && url.length > 0 && url.contains(AppInfo.REDIRECT_URI)) {
        //登录成功了
        //提取授权码code

        var code = url.split("?")[1].split("&")[0].split("=")[1];
        Map<String, dynamic> params = Map<String, dynamic>();
        params['client_id'] = AppInfo.CLIENT_ID;
        params['client_secret'] = AppInfo.CLIENT_SECRET;
        params['grant_type'] = 'authorization_code';
        params['redirect_uri'] = AppInfo.REDIRECT_URI;
        params['code'] = '$code';
        params['dataType'] = 'json';
        NetUtil.instance.get(AppUrl.OAUTH2_TOKEN, params).then((map) {
          print(map.toString());
          if (map != null) {
            if (map != null && map.isNotEmpty) {
              //保存token等信息
              DataUtil.saveLoginInfo(map);
              //弹出当前路由，并返回refresh通知我的界面刷新数据
              Navigator.pop(context, 'refresh');
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(title: Text("web登录")),
      url: AppUrl.OAUTH2_AUTHORIZE +
          '?response_type=code&client_id=' +
          AppInfo.CLIENT_ID +
          '&redirect_uri=' +
          AppInfo.REDIRECT_URI,
      withJavascript: true,
      //允许执行js
      withLocalStorage: true,
      //允许本地存储
      withZoom: true, //允许网页缩放
    );
  }
}
