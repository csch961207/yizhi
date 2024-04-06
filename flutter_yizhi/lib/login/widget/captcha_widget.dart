import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:get/get.dart';

import '../../net/base_entity.dart';
import '../../util/toast_utils.dart';
import '../../widget/load_image.dart';
import '../../widget/my_number_field.dart';
import '../login_repository.dart';
import '../model/captcha_model.dart';

class CaptchaWidget extends StatefulWidget {
  const CaptchaWidget({Key? key, required this.phone, required this.callback}) : super(key: key);

  final String phone;
  final void Function(bool succeed) callback;

  @override
  CaptchaWidgetState createState() {
    return CaptchaWidgetState();
  }
}

class CaptchaWidgetState extends State<CaptchaWidget> {
  final TextEditingController _captchaController = TextEditingController();
  final FocusNode _captchaNodeText = FocusNode();

  Captcha captcha = Captcha(data: '', captchaId: '',);

  void _getCaptcha() async {
    BaseEntity<Captcha> res = await LoginRepository.getCaptcha();
    if(res.code == 1000) {
      setState(() {
        captcha = res.data!;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getCaptcha();
  }

  @override
  void dispose() {
    super.dispose();
    _captchaController.dispose();
    _captchaNodeText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 180),
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width - 60,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Expanded(
                      child: MyNumberField(
                          controller: _captchaController,
                          nodeText: _captchaNodeText,
                          maxLength: 4,
                          hintText: '图片验证码'
                      )),
                  captcha.data.isNotEmpty ? Image.memory(
                    base64.decode(captcha!.data.split(',')[1]),
                    height:100,    //设置高度
                    width:100,    //设置宽度
                    fit: BoxFit.fill,    //填充
                    gaplessPlayback:true, //防止重绘
                  ) : const SizedBox()
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if(_captchaController.text.isEmpty){
                  Toast.show('请输入图片验证码');
                  return;
                }
                BaseEntity res = await LoginRepository.smsCode(widget.phone,_captchaController.text,captcha!.captchaId);
                if(res.code == 1000) {
                  Toast.show('发送成功');
                  if(mounted) {
                    widget.callback(true);
                    Navigator.pop(context);
                  }
                } else {
                  Toast.show(res.message);
                  _getCaptcha();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colours.app_main,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: const Text(
                  '发送短信',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    fontFamily: "KaiTi",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
