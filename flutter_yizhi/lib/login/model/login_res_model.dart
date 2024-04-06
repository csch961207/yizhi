class LoginRes {

  LoginRes({required this.expire, required this.refreshExpire, required this.refreshToken, required this.token});

  late int expire;
  late int refreshExpire;
  late String refreshToken;
  late String token;

  LoginRes.fromJson(Map<String, dynamic> json) {
    expire = json['expire'];
    refreshExpire = json['refreshExpire'];
    refreshToken = json['refreshToken'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expire'] = expire;
    data['refreshExpire'] = refreshExpire;
    data['refreshToken'] = refreshToken;
    data['token'] = token;
    return data;
  }
}