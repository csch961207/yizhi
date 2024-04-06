class TagEntity {

  TagEntity({required this.label, required this.id});

  TagEntity.fromJson(Map<String, dynamic> json) {
    label = json['label'] as String;
    id = json['id'] as int;
  }

  late String label;
  late int id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['id'] = id;
    return data;
  }
}