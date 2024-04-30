import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_yizhi/my/model/version_entity.dart';
import 'package:flutter_yizhi/my/my_repository.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/my/widgets/exit_dialog.dart';
import 'package:flutter_yizhi/my/widgets/update_dialog.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/other_utils.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:flutter_yizhi/widget/base_dialog.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:r_upgrade/r_upgrade.dart';

class MySettingPage extends StatefulWidget {
  const MySettingPage({super.key});

  @override
  State<MySettingPage> createState() => _MySettingPageState();
}

class _MySettingPageState extends State<MySettingPage> {
  late PackageInfo packageInfo;

  String version = '';
  VersionEntity? updateVersion;
  late int id;

  @override
  void initState() {
    super.initState();
    _init();
    RUpgrade.stream.listen((DownloadInfo info) {
      ///...
      print(info.toString());
      if (info.status == DownloadStatus.STATUS_SUCCESSFUL) {
        install();
      }
    });
  }

  _init() async {
    packageInfo = await PackageInfo.fromPlatform();
    BaseEntity<VersionEntity> res =
        await MyRepository.checkVersion(packageInfo.version);
    if (res.code == 1000) {
      setState(() {
        updateVersion = res.data;
      });
    }
    setState(() {
      version = packageInfo.version;
    });
  }

  /// 删除缓存
  void clearApplicationCache() async {
    Directory directory = await getApplicationDocumentsDirectory();
    //删除缓存目录
    await deleteDirectory(directory);
    Toast.show('清除缓存成功');
  }

  /// 递归方式删除目录
  Future<Null> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
      }
    }
    await file.delete();
  }

  void incrementUpgrade() async {
    try {
      id = (await RUpgrade.upgrade(
        updateVersion!.url,
        fileName: 'r_upgrade.patch',
        useDownloadManager: false,
        installType: RUpgradeInstallType.none,
        upgradeFlavor: RUpgradeFlavor.incrementUpgrade,
      ))!;
    } catch (e) {
      print(e);
    }
  }

  void install() async {
    try {
      await RUpgrade.install(id);
    } catch (e) {
      Toast.show('增量更新失败!');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            '设置',
            style: TextStyle(color: Color(0xff09090B)),
          ),
          elevation: 2,
          shadowColor: Colors.black26),
      body: Column(
        children: <Widget>[
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  NavigatorUtils.push(context, MyRouter.accountSecurityPage);
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('账号安全'),
                      ],
                    )),
              ),
              const SizedBox(
                width: double.infinity,
                height: 0.6,
              ),
              GestureDetector(
                onTap: () {
                  showElasticDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return BaseDialog(
                          title: '提示',
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 28.0),
                            child:
                                Text("你确定要清除缓存吗？", textAlign: TextAlign.center),
                          ),
                          onPressed: () async {
                            NavigatorUtils.goBack(context);
                            clearApplicationCache();
                          },
                        );
                      });
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('清除缓存'),
                      ],
                    )),
              ),
              const SizedBox(
                width: double.infinity,
                height: 0.6,
              ),
              GestureDetector(
                onTap: () {
                  if (updateVersion != null) {
                    incrementUpgrade();
                  }
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('软件更新'),
                        Row(
                          children: [
                            const Text('当前版本'),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(version),
                            const SizedBox(
                              width: 5,
                            ),
                            updateVersion != null
                                ? Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffFF3B30),
                                        borderRadius: BorderRadius.circular(4)),
                                  )
                                : const SizedBox()
                          ],
                        )
                      ],
                    )),
              ),
              const SizedBox(
                width: double.infinity,
                height: 0.6,
              ),
              GestureDetector(
                onTap: () {
                  NavigatorUtils.push(context, MyRouter.aboutUsPage);
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('关于我们'),
                      ],
                    )),
              ),
              const SizedBox(
                width: double.infinity,
                height: 0.6,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _showExitDialog();
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('退出登录')],
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog<void>(context: context, builder: (_) => const ExitDialog());
  }
}
