import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_yizhi/home/widget/details_content.dart';
import 'package:flutter_yizhi/home/widget/message.dart';
import 'package:flutter_yizhi/home/widget/operate.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/res/resources.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/event_bus.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:vibration/vibration.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../net/base_entity.dart';
import '../home_repository.dart';
import '../model/data_entity.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.id});

  final String id;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isLoading = true;
  DataEntity? dataEntity;
  late Map<String, String> titleAndFavicon = {};

  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;

  WebViewController? controller;

  // https://b23.tv/4JxURxN
  // https://y.music.163.com/m/song?id=482636090&uct2=IEmzXDxVa27gB1XDs9ZEMg%3D%3D&dlt=0846&app_version=8.9.11&sc=wm&tn=
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _getInfo();
    EventBus.instance.addListener(EventKeys.infoRefresh, () {
      HomeRepository.getDataInfo(widget.id).then((res) {
        if (res.code == 1000) {
          setState(() {
            dataEntity = res.data!;
          });
        }
      });
    });
  }

  void _getInfo() async {
    setState(() {
      _isLoading = true;
    });
    try {
      BaseEntity<DataEntity> res = await HomeRepository.getDataInfo(widget.id);
      if (res.code == 1000) {
        dataEntity = res.data!;
        if (res.data!.url.isNotEmpty) {
          controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  if (progress == 100) {
                  } else {}
                },
                onPageStarted: (String url) {
                  print('onPageStarted');
                },
                onPageFinished: (String url) {
                  print('onPageFinished');
                },
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('http') ||
                      request.url.startsWith('https') ||
                      request.url.startsWith('file')) {
                    return NavigationDecision.navigate;
                  } else {
                    print('--------------');
                    print(request.url);
                    print('--------------');
                  }
                  // if (request.url.startsWith('bilibili')) {

                  // }
                  return NavigationDecision.prevent;
                },
              ),
            )
            ..loadRequest(Uri.parse(res.data!.url));
        }
      } else {
        Toast.show(res.message);
        if (mounted) {
          NavigatorUtils.goBack(context);
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('-------d--------');
      print(e);
      print('-------d--------');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 重新显示时
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    super.dispose();
    EventBus.instance.removeListener(EventKeys.refresh);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const SpinKitDoubleBounce(
                size: 24,
                color: Colours.app_main,
              )
            : dataEntity != null && dataEntity!.url.isNotEmpty
                ? WebViewWidget(controller: controller!)
                : Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          dataEntity != null
                              ? dataEntity!.title
                              : '阅尽好花千万树，愿君记取此一枝',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colours.app_main,
                              height: 1.5),
                        ),
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        height: 50,
        elevation: 10,
        shadowColor: Colors.black26,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(opacity: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  NavigatorUtils.goBack(context);
                },
                child: const Icon(CupertinoIcons.multiply_circle),
              ),
              GestureDetector(
                onTap: () async {
                  print('弹窗更多操作');
                  _showOperateModalBottomSheet(context, () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: SystemUiOverlay.values);
                    NavigatorUtils.push(context, MyRouter.myDevicePage);
                  });
                },
                onDoubleTap: () async {
                  BaseEntity res = await HomeRepository.like(dataEntity!.id);
                  if (res.code == 1000) {
                    if (res.data) {
                      Toast.show('收藏成功');
                    } else {
                      Toast.show('取消收藏成功');
                    }
                  } else {
                    Toast.show(res.message);
                  }
                },
                onLongPress: () async {
                  print('长按显示详情');
                  String? urlTitle =
                      controller != null ? await controller?.getTitle() : '';
                  if (mounted) {
                    _showDetailsContentModalBottomSheet(context, urlTitle!);
                  }
                  bool? hasVibrator = await Vibration.hasVibrator();
                  if (hasVibrator != null && hasVibrator) {
                    Vibration.vibrate(duration: 100);
                  }
                },
                onPanStart: (DragStartDetails details) {
                  startVerticalDragDetails = details;
                },
                onPanUpdate: (DragUpdateDetails details) {
                  updateVerticalDragDetails = details;
                },
                onPanEnd: (DragEndDetails details) {
                  double dx = updateVerticalDragDetails.globalPosition.dx -
                      startVerticalDragDetails.globalPosition.dx;

                  bool isSwipeRight = dx > 2; // 右滑动距离大于1
                  bool isSwipeLeft = dx < -2; // 左滑动距离大于1

                  if (isSwipeLeft) {
                    // 执行你的事件
                    print('左滑动超过1');
                    controller?.goBack();
                  }

                  if (isSwipeRight) {
                    // 执行你的事件
                    print('右滑动超过1');
                    controller?.goForward();
                  }
                },
                child: const Icon(Icons.radio_button_checked),
              ),
              GestureDetector(
                onTap: () {
                  _showModalBottomSheet(context);
                },
                child: const Icon(CupertinoIcons.ellipses_bubble),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 详情内容弹窗
  void _showDetailsContentModalBottomSheet(
      BuildContext context, String? urlTitle) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => DetailsContent(dataEntity!.title, dataEntity!.url,
            dataEntity!.avatarUrl, dataEntity!.userName, urlTitle));
  }

  //操作弹窗
  void _showOperateModalBottomSheet(BuildContext context, Function callback) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Operate(
            dataEntity!.id,
            dataEntity!.title,
            dataEntity!.url,
            dataEntity!.userId,
            callback,
            dataEntity!.isLiked!,
            dataEntity!.isFollow!,
            dataEntity!.isWatching!));
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Message(dataEntity!.id));
  }
}
