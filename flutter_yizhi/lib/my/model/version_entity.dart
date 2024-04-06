class VersionEntity {
  late String createTime;
  late String updateTime;
  late String name;
  late String version;
  late String url;
  late String description;
  late int type;
  late int forceUpdate;

  VersionEntity(
      {required this.createTime,
      required this.updateTime,
      required this.name,
      required this.version,
      required this.url,
      required this.description,
      required this.type,
      required this.forceUpdate});

  VersionEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    name = json['name'];
    version = json['version'];
    url = json['url'];
    description = json['description'];
    type = json['type'];
    forceUpdate = json['forceUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['name'] = name;
    data['version'] = version;
    data['url'] = url;
    data['description'] = description;
    data['type'] = type;
    data['forceUpdate'] = forceUpdate;
    return data;
  }
}
