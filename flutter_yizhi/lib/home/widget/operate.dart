import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/home/widget/report.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/event_bus.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../widget/load_image.dart';

class Operate extends StatefulWidget {
  const Operate(this.id, this.title, this.url, this.userId, this.callback,
      this.isLiked, this.isFollow, this.isWatching,
      {Key? key})
      : super(key: key);

  final int id;
  final String title;
  final String url;
  final int userId;
  final bool isLiked;
  final bool isWatching;
  final bool isFollow;
  final Function callback;

  @override
  OperateState createState() {
    return OperateState();
  }
}

class OperateState extends State<Operate> {
  int reportType = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 365,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4), topRight: Radius.circular(4)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              BaseEntity res = await HomeRepository.like(widget.id);
              if (res.code == 1000) {
                if (mounted) {
                  NavigatorUtils.goBack(context);
                }
                if (res.data) {
                  Toast.show('收藏成功');
                } else {
                  Toast.show('取消收藏成功');
                }
                EventBus.instance.commit(EventKeys.infoRefresh);
              } else {
                Toast.show(res.message);
              }
            },
            child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.isLiked ? '取消收藏' : '添加收藏'),
                  ],
                )),
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () async {
              BaseEntity res = await HomeRepository.watching(widget.id);
              if (res.code == 1000) {
                if (mounted) {
                  NavigatorUtils.goBack(context);
                }
                if (res.data) {
                  Toast.show('加入成功，从时刻驻足中可以查看');
                } else {
                  Toast.show('取消常看成功');
                }
                EventBus.instance.commit(EventKeys.infoRefresh);
              } else {
                Toast.show(res.message);
              }
            },
            child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.isWatching ? '取消常看' : '加入常看'),
                  ],
                )),
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () async {
              BaseEntity res = await HomeRepository.follow(widget.userId);
              if (res.code == 1000) {
                if (mounted) {
                  NavigatorUtils.goBack(context);
                }
                if (res.data) {
                  Toast.show('关注成功');
                } else {
                  Toast.show('取消关注成功');
                }
                EventBus.instance.commit(EventKeys.infoRefresh);
              } else {
                Toast.show(res.message);
              }
            },
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.isFollow ? '取消关注' : '关注作者'),
                  ],
                )),
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () async {
              NavigatorUtils.goBack(context);
              OverlayEntry overlayEntry = Toast.showLoading(context);
              try {
                String error =
                    await Provider.of<YizhiViewModel>(context, listen: false)
                        .printText(widget.id);
                overlayEntry.remove();
                if (error.isEmpty) {
                  Toast.show('探知完成');
                } else if (error == '请检查连接设备' || error == '蓝牙设备未连接') {
                  Toast.show(error);
                  widget.callback();
                } else {
                  Toast.show(error);
                }
              } catch (e) {
                overlayEntry.remove();
                Toast.show('请检查连接设备');
                widget.callback();
              }
            },
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('探知内容'),
                  ],
                )),
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              try {
                Clipboard.setData(
                    ClipboardData(text: '【${widget.title}】${widget.url}'));
                NavigatorUtils.goBack(context);
                Toast.show('复制成功');
              } catch (e) {
                Toast.show(e.toString());
              }
            },
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('复制内容'),
                  ],
                )),
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            onTap: () {
              NavigatorUtils.goBack(context);
              _showReportModalBottomSheet(context);
            },
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('举报内容'),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  // 举报
  void _showReportModalBottomSheet(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => Report(widget.id));
  }
}
