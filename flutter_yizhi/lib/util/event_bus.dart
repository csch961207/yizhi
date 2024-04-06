class EventBus {
  //私有构造函数
  EventBus._internal();

  static EventBus? _instance;

  static EventBus get instance => _getInstance();

  static EventBus _getInstance() {
    return _instance ??= EventBus._internal();
  }

  // 存储事件回调方法
  final Map<String, Function> _events = {};

  // 设置事件监听
  void addListener(String eventKey, Function callback) {
    _events[eventKey] = callback;
  }

  // 移除监听
  void removeListener(String eventKey) {
    _events.remove(eventKey);
  }

  // 提交事件
  void commit(String eventKey) {
    _events[eventKey]?.call();
  }
}

class EventKeys {
  static const String logout = "Logout";
  static const String switchMode = "SwitchMode";
  static const String refresh = "Refresh";
  static const String infoRefresh = "InfoRefresh";
  static const String update = "Update";
}
