class Captcha {

  Captcha({required this.data, required this.captchaId});

  late String captchaId;
  late String data;

  Captcha.fromJson(Map<String, dynamic> json) {
    captchaId = json['captchaId'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['captchaId'] = captchaId;
    data['data'] = data;
    return data;
  }
}