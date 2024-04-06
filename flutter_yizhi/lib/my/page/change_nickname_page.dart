import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_yizhi/home/home_router.dart';
import 'package:flutter_yizhi/home/widget/home_crad.dart';
import 'package:flutter_yizhi/my/model/person_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/event_bus.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import '../../home/home_repository.dart';
import '../../home/model/data_entity.dart';
import '../../home/model/tag_entity.dart';
import '../../net/base_entity.dart';
import '../../util/toast_utils.dart';
import '../../widget/my_text_field.dart';
import '../my_repository.dart';

class ChangeNicknamePage extends StatefulWidget {
  const ChangeNicknamePage({super.key});

  @override
  State<ChangeNicknamePage> createState() => _ChangeNicknamePageState();
}

class _ChangeNicknamePageState extends State<ChangeNicknamePage> {
  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _nicknameNodeText = FocusNode();
  Person? person;

  @override
  void initState() {
    super.initState();
    _getPerson();
  }

  void _getPerson() async {
    BaseEntity<Person> res = await MyRepository.getPerson();
    if (res.code == 1000) {
      _nicknameController.text = res.data!.nickName;
      setState(() {
        person = res.data!;
      });
    } else {
      Toast.show(res.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nicknameController.dispose();
    _nicknameNodeText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text(
              '修改昵称',
              style: TextStyle(color: Color(0xff09090B)),
            ),
            elevation: 2,
            shadowColor: Colors.black26),
        body: Column(children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(4)
                    ),
                    child: MyTextField(
                      hintText: '请输入昵称',
                      minLines: 5,
                      maxLines: 5,
                      nodeText: _nicknameNodeText,
                      controller: _nicknameController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
            child: GestureDetector(
              onTap: () async {
                if (_nicknameController.text.isEmpty) {
                  Toast.show('昵称不能为空');
                  return;
                }
                person?.nickName = _nicknameController.text;
                BaseEntity updatePersonRes =
                    await MyRepository.updatePerson(person!);
                if (updatePersonRes.code == 1000) {
                  _getPerson();
                  Toast.show('更新成功');
                  EventBus.instance.commit(EventKeys.update);
                  if (mounted) {
                    NavigatorUtils.goBack(context);
                  }
                } else {
                  Toast.show('更新失败');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colours.app_main,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: const Text(
                  '提交',
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
        ]));
  }
}
