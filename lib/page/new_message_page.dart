import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/utils/data_util.dart';
import 'package:flutter_app/utils/net_utils.dart';
import 'package:flutter_app/weight/tweet_list_item.dart';

class NewHotMessagePage extends StatefulWidget {
  //防止重复获取
  List message;

  bool _isHot = false;

  NewHotMessagePage({key, @required isHot})
      : assert(isHot != null),
        this._isHot = isHot,
        super(key: key);

  @override
  _NewHotMessagePageState createState() => _NewHotMessagePageState();
}

class _NewHotMessagePageState extends State<NewHotMessagePage> {
  int _curPage = 1;
  bool _isEnd = false;

  @override
  void initState() {
    super.initState();
    getMessage(false);
  }

  void getMessage(bool isLoadMore) {
    DataUtil.getAccessToken().then((accessToken) {
      if (accessToken == null || accessToken.length == 0) {
        return;
      }
      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = accessToken;
      params['user'] = widget._isHot ? 1 : 0;
      params['page'] = _curPage;
      params['pageSize'] = 10;
      params['dataType'] = 'json';
      NetUtil.instance.get(AppUrl.TWEET_LIST, params).then((map) {
        if (map != null && map.isNotEmpty) {
          // ignore: invalid_use_of_protected_member
          setState(() {
            _isEnd = false;
            if (isLoadMore) {
              widget.message.addAll(map['tweetlist']);
            } else {
              if (widget.message != null) widget.message.clear();
              widget.message = map['tweetlist'];
            }
          });
        } else {
          setState(() {
            _isEnd = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == widget.message.length) {
              if (_isEnd) {
                return Center(
                  child: Text("已经到底了"),
                );
              } else {
                _curPage++;
                getMessage(true);
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            return TweetListItem(tweetData: widget.message[index]);
          },
          separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
          itemCount: widget.message.length + 1),
    );
  }

  Future<Null> _pullToRefresh() async {
    _curPage = 1;
    getMessage(false);
    return null;
  }
}
