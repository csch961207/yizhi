class UploadEntity {
  UploadEntity(
      {required this.expiredTime,
      required this.expiration,
      required this.requestId,
      required this.startTime,
      required this.url});

  UploadEntity.fromJson(Map<String, dynamic> json) {
    expiredTime = json['expiredTime'] as int;
    expiration = json['expiration'] as String;
    requestId = json['requestId'] as String;
    startTime = json['startTime'] as int;
    url = json['url'] as String;
  }

  late int expiredTime;
  late String expiration;
  late CredentialsEntity credentials;
  late String requestId;
  late int startTime;
  late String url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expiredTime'] = expiredTime;
    data['expiration'] = expiration;
    data['requestId'] = requestId;
    data['startTime'] = startTime;
    data['url'] = url;
    return data;
  }
}

class CredentialsEntity {
  CredentialsEntity(
      {required this.sessionToken,
      required this.tmpSecretId,
      required this.tmpSecretKey});

  CredentialsEntity.fromJson(Map<String, dynamic> json) {
    sessionToken = json['sessionToken'] as String;
    tmpSecretId = json['tmpSecretId'] as String;
    tmpSecretKey = json['tmpSecretKey'] as String;
  }

  late String sessionToken;
  late String tmpSecretId;
  late String tmpSecretKey;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionToken'] = sessionToken;
    data['tmpSecretId'] = tmpSecretId;
    data['tmpSecretKey'] = tmpSecretKey;
    return data;
  }
}

class UploadCosEntity {
  UploadCosEntity(
      {required this.expiredTime,
      required this.expiration,
      required this.requestId,
      required this.startTime,
      required this.url});

  UploadCosEntity.fromJson(Map<String, dynamic> json) {
    expiredTime = json['expiredTime'] as int;
    expiration = json['expiration'] as String;
    requestId = json['requestId'] as String;
    startTime = json['startTime'] as int;
    url = json['url'] as String;
    if (json['credentials'] != null) {
      credentials = CredentialsEntity.fromJson(json['credentials']);
    }
  }

  late int expiredTime;
  late String expiration;
  late CredentialsEntity credentials;
  late String requestId;
  late int startTime;
  late String url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expiredTime'] = expiredTime;
    data['expiration'] = expiration;
    data['requestId'] = requestId;
    data['startTime'] = startTime;
    data['url'] = url;
    data['credentials'] = credentials;
    return data;
  }
}

class UploadResEntity {
  UploadResEntity({required this.url});

  UploadResEntity.fromJson(Map<String, dynamic> json) {
    url = json['url'] as String;
  }

  late String url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}
