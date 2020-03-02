import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/utils/data_util.dart';
import 'package:flutter_app/utils/net_utils.dart';

class TweetDetailPage extends StatefulWidget {

  final int id;

  TweetDetailPage({key,@required this.id}):assert(id != null),super(key:key);

  @override
  _TweetDetailPageState createState() => _TweetDetailPageState();
}

class _TweetDetailPageState extends State<TweetDetailPage> {

  String _text;

  @override
  void initState() {
    DataUtil.getAccessToken().then((token) {
      //token !=null
      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = token;
      params['dataType'] = 'json';
      params['id'] = widget.id;
      NetUtil.instance.get(AppUrl.TWEET_DETAIL, params).then((map) {
        if (map != null && map.isNotEmpty ) {
          if (!mounted) return;
          setState(() {
            _text = map.toString();
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("详细"),),
      body: Container(

          child:Text("$_text")
      ),
    );
  }
}
