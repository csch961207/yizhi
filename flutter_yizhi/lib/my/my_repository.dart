import 'dart:convert';

import 'package:flutter_yizhi/my/model/cloud_device.dart';
import 'package:flutter_yizhi/my/model/device_entity.dart';
import 'package:flutter_yizhi/my/model/my_count_model.dart';
import 'package:flutter_yizhi/my/model/version_entity.dart';

import '../home/model/data_entity.dart';
import '../home/model/tag_entity.dart';
import '../net/base_entity.dart';
import '../net/dio_utils.dart';
import 'model/person_model.dart';

class MyRepository {
  /// 获取用户资料
  static Future<BaseEntity<Person>> getPerson() async {
    var response = await DioUtils().dio.get(
          'app/user/info/person',
        );
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? Person.fromJson(responseData['data'])
          : null
    });
  }

  /// 修改用户资料
  static Future<BaseEntity> updatePerson(Person person) async {
    var response = await DioUtils().dio.post(
          'app/user/info/updatePerson',
          data: person.toJson(),
        );
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 获取内容分页
  static Future<BaseEntity<DataPageEntity>> getMyDataPage(int page, int size,
      {String? keyWord, int? mode}) async {
    var response = await DioUtils().dio.post('app/content/data/myPage',
        data: {"keyWord": keyWord, "page": page, "size": size});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? DataPageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 获取历史记录内容分页
  static Future<BaseEntity<DataPageEntity>> getHistoryDataPage(
      int page, int size,
      {String? keyWord, int? mode}) async {
    var response = await DioUtils().dio.post(
        'app/content/userBehavior/getMyViewContent',
        data: {"page": page, "size": size});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? DataPageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 获取我关注的作者分页
  static Future<BaseEntity<PersonPageEntity>> getFollowPage(int page, int size,
      {String? keyWord, int? mode}) async {
    var response = await DioUtils().dio.post(
        'app/content/userBehavior/getMyFollowList',
        data: {"keyWord": keyWord, "page": page, "size": size});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? PersonPageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 获取关注我的用户分页
  static Future<BaseEntity<PersonPageEntity>> getFansPage(int page, int size,
      {String? keyWord, int? mode}) async {
    var response = await DioUtils().dio.post(
        'app/content/userBehavior/getFollowMeList',
        data: {"keyWord": keyWord, "page": page, "size": size});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? PersonPageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 获得我收藏的内容分页
  static Future<BaseEntity<DataPageEntity>> getMyCollectPage(int page, int size,
      {String? keyWord, int? mode}) async {
    var response = await DioUtils().dio.post(
        'app/content/userBehavior/getMyFavoriteContent',
        data: {"keyWord": keyWord, "page": page, "size": size});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? DataPageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 删除内容分页
  static Future<BaseEntity<bool>> deleteMyData(List<int> ids) async {
    var response = await DioUtils()
        .dio
        .post('app/content/data/delete', data: {"ids": ids});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(
        {...responseData, 'data': responseData['data'] ?? false});
  }

  /// 删除我看过的内容
  static Future<BaseEntity<bool>> deleteView(int id) async {
    var response = await DioUtils()
        .dio
        .post('app/content/userBehavior/deleteView', data: {"dataId": id});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(
        {...responseData, 'data': responseData['data'] ?? false});
  }

  /// 删除我看过的所有内容
  static Future<BaseEntity<bool>> deleteAllView() async {
    var response =
        await DioUtils().dio.post('app/content/userBehavior/deleteAllView');
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(
        {...responseData, 'data': responseData['data'] ?? false});
  }

  /// 获取我的分享内容详情
  static Future<BaseEntity<SaveDataEntity>> getMyDataInfo(String id) async {
    var response = await DioUtils()
        .dio
        .get('app/content/data/info', queryParameters: {'id': id});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? SaveDataEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 获取标签
  static Future<BaseEntity<List<TagEntity>>> getTagList(
      {String? keyWord}) async {
    var response = await DioUtils().dio.post('app/content/tag/page',
        data: {"keyWord": keyWord, "page": 1, "size": 10});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    List<TagEntity> list = [];
    if (responseData['data'] != null && responseData['data']['list'] != null) {
      responseData['data']['list'].forEach((v) {
        list.add(TagEntity.fromJson(v));
      });
    }
    return BaseEntity.fromJson({...responseData, 'data': list});
  }

  /// 获得我的收藏、关注、粉丝的数量
  static Future<BaseEntity<MyCount>> getMyCount() async {
    var response =
        await DioUtils().dio.get('app/content/userBehavior/getMyCount');
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? MyCount.fromJson(responseData['data'])
          : null
    });
  }

  /// 获取我的设备
  static Future<BaseEntity<DeviceEntity>> getMyDevice() async {
    var response = await DioUtils().dio.get('app/content/device/myDevice');
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? DeviceEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 检查版本
  static Future<BaseEntity<VersionEntity>> checkVersion(String version,
      {int type = 0}) async {
    var response = await DioUtils().dio.get('app/app/version/check',
        queryParameters: {'type': type, 'version': version});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? VersionEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 获得互印空间设备列表
  static Future<BaseEntity<CloudDevicePageEntity>> getCloudDevicePage(
      int page, int size,
      {String? keyWord, int? mode}) async {
    var response = await DioUtils().dio.post('app/content/cloudDevice/page',
        data: {"keyWord": keyWord, "page": page, "size": size});
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? CloudDevicePageEntity.fromJson(responseData['data'])
          : null
    });
  }

  /// 设备上云
  static Future<BaseEntity> addCloudDevice(
      SaveCloudDeviceEntity saveCloudDeviceEntity) async {
    var response = await DioUtils().dio.post('app/content/cloudDevice/add',
        data: saveCloudDeviceEntity.toJson());
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 上云设备修改
  static Future<BaseEntity> updateCloudDevice(
      SaveCloudDeviceEntity saveCloudDeviceEntity) async {
    var response = await DioUtils().dio.post('app/content/cloudDevice/update',
        data: saveCloudDeviceEntity.toJson());
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson(responseData);
  }

  /// 获取我的分享内容详情
  static Future<BaseEntity<SaveCloudDeviceEntity>> myCloudDevice() async {
    var response =
        await DioUtils().dio.get('app/content/cloudDevice/myCloudDevice');
    Map<String, dynamic> responseData = jsonDecode(response.data);
    return BaseEntity.fromJson({
      ...responseData,
      'data': responseData['data'] != null
          ? SaveCloudDeviceEntity.fromJson(responseData['data'])
          : null
    });
  }
}
