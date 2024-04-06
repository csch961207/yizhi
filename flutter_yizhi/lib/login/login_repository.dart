import 'dart:convert';

import 'package:flutter_yizhi/login/model/login_res_model.dart';
import 'package:flutter_yizhi/net/base_entity.dart';

import '../net/dio_utils.dart';
import '../res/constant.dart';
import 'model/captcha_model.dart';

class LoginRepository {

  /// 获取验证码图片
  static Future<BaseEntity<Captcha>> getCaptcha() async {
    var response = await DioUtils().dio.get(
      'app/user/login/captcha',queryParameters: {
      'type': 'png',
      'height': '100',
      'width': '300',
      'color': '#3C3E4E'
    }
    );
    Map<String, dynamic> responseData =  jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null ? Captcha.fromJson(responseData['data']) : null
    });
  }

  /// 获取验证码
  static Future<BaseEntity> smsCode(
      String phone, String code, String captchaId) async {
    var response = await DioUtils().dio.post(
        'app/user/login/smsCode',
        data: {'phone': phone, 'code': code, 'captchaId': captchaId});
    Map<String, dynamic> responseData =  jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 手机号登录
  static Future<BaseEntity<LoginRes>> loginPhone(
      String phone, String smsCode) async {
    var response = await DioUtils().dio.post(
        'app/user/login/phone',
        data: {'phone': phone, 'smsCode': smsCode});
    Map<String, dynamic> responseData =  jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null ? LoginRes.fromJson(responseData['data']) : null
    });
  }

}
