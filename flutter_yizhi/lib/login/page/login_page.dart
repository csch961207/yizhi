import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../net/base_entity.dart';
import '../../res/constant.dart';
import '../../util/toast_utils.dart';
import '../../widget/my_number_field.dart';
import '../login_repository.dart';
import '../model/captcha_model.dart';
import '../model/login_res_model.dart';
import '../widget/captcha_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneNodeText = FocusNode();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeNodeText = FocusNode();

  final TextEditingController _captchaController = TextEditingController();
  final FocusNode _captchaNodeText = FocusNode();

  late Timer _timer;
  int currentTimer = 0;

  @override
  void initState() {
    super.initState();
  }

  /// 开始计时
  start() {
    if (currentTimer > 0) return;
    print('----开始计时----');
    currentTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentTimer <= 0) {
        _timer.cancel();
        return;
      }
      setState(() {
        currentTimer--;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneNodeText.dispose();
    _codeController.dispose();
    _codeNodeText.dispose();
    _captchaController.dispose();
    _captchaNodeText.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              '欢迎来到一枝',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Image(
                    image: ImageUtils.getAssetImage('phone'),
                    width: 21.0,
                    height: 21.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 0.6,
                      height: 13,
                      child: VerticalDivider(),
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    style: const TextStyle(
                      height: 1,
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 16,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colours.app_main,
                    focusNode: _phoneNodeText,
                    maxLength: 11,
                    controller: _phoneController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    // 数字、手机号限制格式为0到9， 密码限制不包含汉字
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 16),
                      hintText: '请输入手机号码',
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Image(
                    image: ImageUtils.getAssetImage('code'),
                    width: 21.0,
                    height: 21.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 0.6,
                      height: 13,
                      child: VerticalDivider(),
                    ),
                  ),
                  Expanded(
                      child: MyNumberField(
                          controller: _codeController,
                          nodeText: _codeNodeText,
                          maxLength: 4,
                          hintText: '请输入验证码')),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          if (currentTimer > 0) return;
                          if (_phoneController.text.isEmpty) {
                            Toast.show('请输入手机号');
                            return;
                          }
                          if (mounted) {
                            _showCaptchaDialog(context, _phoneController.text,
                                (succeed) {
                              if (succeed) {
                                start();
                              }
                            });
                          }
                        },
                        child: Text(
                          currentTimer > 0 ? '${currentTimer}s后获取' : '获取验证码',
                          style: TextStyle(
                              color: currentTimer > 0
                                  ? const Color(0xff696969)
                                  : Colours.app_main),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Image(
                      image: ImageUtils.getAssetImage('selected'),
                      width: 13.0,
                      height: 13.0,
                    ),
                  ),
                  const Expanded(
                      child: Wrap(
                    children: [
                      Text(
                        '我已阅读并同意',
                        style:
                            TextStyle(color: Color(0xff72727A), fontSize: 12),
                      ),
                      Text(
                        '《用户服务协议》',
                        style: TextStyle(color: Colours.app_main, fontSize: 12),
                      ),
                      Text(
                        '和',
                        style:
                            TextStyle(color: Color(0xff72727A), fontSize: 12),
                      ),
                      Text(
                        '《隐私政策》',
                        style: TextStyle(color: Colours.app_main, fontSize: 12),
                      )
                    ],
                  ))
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                BaseEntity<LoginRes> res = await LoginRepository.loginPhone(
                    _phoneController.text, _codeController.text);
                if (mounted) {
                  if (res.code == 1000) {
                    Toast.show('登录成功');
                    SpUtil.putString(Constant.accessToken, res.data!.token);
                    SpUtil.putInt(
                        Constant.expire,
                        res.data!.expire +
                            DateTime.now().millisecondsSinceEpoch);
                    SpUtil.putString(
                        Constant.refreshToken, res.data!.refreshToken);
                    SpUtil.putInt(
                        Constant.refreshExpire,
                        res.data!.refreshExpire +
                            DateTime.now().millisecondsSinceEpoch);
                    NavigatorUtils.push(context, '/home');
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
                  '登录',
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

  void _showCaptchaDialog(BuildContext context, String phone,
      void Function(bool succeed) callback) async {
    showDialog(
        barrierDismissible: true,
        builder: (context) => CaptchaWidget(phone: phone, callback: callback),
        context: context);
  }
}
