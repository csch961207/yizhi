import 'package:flutter/material.dart';
import 'package:flutter_yizhi/home/model/data_entity.dart';
import 'package:flutter_yizhi/my/model/cloud_device.dart';
import 'package:flutter_yizhi/my/my_repository.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/event_bus.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:flutter_yizhi/widget/my_text_field.dart';
import 'package:provider/provider.dart';

class CloudOnDevicePage extends StatefulWidget {
  const CloudOnDevicePage({super.key});

  @override
  State<CloudOnDevicePage> createState() => _CloudOnDevicePageState();
}

class _CloudOnDevicePageState extends State<CloudOnDevicePage> {
  final TextEditingController _ssidController = TextEditingController();
  final FocusNode _ssidNodeText = FocusNode();
  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _pwdNodeText = FocusNode();

  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleNodeText = FocusNode();

  SaveCloudDeviceEntity? cloudDeviceEntity;

  @override
  void initState() {
    super.initState();
  }

  void _init() async {
    BaseEntity<SaveCloudDeviceEntity> res = await MyRepository.myCloudDevice();
    if (res.code == 1000) {
      setState(() {
        cloudDeviceEntity = res.data!;
      });
      _titleController.text = cloudDeviceEntity!.title;
    }
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _ssidNodeText.dispose();
    _pwdController.dispose();
    _pwdNodeText.dispose();
    _titleController.dispose();
    _titleNodeText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            '设备公开', // 蓝牙配网
            style: TextStyle(color: Color(0xff09090B)),
          ),
          elevation: 2,
          shadowColor: Colors.black26),
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                //   padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     // borderRadius: BorderRadius.circular(4)
                //   ),
                //   child: MyTextField(
                //     hintText: '请输入wifi名称',
                //     nodeText: _ssidNodeText,
                //     controller: _ssidController,
                //   ),
                // ),
                // Container(
                //   margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                //   padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     // borderRadius: BorderRadius.circular(4)
                //   ),
                //   child: MyTextField(
                //     hintText: '请输入wifi密码',
                //     nodeText: _pwdNodeText,
                //     controller: _pwdController,
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(4)
                  ),
                  child: MyTextField(
                    hintText: '你要说些什么',
                    nodeText: _titleNodeText,
                    controller: _titleController,
                  ),
                ),
              ],
            )),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
            child: GestureDetector(
              onTap: () async {
                // Provider.of<YizhiViewModel>(context, listen: false)
                //     .setWifi(_ssidController.text, _pwdController.text);
                if (cloudDeviceEntity?.id != null) {
                  BaseEntity res =
                      await MyRepository.addCloudDevice(SaveCloudDeviceEntity(
                    id: cloudDeviceEntity!.id!,
                    title: _titleController.text.isEmpty
                        ? '欢迎各位打印留言——月下共清谈，风前话当年。'
                        : _titleController.text,
                  ));
                  if (res.code == 1000) {
                    Toast.show('保存成功');
                    if (mounted) {
                      EventBus.instance
                          .commit(EventKeys.mutualPrintingSpaceRefresh);
                      NavigatorUtils.goBack(context);
                    }
                  } else {
                    Toast.show(res.message);
                  }
                } else {
                  BaseEntity res =
                      await MyRepository.addCloudDevice(SaveCloudDeviceEntity(
                    title: _titleController.text,
                    deviceName:
                        Provider.of<YizhiViewModel>(context, listen: false)
                            .deviceName,
                  ));
                  if (res.code == 1000) {
                    Toast.show('保存成功');
                    if (mounted) {
                      EventBus.instance
                          .commit(EventKeys.mutualPrintingSpaceRefresh);
                      NavigatorUtils.goBack(context);
                    }
                  } else {
                    Toast.show(res.message);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colours.app_main,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: const Text(
                  '公开到互印空间', // 联网并公开到互印空间
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                    fontFamily: "KaiTi",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
