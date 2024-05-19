import 'package:flutter_yizhi/net/base_entity.dart';

class SaveCloudDeviceEntity {
  SaveCloudDeviceEntity({this.id, required this.title, this.deviceName});

  SaveCloudDeviceEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    title = json['title'] as String;
    deviceName = json['deviceName'] as String;
  }

  late int? id;
  late String title;
  late String? deviceName;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['deviceName'] = deviceName;
    return data;
  }
}

class CloudDeviceEntity {
  CloudDeviceEntity(
      {required this.createTime,
      required this.updateTime,
      required this.title,
      required this.deviceName,
      required this.userId,
      required this.nickName,
      required this.avatarUrl,
      required this.id});

  CloudDeviceEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'] as String;
    updateTime = json['updateTime'] as String;
    title = json['title'] as String;
    deviceName = json['deviceName'] as String;
    userId = json['userId'] as int;
    nickName = json['nickName'] as String;
    avatarUrl = json['avatarUrl'] != null ? json['avatarUrl'] as String : '';
    id = json['id'] as int;
  }

  late String createTime;
  late String updateTime;
  late String title;
  late String deviceName;
  late int userId;
  late String nickName;
  late String avatarUrl;
  late int id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['title'] = title;
    data['deviceName'] = deviceName;
    data['userId'] = userId;
    data['nickName'] = nickName;
    data['avatarUrl'] = avatarUrl;
    data['id'] = id;
    return data;
  }
}

class CloudDevicePageEntity {
  CloudDevicePageEntity({required this.list, required this.pagination});

  late List<CloudDeviceEntity> list;
  late PaginationEntity pagination;

  CloudDevicePageEntity.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(CloudDeviceEntity.fromJson(v));
      });
    }
    if (json['pagination'] != null) {
      pagination = PaginationEntity.fromJson(json['pagination']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['list'] = list;
    data['pagination'] = pagination;
    return data;
  }
}
