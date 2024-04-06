import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_yizhi/my/model/my_count_model.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:flutter_yizhi/widget/load_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';

import '../../net/base_entity.dart';
import '../../res/constant.dart';
import '../model/person_model.dart';
import '../my_repository.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Person? person;
  MyCount? myCount;

  StreamSubscription<BluetoothAdapterState>? _stateSubscription;

  void _getPerson() async {
    BaseEntity<Person> res = await MyRepository.getPerson();
    if (res.code == 1000) {
      setState(() {
        person = res.data!;
      });
    } else {
      Toast.show(res.message);
    }
  }

  void _getMyCount() async {
    BaseEntity<MyCount> res = await MyRepository.getMyCount();
    if (res.code == 1000) {
      setState(() {
        myCount = res.data!;
      });
    } else {
      Toast.show(res.message);
    }
  }

  void _init() async {
    _getPerson();
    _getMyCount();
  }

  @override
  void initState() {
    super.initState();
  }

  // 重新显示时
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init();
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: LoadImage(
                              person != null &&
                                      person!.avatarUrl != null &&
                                      person!.avatarUrl!.isNotEmpty
                                  ? person!.avatarUrl!
                                  : 'default-avatar',
                              height: 60.0,
                              width: 60.0,
                              fit: BoxFit.fill),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            person != null ? person!.nickName : '',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          NavigatorUtils.push(context, MyRouter.mySettingPage);
                        },
                        child: Image(
                          image: ImageUtils.getAssetImage('my-setting'),
                          width: 24.0,
                          height: 24.0,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.push(context, MyRouter.followPage);
                      },
                      child: Column(
                        children: [
                          Text(
                            myCount != null ? '${myCount!.followCount}' : '0',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text('关注')
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 0.6,
                      height: 18.0,
                      child: VerticalDivider(),
                    ),
                    GestureDetector(
                        onTap: () {
                          NavigatorUtils.push(context, MyRouter.fansPage);
                        },
                        child: Column(
                          children: [
                            Text(
                              myCount != null ? '${myCount!.fansCount}' : '0',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text('粉丝')
                          ],
                        )),
                    const SizedBox(
                      width: 0.6,
                      height: 18.0,
                      child: VerticalDivider(),
                    ),
                    GestureDetector(
                        onTap: () {
                          NavigatorUtils.push(context, MyRouter.favoritePage);
                        },
                        child: Column(
                          children: [
                            Text(
                              myCount != null
                                  ? '${myCount!.favoriteCount}'
                                  : '0',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text('收藏')
                          ],
                        ))
                  ],
                )
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (await FlutterBluePlus.isSupported == false) {
                      Toast.show('不支持蓝牙');
                      return;
                    }
                    _stateSubscription = FlutterBluePlus.adapterState
                        .listen((BluetoothAdapterState state) {
                      if (state == BluetoothAdapterState.on) {
                        NavigatorUtils.push(context, MyRouter.myDevicePage);
                      } else {
                        Toast.show('请打开蓝牙');
                      }
                    });
                    if (Platform.isAndroid) {
                      await FlutterBluePlus.turnOn();
                    }
                  },
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('我的设备'),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.push(context, MyRouter.myCreatePagee);
                  },
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('我的创建'),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 1,
                ),
                GestureDetector(
                    onTap: () {
                      NavigatorUtils.push(context, MyRouter.historyPage);
                    },
                    child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('历史记录'),
                          ],
                        ))),
                const SizedBox(
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.goWebViewPage(context, '帮助和反馈',
                        'https://support.qq.com/embed/phone/640656?openid=${person?.id}&nickname=${person?.nickName}&avatar=${person?.avatarUrl}');
                  },
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('帮助和反馈'),
                        ],
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
