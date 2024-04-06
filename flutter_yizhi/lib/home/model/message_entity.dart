class MessageEntity {
  MessageEntity(
      {required this.message,
      required this.userId,
      required this.nickName,
      required this.avatarUrl,
      required this.dataId,
      required this.id});

  MessageEntity.fromJson(Map<String, dynamic> json) {
    message = json['message'] as String;
    userId = json['userId'] as int;
    nickName = json['nickName'] as String;
    avatarUrl = json['avatarUrl'] != null ? json['avatarUrl'] as String : '';
    dataId = json['dataId'] as int;
    id = json['id'] as int;
  }

  late String message;
  late int userId;
  late String nickName;
  late String avatarUrl;
  late int dataId;
  late int id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['userId'] = userId;
    data['nickName'] = nickName;
    data['avatarUrl'] = avatarUrl;
    data['dataId'] = dataId;
    data['id'] = id;
    return data;
  }
}
