import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/shake_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common_web_page.dart';

class DiscoveryPage extends StatelessWidget {
  List<Map<String, IconData>> blocks = [
    {
      '开源众包': Icons.pageview,
      '开源软件': Icons.speaker_notes_off,
      '码云推荐': Icons.screen_share,
      '代码片段': Icons.assignment,
    },
    {
      '扫一扫': Icons.camera_alt,
      '摇一摇': Icons.camera,
    },
    {
      '码云封面人物': Icons.person,
      '线下活动': Icons.android,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blocks.length,
      itemBuilder: (context, pIndex) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey, width: 1),
                  bottom: BorderSide(color: Colors.grey, width: 1))),
          child: ListView.separated(
              //滑动冲突
              physics: NeverScrollableScrollPhysics(),
              //内容适配
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(blocks[pIndex].values.elementAt(index)),
                  title: Text(blocks[pIndex].keys.elementAt(index)),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _handleItemClick(
                      context, blocks[pIndex].keys.elementAt(index)),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1.0);
              },
              itemCount: blocks[pIndex].length),
        );
      },
    );
  }

  _handleItemClick(BuildContext context, String title) {
    switch (title) {
      case "开源众包":
        _navToWebPage(context, title, 'https://zb.oschina.net/');
        break;
      case "开源软件":
        _navToWebPage(context, title, 'https://www.oschina.net/project');
        break;
      case "码云推荐":
        _navToWebPage(context, title, 'https://gitee.com/explore/recommend');
        break;
      case "代码片段":
        _navToWebPage(context, title, 'https://gitee.com/explore/recommend');
        break;
      case "扫一扫":
        scan();
        break;
      case "摇一摇":
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ShakePage()));
        break;
      case "码云封面人物":
        _navToWebPage(context, title, 'https://m.gitee.com/gitee-stars/');
        break;
      case "线下活动":
        _navToWebPage(context, title, 'https://www.oschina.net/event?tab=latest&city=全国&time=all');
        break;
    }
  }

  void _navToWebPage(BuildContext context, String title, String url) {
    if (title != null && url != null && url.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CommonWebPage(
                title: title,
                url: url,
              )));
    }
  }

  Future scan() async {
    String barcode = await BarcodeScanner.scan();
    Fluttertoast.showToast(msg: barcode);
  }
}
