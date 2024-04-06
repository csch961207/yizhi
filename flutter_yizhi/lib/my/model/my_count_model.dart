class MyCount {
  late int favoriteCount;
  late int followCount;
  late int fansCount;

  MyCount(
      {required this.favoriteCount,
      required this.followCount,
      required this.fansCount});

  MyCount.fromJson(Map<String, dynamic> json) {
    favoriteCount = json['favoriteCount'];
    followCount = json['followCount'];
    fansCount = json['fansCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['favoriteCount'] = favoriteCount;
    data['followCount'] = followCount;
    data['fansCount'] = fansCount;
    return data;
  }
}
