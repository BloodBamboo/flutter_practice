import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/data_util.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewsDetailPage extends StatefulWidget {
  final int id;
  final String baseUrl;

  NewsDetailPage({@required this.id, @required this.baseUrl})
      : assert(id != null),
        assert(baseUrl != null);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool isLoading = true;
  FlutterWebviewPlugin _flutterWebviewPlugin = FlutterWebviewPlugin();
  String url;

  @override
  void initState() {
    super.initState();
    //监听url变化
    _flutterWebviewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      }
    });

    DataUtil.getAccessToken().then((token) {
      //token !=null
      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = token;
      params['dataType'] = 'json';
      params['id'] = widget.id;
      NetUtil.instance.get(widget.baseUrl, params).then((map) {
        if (map != null && map.isNotEmpty && map['url'] != null) {
          if (!mounted) return;
          setState(() {
            url = map['url'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _appBarTitle = [
      Text(
        '资讯详情',
      ),
    ];
    if (isLoading) {
      _appBarTitle.add(SizedBox(
        width: 10.0,
      ));
      _appBarTitle.add(CupertinoActivityIndicator());
    }
    //该webview空间在url为空时不能调用否则，即使后面有值也无法加载显示
    Fluttertoast.showToast(msg: "$url");
    return url == null
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(title: Text('资讯详情')),
            body: Center(
              child: CircularProgressIndicator(),
            ))
        : WebviewScaffold(
            url: url,
            appBar: AppBar(
                title: Row(
              children: _appBarTitle,
            )),
            withJavascript: true,
            //允许执行js
            withLocalStorage: true,
            //允许本地存储
            withZoom: true, //允许网页缩放
          );
  }
}
