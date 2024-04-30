import 'dart:async';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_yizhi/my/model/device_entity.dart';
import 'package:flutter_yizhi/my/my_repository.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/res/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MyDevicePage extends StatefulWidget {
  const MyDevicePage({
    super.key,
    this.size = 80.0,
    this.color = Colours.app_main,
  });

  final double size;
  final Color color;

  @override
  State<MyDevicePage> createState() => _MyDevicePageState();
}

class _MyDevicePageState extends State<MyDevicePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  List<ScanResult> _scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  StreamSubscription<List<int>>? _characteristic;
  BluetoothCharacteristic? _writeCharacteristic;

  // 是否正在扫描
  bool _isScanning = false;

  // 是否扫描超时
  bool _isTimeout = false;

  // 电量
  int _battery = 100;
  // 温度
  int _temperature = 30;
  // 工作状态
  int _workStatus = 0;
  // 纸张警告
  int _paperWarn = 0;

  // 我的设备名
  String _myDeviceName = '';

  // 是否加载
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });
    BaseEntity<DeviceEntity> res = await MyRepository.getMyDevice();
    if (res.code == 1000) {
      print('res.data: ${res.data}');
      _myDeviceName = res.data!.deviceName;
      onScan();
    } else {
      Toast.show(res.message);
      // 返回
      if (mounted) {
        NavigatorUtils.goBack(context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future onScan() async {
    try {
      // 查询连接的设备
      // 判断connectedDevices中是否有设备
      if (FlutterBluePlus.connectedDevices
          .any((element) => element.advName == _myDeviceName)) {
        // 如果有
        BluetoothDevice device = FlutterBluePlus.connectedDevices
            .firstWhere((element) => element.advName == _myDeviceName);
        _connectionStateSubscription = device.connectionState
            .listen((BluetoothConnectionState state) async {
          if (state == BluetoothConnectionState.connected) {
            List<BluetoothService> services = await device.discoverServices();
            for (BluetoothService service in services) {
              print('service: ${service.uuid}');
              for (BluetoothCharacteristic characteristic
                  in service.characteristics) {
                if (service.uuid.toString() == Constant.customServiceUuid &&
                    characteristic.uuid.toString() ==
                        Constant.customCharacteristicUuid) {
                  setNotification(characteristic);
                }
              }
            }
          }
          if (state == BluetoothConnectionState.disconnected) {
            setState(() {
              _isScanning = true;
            });
          }
        });
        if (mounted) {
          setState(() {});
        }
        return;
      } else {
        _isScanning = true;
        _scanResultsSubscription =
            FlutterBluePlus.scanResults.listen((results) {
          _scanResults = results;
          // 查找设备
          for (var result in _scanResults) {
            print('-----------------');
            print(result.device.advName);
            print('-----------------');
            if (result.device.advName == _myDeviceName) {
              connectDevice(result.device);
            }
          }
          if (mounted) {
            setState(() {});
          }
        }, onError: (e) {
          print('scanResults-listen');
          print(e);
        });
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
        FlutterBluePlus.isScanning
            .where((val) => val == false)
            .first
            .then((value) {
          if (_controller.status != AnimationStatus.dismissed) {
            _controller.stop();
          }
          setState(() {
            _isTimeout = true;
          });
        });
      }
    } catch (e) {
      print('startScan: ${e}');
    }
    if (mounted) {
      setState(() {});
    }
  }

  // 连接设备
  void connectDevice(BluetoothDevice device) async {
    try {
      _scanResultsSubscription?.cancel();
      // listen for disconnection
      _connectionStateSubscription =
          device.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.connected) {
          // 1. discover services
          List<BluetoothService> services = await device.discoverServices();
          for (BluetoothService service in services) {
            print('service: ${service.uuid}');
            for (BluetoothCharacteristic characteristic
                in service.characteristics) {
              if (service.uuid.toString() == Constant.customServiceUuid &&
                  characteristic.uuid.toString() ==
                      Constant.customCharacteristicUuid) {
                setNotification(characteristic);
              }
            }
          }
        }
        if (state == BluetoothConnectionState.disconnected) {
          setState(() {
            _isScanning = true;
          });
        }
      });
      await device.connect(mtu: 250);
    } catch (e) {
      print('startScan: ${e}');
    }
    if (mounted) {
      setState(() {});
    }
  }

  // 设置为Notification
  void setNotification(BluetoothCharacteristic characteristic) async {
    try {
      _isScanning = false;
      _writeCharacteristic = characteristic;
      Provider.of<YizhiViewModel>(context, listen: false)
          .setWriteCharacteristic(characteristic);
      await characteristic.setNotifyValue(!characteristic.isNotifying);
      _characteristic = characteristic.lastValueStream.listen((value) {
        print('value: ${value}');
        if (value.length == 4) {
          setState(() {
            _battery = value[0];
            _temperature = value[1];
            _paperWarn = value[2];
            _workStatus = value[3];
          });
        }
      });
    } catch (e) {
      print('setNotification: ${e}');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_scanResultsSubscription != null) {
      _scanResultsSubscription?.cancel();
    }
    _connectionStateSubscription?.cancel();
    _characteristic?.cancel();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05)!
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const PulsateCurve(),
              ),
            ),
            child: GestureDetector(
              onTap: () async {
                if (_isTimeout) {
                  // 继续动画
                  _controller.repeat();
                  onScan();
                }
                // Provider.of<YizhiViewModel>(context, listen: false)
                //     .printText('阅尽好花千万树，愿君记取此一枝');
              },
              child: const Icon(
                Icons.bluetooth,
                size: 44,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的设备'),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitDoubleBounce(
              size: 24,
              color: Colours.app_main,
            ))
          : SingleChildScrollView(
              child: Column(children: [
                _isScanning
                    ? Container(
                        height: MediaQuery.of(context).size.height - 200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomPaint(
                              painter: CirclePainter(
                                _controller,
                                color: widget.color,
                              ),
                              child: SizedBox(
                                width: widget.size * 4.125,
                                height: widget.size * 4.125,
                                child: _button(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                _isTimeout
                                    ? '未找到设备，请确认设备是否开启，点击蓝牙图标重新扫描'
                                    : '请保持蓝牙开启，并靠近设备',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '$_battery%',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: ''),
                                    ),
                                    const Text('电量')
                                  ],
                                ),
                                const SizedBox(
                                  width: 0.6,
                                  height: 18.0,
                                  child: VerticalDivider(),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '$_temperature°C',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: ''),
                                    ),
                                    const Text('温度')
                                  ],
                                ),
                                const SizedBox(
                                  width: 0.6,
                                  height: 18.0,
                                  child: VerticalDivider(),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      _paperWarn == 0 ? '正常' : '缺纸',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text('纸张')
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colours.app_main, BlendMode.modulate),
                              child: Lottie.asset(
                                'assets/lottie/volume_indicator.json',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _workStatus == 2
                                      ? Icons.error
                                      : Icons.check_circle,
                                  color: _workStatus == 2
                                      ? Colors.red
                                      : Colors.green,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    '工作状态: ${_workStatus == 2 ? '工作中' : '空闲'}'),
                              ],
                            ),
                          ),
                        ],
                      )
              ]),
            ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);

  final Color color;
  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = color.withOpacity(opacity);
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class PulsateCurve extends Curve {
  const PulsateCurve();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
