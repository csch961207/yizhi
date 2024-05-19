import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_yizhi/my/model/device_entity.dart';
import 'package:flutter_yizhi/my/my_repository.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/widget/my_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CloudDevicePage extends StatefulWidget {
  const CloudDevicePage({
    super.key,
    required this.nickName,
    required this.deviceName,
  });

  final String nickName;
  final String deviceName;

  @override
  State<CloudDevicePage> createState() => _CloudDevicePageState();
}

class _CloudDevicePageState extends State<CloudDevicePage>
    with TickerProviderStateMixin {
  final TextEditingController _printContentController = TextEditingController();
  final FocusNode _printNodeText = FocusNode();

  // 电量
  int _battery = 100;
  // 温度
  int _temperature = 30;
  // 工作状态
  int _workStatus = 0;
  // 纸张警告
  int _paperWarn = 0;

  // 是否加载
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });
    BaseEntity<DeviceEntity> res = await MyRepository.getMyDevice();
    if (res.code == 1000) {
      print('res.data: ${res.data}');
    } else {
      Toast.show(res.message);
      // 返回
      if (mounted) {
        NavigatorUtils.goBack(context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _printContentController.dispose();
    _printNodeText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nickName}的设备'),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitDoubleBounce(
              size: 24,
              color: Colours.app_main,
            ))
          : Column(
              children: [
                Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '$_battery%',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: ''),
                                      ),
                                      const Text('电量')
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 0.6,
                                    height: 18.0,
                                    child: VerticalDivider(),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '$_temperature°C',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: ''),
                                      ),
                                      const Text('温度')
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 0.6,
                                    height: 18.0,
                                    child: VerticalDivider(),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        _paperWarn == 0 ? '正常' : '缺纸',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text('纸张')
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              color: Colors.white,
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                    Colours.app_main, BlendMode.modulate),
                                child: Lottie.asset(
                                  'assets/lottie/volume_indicator.json',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _workStatus == 2
                                        ? Icons.error
                                        : Icons.check_circle,
                                    color: _workStatus == 2
                                        ? Colors.red
                                        : Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      '工作状态: ${_workStatus == 2 ? '工作中' : '空闲'}'),
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                    )),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffEAEAEA),
                          offset: Offset(0.0, -1),
                          blurRadius: 8.0,
                          spreadRadius: 0.0),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: MyTextField(
                          hintText: '欢迎各位打印留言——月下共清谈，风前话当年。',
                          minLines: 5,
                          maxLines: 5,
                          nodeText: _printNodeText,
                          controller: _printContentController,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        color: Color(0xffe4e4e7),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
                        child: GestureDetector(
                          onTap: () async {
                            if (_printContentController.text.isEmpty) {
                              Toast.show('内容不能为空');
                              return;
                            }
                            OverlayEntry overlayEntry =
                                Toast.showLoading(context);
                            try {
                              await Provider.of<YizhiViewModel>(context,
                                      listen: false)
                                  .mutualPrinting(_printContentController.text,
                                      widget.deviceName);
                              overlayEntry.remove();
                              Toast.show('下发完成');
                            } catch (e) {
                              overlayEntry.remove();
                              print(e);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colours.app_main,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: const Text(
                              '留行',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                decoration: TextDecoration.none,
                                fontFamily: "KaiTi",
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
