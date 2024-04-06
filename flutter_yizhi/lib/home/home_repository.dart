import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_yizhi/home/model/message_entity.dart';
import 'package:flutter_yizhi/home/model/upload_entity.dart';
import 'package:flutter_yizhi/util/date_utils.dart';

import '../net/base_entity.dart';
import '../net/dio_utils.dart';
import 'package:uuid/uuid.dart';
import 'model/data_entity.dart';

class HomeRepository {
  /// 获取内容分页
  static Future<BaseEntity<DataPageEntity>> getDataPage(int page, int size,
      {String? keyWord, int? mode, int? userId, int? sort}) async {
    var response = await DioUtils().dio.post('app/content/data/page', data: {
      "keyWord": keyWord,
      "page": page,
      "size": size,
      "mode": mode,
      "userId": userId,
      "sort": sort
    });
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? DataPageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 根据标签获取内容分页
  static Future<BaseEntity<DataPageEntity>> getTagPage(int page, int size,
      {String? tag, int? sort}) async {
    var response = await DioUtils().dio.post('app/content/data/tagPage',
        data: {"page": page, "size": size, "sort": sort, "tag": tag});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? DataPageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 创建分享内容
  static Future<BaseEntity> addData(SaveDataEntity saveDataEntity) async {
    var response = await DioUtils()
        .dio
        .post('app/content/data/add', data: saveDataEntity.toJson());
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 更新分享内容
  static Future<BaseEntity> updateData(SaveDataEntity saveDataEntity) async {
    var response = await DioUtils()
        .dio
        .post('app/content/data/update', data: saveDataEntity.toJson());
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 获取分享内容详情
  static Future<BaseEntity<DataEntity>> getDataInfo(String id) async {
    var response = await DioUtils()
        .dio
        .get('app/content/data/info', queryParameters: {'id': id});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? DataEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 获取分享内容详情
  static Future<BaseEntity<List<String>>> getMyRecentTag() async {
    var response =
        await DioUtils().dio.get('app/content/userBehavior/getMyRecentTag');
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(
        {...responseData, 'data': responseData['data'].cast<String>()});
  }

  /// 取消、收藏分享内容
  static Future<BaseEntity<bool>> like(int dataId) async {
    var response = await DioUtils()
        .dio
        .post('app/content/userBehavior/like', data: {"dataId": dataId});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 取消、关注作者
  static Future<BaseEntity<bool>> follow(int author) async {
    var response = await DioUtils()
        .dio
        .post('app/content/userBehavior/follow', data: {"author": author});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  // 加入常看、取消常看
  static Future<BaseEntity<bool>> watching(int dataId) async {
    var response = await DioUtils()
        .dio
        .post('app/content/userBehavior/watching', data: {"dataId": dataId});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 举报
  static Future<BaseEntity<bool>> report(int dataId, String description) async {
    var response = await DioUtils().dio.post('app/content/userBehavior/report',
        data: {"dataId": dataId, "description": description});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 获取最新的一些实时聊天消息
  static Future<BaseEntity<List<MessageEntity>>> getRecentMessage(
      int dataId) async {
    var response = await DioUtils()
        .dio
        .post('app/content/message/list', data: {"dataId": dataId});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    List<MessageEntity> list = [];
    if (responseData['data'] != null) {
      responseData['data'].forEach((v) {
        list.add(MessageEntity.fromJson(v));
      });
    }
    return BaseEntity.fromJson({...responseData, 'data': list});
  }

  /// 探知-查询隐藏内容 /app/content/data/explore
  static Future<BaseEntity<SaveDataEntity>> explore(int dataId) async {
    var response = await DioUtils()
        .dio
        .post('app/content/data/explore', data: {"dataId": dataId});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? SaveDataEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 上传文件
  static Future<BaseEntity<String>> uploadFile(String filePath) async {
    var response = await DioUtils().dio.post('app/base/comm/upload');
    Map<String, dynamic> responseData = jsonDecode(response.data);
    if (responseData['code'] == 1000) {
      UploadCosEntity uploadCosEntity =
          UploadCosEntity.fromJson(responseData['data']);
      String fileName = [
        "app",
        DateUtils.apiDayFormat(DateTime.now()),
        const Uuid().v4()
      ].join('/');
      try {
      await Dio().post(uploadCosEntity.url,
          data: FormData.fromMap({
            ...uploadCosEntity.credentials.toJson(),
            "file": await MultipartFile.fromFile(filePath),
            "key": fileName
          }));
      return BaseEntity.fromJson({
        'code': 1000,
        'message': '',
        'data': '${uploadCosEntity.url}/$fileName'
      });
      } catch (e) {
        return BaseEntity.fromJson(
            {...responseData, 'code': 500, 'message': '上传失败'});
      }
    } else {
      return BaseEntity.fromJson(responseData);
    }
  }
}
