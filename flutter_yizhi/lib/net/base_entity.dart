// import 'package:flutter_yizhi/generated/json/base/json_convert_content.dart';
import 'package:flutter_yizhi/res/constant.dart';

class PaginationEntity {
  PaginationEntity(
      {required this.size, required this.page, required this.total});

  PaginationEntity.fromJson(Map<String, dynamic> json) {
    size = json['size'] as int;
    page = json['page'] as int;
    total = json['total'] as int;
  }

  late int size;
  late int page;
  late int total;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    data['page'] = page;
    data['total'] = total;
    return data;
  }
}

class BaseEntity<T> {
  BaseEntity(this.code, this.message, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code] as int?;
    message = json[Constant.message] as String;
    if (json[Constant.data] != null) {
      data = json[Constant.data] as T;
    }
  }

  // string data
  BaseEntity.fromJsonString(Map<String, dynamic> json) {
    code = json[Constant.code] as int?;
    message = json[Constant.message] as String;
    if (json[Constant.data] != null) {
      data = json[Constant.data].toString() as T?;
    }
  }

  int? code;
  late String message;
  T? data;

  // T? _generateOBJ<O>(Object? json) {
  //   if (json == null) {
  //     return null;
  //   }
  //   if (T.toString() == 'String') {
  //     return json.toString() as T;
  //   } else if (T.toString() == 'Map<dynamic, dynamic>') {
  //     return json as T;
  //   } else {
  //     /// List类型数据由fromJsonAsT判断处理
  //     // return JsonConvert.fromJsonAsT<T>(json);
  //   }
  // }
}
