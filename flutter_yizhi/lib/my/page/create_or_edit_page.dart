import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_yizhi/home/home_router.dart';
import 'package:flutter_yizhi/home/widget/home_crad.dart';
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

class CreateOrEditPage extends StatefulWidget {
  const CreateOrEditPage({super.key, this.id});

  final String? id;

  @override
  State<CreateOrEditPage> createState() => _CreateOrEditPageState();
}

class _CreateOrEditPageState extends State<CreateOrEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleNodeText = FocusNode();

  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlNodeText = FocusNode();

  final TextEditingController _hiddenContentController =
      TextEditingController();
  final FocusNode _hiddenContentNodeText = FocusNode();

  final TextEditingController _tagsController = TextEditingController();
  // final FocusNode _tagsNodeText = FocusNode();

  List<TagEntity> tags = [];

  SaveDataEntity? dataEntity;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _getInfo();
    }
  }

  void _getInfo() async {
    BaseEntity<SaveDataEntity> res =
        await MyRepository.getMyDataInfo(widget.id!);
    if (res.code == 1000) {
      setState(() {
        dataEntity = res.data!;
      });
      _titleController.text = dataEntity!.title;
      _urlController.text = dataEntity!.url;
      _hiddenContentController.text = dataEntity!.hiddenContent;
      _tagsController.text = dataEntity!.tagList.join(' ');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _titleNodeText.dispose();
    _urlController.dispose();
    _urlNodeText.dispose();
    _hiddenContentController.dispose();
    _hiddenContentNodeText.dispose();
    _tagsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text(
              '创建',
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
                      hintText: '标题',
                      minLines: 5,
                      maxLines: 5,
                      nodeText: _titleNodeText,
                      controller: _titleController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(4)
                    ),
                    child: MyTextField(
                      hintText: '分享链接',
                      nodeText: _urlNodeText,
                      controller: _urlController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(4)
                    ),
                    child: TypeAheadField<TagEntity>(
                      direction: VerticalDirection.down,
                      controller: _tagsController,
                      builder: (context, controller, focusNode) => MyTextField(
                        hintText: '标签,使用空格区分多个',
                        minLines: 1,
                        maxLines: 5,
                        nodeText: focusNode,
                        controller: controller,
                      ),
                      decorationBuilder: (context, child) => Material(
                        color: Colors.white,
                        type: MaterialType.card,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(4),
                        child: child,
                      ),
                      itemBuilder: (context, tag) => ListTile(
                        title: Text(tag.label),
                      ),
                      hideOnSelect: true,
                      hideOnUnfocus: true,
                      hideWithKeyboard: true,
                      retainOnLoading: true,
                      onSelected: onSuggestionSelected,
                      suggestionsCallback: suggestionsCallback,
                      itemSeparatorBuilder: itemSeparatorBuilder,
                      listBuilder: null,
                      emptyBuilder: (context) => const Text('找不到相关标签!'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(4)
                    ),
                    child: MyTextField(
                      hintText: '隐藏内容',
                      minLines: 5,
                      maxLines: 5,
                      nodeText: _hiddenContentNodeText,
                      controller: _hiddenContentController,
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
                if (_titleController.text.isEmpty) {
                  Toast.show('标题不能为空');
                  return;
                }
                List<String> tagList = _tagsController.text.split(' ');
                if (tagList.length > 5) {
                  Toast.show('标签最多5个');
                  return;
                }
                if (widget.id != null) {
                  BaseEntity res = await HomeRepository.updateData(
                      SaveDataEntity(
                          id: int.parse(widget.id!),
                          title: _titleController.text,
                          tagList: tagList,
                          url: _urlController.text,
                          hiddenContent: _hiddenContentController.text));
                  if (res.code == 1000) {
                    Toast.show('保存成功');
                    if (mounted) {
                      EventBus.instance.commit(EventKeys.refresh);
                      NavigatorUtils.goBack(context);
                    }
                  } else {
                    Toast.show(res.message);
                  }
                } else {
                  BaseEntity res = await HomeRepository.addData(SaveDataEntity(
                      title: _titleController.text,
                      tagList: tagList,
                      url: _urlController.text,
                      hiddenContent: _hiddenContentController.text));
                  if (res.code == 1000) {
                    Toast.show('保存成功');
                    if (mounted) {
                      EventBus.instance.commit(EventKeys.refresh);
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

  void onSuggestionSelected(TagEntity tag) {
    print('tag${tag.toString()}');
    // 判断最后一个字符是不是空格如果是空格则直接添加不是则删除到最后一个空格的位置添加
    String pattern = _tagsController.text;
    if (pattern.isNotEmpty) {
      if (pattern.endsWith(' ')) {
        _tagsController.text = '$pattern${tag.label} ';
      } else {
        int index = pattern.lastIndexOf(' ');
        _tagsController.text =
            '${pattern.substring(0, index + 1)}${tag.label} ';
      }
    } else {
      _tagsController.text = '${tag.label} ';
    }

    // products.value = Map.of(
    //   products.value
    //     ..update(
    //       product,
    //           (value) => value + 1,
    //       ifAbsent: () => 1,
    //     ),
    // );
    // controller.clear();
  }

  Future<List<TagEntity>> suggestionsCallback(String pattern) async {
    List<String> parts = pattern.split(" ");
    final patternLower = parts.last.split(' ').join('');
    print(patternLower);
    BaseEntity<List<TagEntity>> res =
        await MyRepository.getTagList(keyWord: patternLower);
    if (res.code == 1000) {
      List<TagEntity> list = res.data ?? [];
      // list中的label是否有等于patternLower的
      if (patternLower.isNotEmpty) {
        bool isExist = list.any((element) => element.label == patternLower);
        if (!isExist) {
          // 添加到首位
          list.insert(0, TagEntity(label: patternLower, id: 0));
        }
      }
      return list;
    }
    return [];
  }

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const Divider(height: 1, color: Color(0xffFAFAFA));
}
