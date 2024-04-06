import 'package:flutter/foundation.dart';

class Constant {
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = kReleaseMode;

  static bool isDriverTest = false;
  static bool isUnitTest = false;

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static const String keyGuide = 'keyGuide';
  static const String phone = 'phone';
  static const String accessToken = 'token';
  static const String refreshToken = 'refreshToken';
  static const String expire = 'expire';
  static const String refreshExpire = 'refreshExpire';

  static const String mode = 'mode';

  static const String theme = 'AppTheme';
  static const String locale = 'locale';

  /// 自定义蓝牙服务和特征的UUID
  static const String customServiceUuid =
      '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String customCharacteristicUuid =
      'beb5483e-36e1-4688-b7f5-ea07361b26a8';
  // 二值化的域值
  static const int threshold = 128;

  // baseUrl
  static const String baseUrl = 'http://192.168.60.179:8001/';
}
