import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/utils/data_util.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyMessagePage extends StatefulWidget {
  @override
  _MyMessagePageState createState() => _MyMessagePageState();
}

class _MyMessagePageState
    extends State<MyMessagePage> //with SingleTickerProviderStateMixin
{
  List<String> _tabTitles = ['@我', '评论', '私信'];
  int curPage = 1;
  List _messageList;

//  TabController _controller ;

  @override
  void initState() {
//    _controller = TabController(vsync: this, length: _tabTitles.length);
//    _controller
//        .addListener(() => Fluttertoast.showToast(msg: "${_controller.index}"));
    super.initState();
  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabTitles.length,
        child: Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        title: Text("消息中心"),
        bottom: TabBar(
//            controller: _controller,
            onTap: (index) => Fluttertoast.showToast(msg: "$index"),
          tabs: _tabTitles
              .map((title) => Tab(
                    text: title,
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
//          controller: _controller,
//          physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Center(
            child: Text("暂无内容"),
          ),
          Center(
            child: Text("暂无内容"),
          ),
          _buildMessageList(),
        ],
      ),
    ));
  }

//  Future<Null> _pullToRefresh() async {
////    curPage = 1;
//    _getMessageList();
//    return null;
//  }

  _buildMessageList() {
    if (_messageList == null) {
      _getMessageList();
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Image.network(_messageList[index]["portrait"]),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _messageList[index]["sendername"],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _messageList[index]["pubDate"],
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
                          child: Text(
                            _messageList[index]['content'],
//                      overflow: TextOverflow.ellipsis,
//                      maxLines: 1,
                            style: TextStyle(fontSize: 12),
                          ))
                    ],
                  ))
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
          itemCount: _messageList.length),
      onRefresh: _getMessageList,
    );
  }

  Future _getMessageList() {
    return DataUtil.isLogin().then((isLogin) {
      if (isLogin) {
        DataUtil.getAccessToken().then((accessToken) {
          //拼装请求
          Map<String, dynamic> params = Map<String, dynamic>();
          params['dataType'] = 'json';
          params['page'] = curPage;
          params['pageSize'] = 10;
          params['access_token'] = accessToken;
          NetUtil.instance.get(AppUrl.MESSAGE_LIST, params).then((map) {
            setState(() {
              _messageList = map["messageList"];
            });
          });
        });
      }
    });
  }
}
