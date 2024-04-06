import 'package:flutter_yizhi/net/base_entity.dart';

class Person {
  late int id;
  late String createTime;
  late String updateTime;
  late String unionid;
  late String? avatarUrl;
  late String nickName;
  late String phone;
  late int gender;
  late int status;
  late int loginType;

  Person(
      {required this.id,
      required this.createTime,
      required this.updateTime,
      required this.unionid,
      this.avatarUrl,
      required this.nickName,
      required this.phone,
      required this.gender,
      required this.status,
      required this.loginType});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    unionid = json['unionid'];
    avatarUrl = json['avatarUrl'];
    nickName = json['nickName'];
    phone = json['phone'];
    gender = json['gender'];
    status = json['status'];
    loginType = json['loginType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['unionid'] = unionid;
    data['avatarUrl'] = avatarUrl;
    data['nickName'] = nickName;
    data['phone'] = phone;
    data['gender'] = gender;
    data['status'] = status;
    data['loginType'] = loginType;
    return data;
  }
}

class PersonPageEntity {
  PersonPageEntity({required this.list, required this.pagination});

  late List<Person> list;
  late PaginationEntity pagination;

  PersonPageEntity.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(Person.fromJson(v));
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
