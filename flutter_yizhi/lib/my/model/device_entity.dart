class DeviceEntity {
  DeviceEntity({required this.deviceName, required this.id});

  DeviceEntity.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'] as String;
    id = json['id'] as int;
  }

  late String deviceName;
  late int id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    data['id'] = id;
    return data;
  }
}
