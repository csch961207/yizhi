import 'package:flutter/material.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/my/model/person_model.dart';
import 'package:flutter_yizhi/my/my_repository.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/event_bus.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:flutter_yizhi/widget/load_image.dart';
import 'package:image_picker/image_picker.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final picker = ImagePicker();
  Person? person;

  @override
  void initState() {
    super.initState();
    _getPerson();
    EventBus.instance.addListener(EventKeys.update, () {
      _getPerson();
    });
  }

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

  @override
  void dispose() {
    EventBus.instance.removeListener(EventKeys.update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            '个人信息',
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
                  _show(context);
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('头像'),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: LoadImage(
                              person != null &&
                                      person!.avatarUrl != null &&
                                      person!.avatarUrl!.isNotEmpty
                                  ? person!.avatarUrl!
                                  : 'default-avatar',
                              height: 35.0,
                              width: 35.0,
                              fit: BoxFit.fill),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                width: double.infinity,
                height: 0.6,
              ),
              GestureDetector(
                onTap: () {
                  NavigatorUtils.push(context, MyRouter.changeNicknamePage);
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('昵称'),
                        Row(
                          children: [
                            Text(person != null ? person!.nickName : ''),
                            Image(
                              image: ImageUtils.getAssetImage('right-arrow'),
                              width: 18.0,
                              height: 18.0,
                              // color: Colours.app_main,
                            )
                          ],
                        )
                      ],
                    )),
              ),
              const SizedBox(
                width: double.infinity,
                height: 0.6,
              ),
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('手机号'),
                      Text(person != null ? person!.phone : ''),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }

  _show(BuildContext parentContext) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,

      /// 使用true则高度不受16分之9的最高限制
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 165.6,
          child: Column(
            children: <Widget>[
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    var file =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (mounted) {
                      OverlayEntry overlayEntry =
                          Toast.showLoading(parentContext);
                      try {
                        BaseEntity<String> res =
                            await HomeRepository.uploadFile(file!.path);
                        if (res.code == 1000) {
                          person?.avatarUrl = res.data;
                          BaseEntity updatePersonRes =
                              await MyRepository.updatePerson(person!);
                          if (updatePersonRes.code == 1000) {
                            _getPerson();
                            Toast.show('更新成功');
                          } else {
                            Toast.show('更新失败');
                          }
                        }
                        overlayEntry.remove();
                      } catch (e, s) {
                        print(e.toString());
                        overlayEntry.remove();
                        Toast.show('更新失败');
                      }
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        height: 55,
                        child: const Text(
                          '从本地选择照片',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ],
                  )),
              Container(
                color: const Color(0xFFf5f5f5),
                height: 0.6,
              ),
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    var file =
                        await picker.pickImage(source: ImageSource.camera);
                    if (mounted) {
                      OverlayEntry overlayEntry =
                          Toast.showLoading(parentContext);
                      try {
                        BaseEntity<String> res =
                            await HomeRepository.uploadFile(file!.path);
                        if (res.code == 1000) {
                          person?.avatarUrl = res.data;
                          BaseEntity updatePersonRes =
                              await MyRepository.updatePerson(person!);
                          if (updatePersonRes.code == 1000) {
                            _getPerson();
                            Toast.show('更新成功');
                          } else {
                            Toast.show('更新失败');
                          }
                        }
                        overlayEntry.remove();
                      } catch (e, s) {
                        print('-----------------');
                        print(e.toString());
                        print('-----------------');
                        overlayEntry.remove();
                        Toast.show('更新失败');
                      }
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        height: 50,
                        child: const Text(
                          '拍照',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ],
                  )),
              Container(
                color: const Color(0xFFf5f5f5),
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        height: 50,
                        child: const Text(
                          '取消',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }
}
