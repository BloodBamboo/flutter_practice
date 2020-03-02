import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/event_bus.dart';
import 'package:flutter_app/constants/constants.dart' show AppUrl;
import 'package:flutter_app/utils/data_util.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'news_detail_page.dart';

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage>{
  bool _isLogin = false;
  int _curPage = 1;
  static List newsList;

//  ScrollController _controller = ScrollController();

  @override
  void initState() {
    DataUtil.isLogin().then((isLogin) {
      if (!mounted) return;
      setState(() {
        this._isLogin = isLogin;
      });
    });
//    _controller.addListener(() {
//      var maxScroll = _controller.position.maxScrollExtent;
//      var pixels = _controller.position.pixels;
//      Fluttertoast.showToast(msg: "$maxScroll=======$pixels");
//      if (pixels == maxScroll) {
//        _curPage++;
//        _getNewsList(true);
//      }
//    });
    eventBus.on<LoginEvent>().listen((event) {
      Fluttertoast.showToast(msg: "获取用户信息");
      _curPage = 1;
      _isLogin = true;
      if (mounted) {
        _getNewsList(false);
      }
    });
    eventBus.on<LogoutEvent>().listen((event) {
      Fluttertoast.showToast(msg: "退出登录");
      _isLogin = false;
      _curPage = 1;
      if (mounted) {
        setState(() {
          newsList = null;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLogin) {
      return _buildList();
    } else {
      return Center(
        child: Text("请登录"),
      );
    }
  }

  _buildList() {
    if (newsList == null) {
      _getNewsList(false);
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
        onRefresh: _pullToRefresh,
        child: ListView.separated(
//            controller: _controller,
            itemBuilder: (context, index) {
              if (index == newsList.length) {
                _curPage++;
                _getNewsList(true);
                return Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                    margin: EdgeInsets.all(3),
                  ),
                );
              } else {
                return _newListItem(index);
              }
//            if (index==_newsList.length) {
//              return Text("end");
//            }
//            return Text("---------------$index-----${_newsList[index]['commentCount']}");
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
              );
            },
            itemCount: newsList.length + 1));
  }

  Future<Null> _pullToRefresh() async {
    _curPage = 1;
    _getNewsList(false);
    return null;
  }

  void _getNewsList(bool isLoadMore) {
    DataUtil.isLogin().then((isLogin) {
      if (isLogin) {
        print("_getNewsList");
        DataUtil.getAccessToken().then((accessToken) {
          if (accessToken != null && accessToken.isNotEmpty) {
            Map<String, dynamic> params = Map<String, dynamic>();
            params['access_token'] = accessToken;
            params['catalog'] = 1;
            params['page'] = _curPage;
            params['pageSize'] = 10;
            params['dataType'] = 'json';
            NetUtil.instance.get(AppUrl.NEWS_LIST, params).then((map) {
              if (map != null && map.isNotEmpty && mounted) {
                setState(() {
                  if (isLoadMore) {
                    newsList.addAll(map['newslist']);
                  } else {
                    if (newsList != null) newsList.clear();
                    newsList = map['newslist'];
                    print(newsList);
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  _newListItem(int index) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsDetailPage(id: newsList[index]['id'], baseUrl: AppUrl.NEWS_DETAIL,))),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                '${newsList[index]['title']}',
                style: TextStyle(
                    fontSize: 18.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '@${newsList[index]['author']} ${newsList[index]['pubDate'].toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "${newsList[index]['commentCount']}",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.message,
                      color: Colors.grey,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
