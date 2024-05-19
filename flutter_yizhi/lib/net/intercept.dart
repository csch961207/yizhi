import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_yizhi/login/model/login_res_model.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/constant.dart';
import 'package:flutter_yizhi/util/device_utils.dart';
import 'package:flutter_yizhi/util/log_utils.dart';
import 'package:flutter_yizhi/util/other_utils.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';

import '../util/event_bus.dart';
import 'dio_utils.dart';
import 'error_handle.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String accessToken = SpUtil.getString(Constant.accessToken).nullSafe;
    final String refreshToken =
        SpUtil.getString(Constant.refreshToken).nullSafe;
    print('----refreshToken-----');
    print(refreshToken);
    print('----refreshToken-----');
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = accessToken;
    }
    if (!Device.isWeb) {
      // https://developer.github.com/v3/#user-agent-required
      options.headers['User-Agent'] = 'Mozilla/5.0';
    }
    super.onRequest(options, handler);
  }
}

class TokenInterceptor extends QueuedInterceptor {
  Dio? _tokenDio;

  Future<LoginRes?> getToken() async {
    final Map<String, String> params = <String, String>{};
    params['refreshToken'] = SpUtil.getString(Constant.refreshToken).nullSafe;
    try {
      _tokenDio ??= Dio();
      _tokenDio!.options = DioUtils.instance.dio.options;
      final Response<dynamic> response = await _tokenDio!
          .post<dynamic>('app/user/login/refreshToken', data: params);
      if (response.statusCode == ExceptionHandle.success) {
        Map<String, dynamic> responseData = jsonDecode(response.data);
        return LoginRes.fromJson(responseData['data']);
      }
    } catch (e) {
      Log.e('刷新Token失败！');
    }
    return null;
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String accessToken = SpUtil.getString(Constant.accessToken).nullSafe;
    final int? expire = SpUtil.getInt(Constant.expire);
    final int? refreshExpire = SpUtil.getInt(Constant.refreshExpire);
    print('----expire-----');
    print(accessToken);
    print(expire);
    print(refreshExpire);
    print('----expire-----');
    if (accessToken.isNotEmpty && expire != null) {
      if (expire - DateTime.now().millisecondsSinceEpoch <= 0) {
        if (refreshExpire == null) {
          EventBus.instance.commit(EventKeys.logout);
        } else if (refreshExpire - DateTime.now().millisecondsSinceEpoch <= 0) {
          Log.d('-----------自动刷新Token------------');
          final LoginRes? res = await getToken(); // 获取新的accessToken

          if (res?.token != null) {
            SpUtil.putString(Constant.accessToken, res!.token);
            SpUtil.putString(Constant.refreshToken, res.refreshToken);
            SpUtil.putInt(Constant.expire,
                res.expire + DateTime.now().millisecondsSinceEpoch);
            SpUtil.putInt(Constant.refreshExpire,
                res.refreshExpire + DateTime.now().millisecondsSinceEpoch);

            // 设置新的Authorization
            options.headers['Authorization'] = res.token;
          } else {
            EventBus.instance.commit(EventKeys.logout);
          }
        }
      }
    } else {
      EventBus.instance.commit(EventKeys.logout);
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    //401代表token过期
    if (response.statusCode == ExceptionHandle.unauthorized) {
      EventBus.instance.commit(EventKeys.logout);
    }
    super.onResponse(response, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    Log.d('----------Start----------');
    if (options.queryParameters.isEmpty) {
      Log.d('RequestUrl: ${options.baseUrl}${options.path}');
    } else {
      Log.d(
          'RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}');
    }
    Log.d('RequestMethod: ${options.method}');
    Log.d('RequestHeaders:${options.headers}');
    Log.d('RequestContentType: ${options.contentType}');
    Log.d('RequestData: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      Log.d('ResponseCode: ${response.statusCode}');
    } else {
      Log.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    Log.json(response.data.toString());
    Log.d('----------End: $duration 毫秒----------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.d('----------Error-----------');
    super.onError(err, handler);
  }
}

class AdapterInterceptor extends Interceptor {
  static const String _kMsg = 'msg';
  static const String _kSlash = "'";
  static const String _kMessage = 'message';

  static const String _kDefaultText = '无返回信息';
  static const String _kNotFound = '未找到查询信息';

  static const String _kFailureFormat = '{"code":%d,"message":"%s"}';
  static const String _kSuccessFormat = '{"code":0,"data":%s,"message":""}';

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    final Response<dynamic> r = adapterData(response);
    super.onResponse(r, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      adapterData(err.response!);
    }
    super.onError(err, handler);
  }

  Response<dynamic> adapterData(Response<dynamic> response) {
    String result;
    String content = response.data?.toString() ?? '';

    /// 成功时，直接格式化返回
    if (response.statusCode == ExceptionHandle.success ||
        response.statusCode == ExceptionHandle.success_not_content) {
      if (content.isEmpty) {
        content = _kDefaultText;
      }
      result = sprintf(_kSuccessFormat, [content]);
      response.statusCode = ExceptionHandle.success;
    } else {
      if (response.statusCode == ExceptionHandle.not_found) {
        /// 错误数据格式化后，按照成功数据返回
        result = sprintf(_kFailureFormat, [response.statusCode, _kNotFound]);
        response.statusCode = ExceptionHandle.success;
      } else {
        if (content.isEmpty) {
          // 一般为网络断开等异常
          result = content;
        } else {
          String msg;
          try {
            content = content.replaceAll(r'\', '');
            if (_kSlash == content.substring(0, 1)) {
              content = content.substring(1, content.length - 1);
            }
            final Map<String, dynamic> map =
                json.decode(content) as Map<String, dynamic>;
            if (map.containsKey(_kMessage)) {
              msg = map[_kMessage] as String;
            } else if (map.containsKey(_kMsg)) {
              msg = map[_kMsg] as String;
            } else {
              msg = '未知异常';
            }
            result = sprintf(_kFailureFormat, [response.statusCode, msg]);
            // 401 token失效时，单独处理，其他一律为成功
            if (response.statusCode == ExceptionHandle.unauthorized) {
              response.statusCode = ExceptionHandle.unauthorized;
            } else {
              response.statusCode = ExceptionHandle.success;
            }
          } catch (e) {
//            Log.d('异常信息：$e');
            // 解析异常直接按照返回原数据处理（一般为返回500,503 HTML页面代码）
            result = sprintf(_kFailureFormat,
                [response.statusCode, '服务器异常(${response.statusCode})']);
          }
        }
      }
    }
    response.data = result;
    return response;
  }
}
