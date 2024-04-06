import 'package:flutter/material.dart';
import 'package:flutter_yizhi/login/login_router.dart';
import 'package:flutter_yizhi/res/constant.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/widget/base_dialog.dart';
import 'package:sp_util/sp_util.dart';

class ExitDialog extends StatefulWidget {
  const ExitDialog({
    super.key,
  });

  @override
  State<ExitDialog> createState() => _ExitDialog();
}

class _ExitDialog extends State<ExitDialog> {
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: '提示',
      child: const Padding(
        padding: EdgeInsets.only(bottom: 28),
        child: Text(
          '您确定要退出登录吗？',
          // style: TextStyle(color: Color(0xff717179)),
        ),
      ),
      onPressed: () {
        SpUtil.remove(Constant.accessToken);
        SpUtil.remove(Constant.refreshToken);
        SpUtil.remove(Constant.expire);
        SpUtil.remove(Constant.refreshExpire);
        NavigatorUtils.push(context, LoginRouter.loginPage, clearStack: true);
      },
    );
  }
}
