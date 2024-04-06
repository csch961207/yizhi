import 'package:flutter/material.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';

class Report extends StatefulWidget {
  const Report(this.id, {Key? key}) : super(key: key);

  final int id;

  @override
  ReportState createState() {
    return ReportState();
  }
}

class ReportState extends State<Report> {
  List<String> reportList = [
    '',
    '违反法律法规',
    '发布垃圾广告',
    '辱骂、不友善内容',
    '政治敏感',
    '低俗色情',
    '涉嫌侵权'
  ];
  int reportType = 0;
  final TextEditingController _reasonController = TextEditingController();
  final FocusNode _reasonNodeText = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _reasonController.dispose();
    _reasonNodeText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 475, //365
        width: MediaQuery.of(context).size.width - 60,
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {},
              child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('违反法律法规'),
                      Radio(
                        value: 1,
                        groupValue: reportType,
                        onChanged: (value) {
                          setState(() {
                            reportType = value!;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1,
            ),
            GestureDetector(
              onTap: () async {},
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('发布垃圾广告'),
                      Radio(
                        value: 2,
                        groupValue: reportType,
                        onChanged: (value) {
                          setState(() {
                            reportType = value!;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('辱骂、不友善内容'),
                      Radio(
                        value: 3,
                        groupValue: reportType,
                        onChanged: (value) {
                          setState(() {
                            reportType = value!;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('政治敏感'),
                      Radio(
                        value: 4,
                        groupValue: reportType,
                        onChanged: (value) {
                          setState(() {
                            reportType = value!;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('低俗色情'),
                      Radio(
                        value: 5,
                        groupValue: reportType,
                        onChanged: (value) {
                          print('Radio');
                          print(value);
                          print('Radio');
                          setState(() {
                            reportType = value!;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('涉嫌侵权'),
                      Radio(
                        value: 6,
                        groupValue: reportType,
                        onChanged: (value) {
                          setState(() {
                            reportType = value!;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  style: const TextStyle(
                    height: 1,
                    textBaseline: TextBaseline.alphabetic,
                    fontSize: 16,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Colours.app_main,
                  focusNode: _reasonNodeText,
                  controller: _reasonController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 5,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 15),
                    hintText: '其他原因',
                    counterText: '',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      NavigatorUtils.goBack(context);
                    },
                    child: const Text('取消'),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 0.6,
                      height: 20,
                      child: VerticalDivider(
                        color: Color(0xFFF9F9F9),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (reportType == 0 && _reasonController.text.isEmpty) {
                        Toast.show('请选择举报原因');
                        return;
                      }
                      String description = _reasonController.text.isNotEmpty
                          ? _reasonController.text
                          : reportList[reportType];
                      BaseEntity res =
                          await HomeRepository.report(widget.id, description);
                      if (res.code == 1000) {
                        if (mounted) {
                          NavigatorUtils.goBack(context);
                        }
                        Toast.show('举报成功,感谢反馈');
                      } else {
                        Toast.show(res.message);
                      }
                    },
                    child: const Text('确定'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
