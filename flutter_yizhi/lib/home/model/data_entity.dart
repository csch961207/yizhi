import '../../net/base_entity.dart';

class SaveDataEntity {
  SaveDataEntity(
      {this.id,
      required this.title,
      required this.tagList,
      required this.url,
      required this.hiddenContent});

  SaveDataEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    title = json['title'] as String;
    tagList = json['tagList'].cast<String>();
    url = json['url'] as String;
    hiddenContent = json['hiddenContent'] as String;
  }

  late int? id;
  late String title;
  late List<String> tagList;
  late String url;
  late String hiddenContent;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['tagList'] = tagList;
    data['url'] = url;
    data['hiddenContent'] = hiddenContent;
    return data;
  }
}

class DataEntity {
  DataEntity(
      {required this.createTime,
      required this.updateTime,
      required this.title,
      required this.tagList,
      required this.url,
      this.likedCount,
      this.isLiked = false,
      this.isWatching = false,
      this.isFollow = false,
      this.isDeleted = false,
      required this.userId,
      required this.userName,
      required this.avatarUrl,
      required this.id});

  DataEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'] as String;
    updateTime = json['updateTime'] as String;
    title = json['title'] as String;
    tagList = json['tagList'].cast<String>();
    url = json['url'] as String;
    likedCount = json['likedCount'] as String;
    isLiked = json['isLiked'] != null ? json['isLiked'] as bool : false;
    isWatching =
        json['isWatching'] != null ? json['isWatching'] as bool : false;
    isFollow = json['isFollow'] != null ? json['isFollow'] as bool : false;
    isDeleted = json['isDeleted'] != null ? json['isDeleted'] as bool : false;
    userId = json['userId'] as int;
    userName = json['userName'] as String;
    avatarUrl = json['avatarUrl'] != null ? json['avatarUrl'] as String : '';
    id = json['id'] as int;
  }

  late String createTime;
  late String updateTime;
  late String title;
  late List<String> tagList;
  late String url;
  late String? likedCount;
  late bool? isLiked = false;
  late bool? isWatching = false;
  late bool? isFollow = false;
  late bool? isDeleted = false;
  late int userId;
  late String userName;
  late String avatarUrl;
  late int id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['title'] = title;
    data['tagList'] = tagList;
    data['url'] = url;
    data['likedCount'] = likedCount;
    data['isLiked'] = isLiked;
    data['isWatching'] = isWatching;
    data['isFollow'] = isFollow;
    data['isDeleted'] = isDeleted;
    data['userId'] = userId;
    data['userName'] = userName;
    data['avatarUrl'] = avatarUrl;
    data['id'] = id;
    return data;
  }
}

class DataPageEntity {
  DataPageEntity({required this.list, required this.pagination});

  late List<DataEntity> list;
  late PaginationEntity pagination;

  DataPageEntity.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(DataEntity.fromJson(v));
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
