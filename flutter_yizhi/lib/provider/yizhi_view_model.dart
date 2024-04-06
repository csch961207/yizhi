import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/home/model/data_entity.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:image/image.dart' as img;
import 'package:sp_util/sp_util.dart';

class YizhiViewModel with ChangeNotifier {
  /// 内容推荐模式
  int mode = 0;
  String modeStr = '海棠依旧';

  /// 最近看过的标签
  List<String> myRecentTag = [];

  /// 蓝牙设备
  BluetoothCharacteristic? writeCharacteristic;

  YizhiViewModel() {
    // 获取内容推荐模式
    setMode(SpUtil.getInt('mode', defValue: 0)!);
  }

  ///设置内容推荐模式
  setMode(int mode) async {
    this.mode = mode;
    SpUtil.putInt('mode', mode);
    if (mode == 0) {
      modeStr = '海棠依旧';
    } else if (mode == 1) {
      modeStr = '平生未识';
    } else {
      modeStr = '时刻驻足';
    }
    notifyListeners();
  }

  /// 获取最近看过的标签
  getMyRecentTag() async {
    BaseEntity<List<String>> res = await HomeRepository.getMyRecentTag();
    if (res.code == 1000) {
      myRecentTag = res.data!;
      notifyListeners();
    }
  }

  /// 设置蓝牙设备
  setWriteCharacteristic(BluetoothCharacteristic writeCharacteristic) async {
    this.writeCharacteristic = writeCharacteristic;
    notifyListeners();
  }

  /// 打印文本
  Future<String> printText(int id) async {
    // 错误信息
    String error = '';
    if (writeCharacteristic != null) {
      try {
        BaseEntity<SaveDataEntity> res = await HomeRepository.explore(id);
        if (res.code != 1000) {
          error = res.message;
          return error;
        } else {
          if (res.data!.hiddenContent.isEmpty) {
            error = '空空如也';
            return error;
          }
          Uint8List imageBytes = await ImageUtils.textToImageBytes(
              res.data!.hiddenContent + '\n\n\n');
          List<List<int>> dataRows = ImageUtils.convertToDataRows(imageBytes);
          List<int> newData = ImageUtils.compressDataRows(dataRows);
          // 每行48个字节
          for (var i = 0; i < newData.length; i += 48) {
            var end = i + 48;
            if (end > newData.length) {
              end = newData.length;
            }
            var subList = newData.sublist(i, end);
            Uint8List subUint8List = Uint8List.fromList(subList);
            await writeCharacteristic?.write(subUint8List);
            await Future.delayed(const Duration(milliseconds: 10));
          }
          // 结束打印
          Uint8List finishByteArray = Uint8List(5);
          finishByteArray[0] = 0xA6;
          finishByteArray[1] = 0xA6;
          finishByteArray[2] = 0xA6;
          finishByteArray[3] = 0xA6;
          finishByteArray[4] = 0x01;
          writeCharacteristic?.write(finishByteArray);
          return error;
        }
      } catch (e) {
        error = '请检查连接设备';
        return error;
      }
    } else {
      error = '蓝牙设备未连接';
      return error;
    }
  }
}
