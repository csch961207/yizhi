import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yizhi/res/constant.dart';
import 'package:image/image.dart' as img;

import 'log_utils.dart';

class ImageUtils {
  static ImageProvider getAssetImage(String name,
      {ImageFormat format = ImageFormat.png}) {
    return AssetImage(getImgPath(name, format: format));
  }

  static String getImgPath(String name,
      {ImageFormat format = ImageFormat.png}) {
    return 'assets/images/$name.${format.value}';
  }

  static ImageProvider getImageProvider(String? imageUrl,
      {String holderImg = 'none'}) {
    if (TextUtil.isEmpty(imageUrl)) {
      return AssetImage(getImgPath(holderImg));
    }
    return CachedNetworkImageProvider(imageUrl!);
  }

  // 将文字转换为图片
  static Future<Uint8List> textToImageBytes(String text) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final textStyle = ui.TextStyle(
        color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold);
    final paragraphStyle = ui.ParagraphStyle();
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);
    const constraints = ui.ParagraphConstraints(width: 384);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);

    canvas.drawParagraph(paragraph, const Offset(0, 0));

    final picture = recorder.endRecording();
    final img = await picture.toImage(384, paragraph.height.toInt());

    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  static List<List<int>> convertToDataRows(Uint8List bwImageBytes) {
    img.Image? bwImage = img.decodeImage(bwImageBytes);

    final width = bwImage?.width;
    final height = bwImage?.height;

    List<List<int>> rows = [];
    for (var i = 0; i < height!; i++) {
      List<int> row = [];
      for (var j = 0; j < width!; j++) {
        img.Pixel pixel = bwImage!.getPixel(j, i);
        // print('--------------------');
        // print(pixel.toString());
        // print('--------------------');
        if (pixel.toList().last.toInt() > Constant.threshold) {
          row.add(255);
        } else {
          row.add(0);
        }
        // row.add(pixel.toList().last.toInt());
      }
      rows.add(row);
    }
    // for (var i = 0; i < rows.length; i++) {
    //   Log.d('pixels: ${rows[i]}');
    // }
    return rows;
  }

  static List<int> compressDataRows(List<List<int>> rows) {
    List<int> compressedData = [];
    for (var row in rows) {
      for (var i = 0; i < row.length; i += 8) {
        int value = 0;
        for (var j = 0; j < 8; j++) {
          if ((i + j) < row.length) {
            value = (value << 1) | (row[i + j] & 1);
          }
        }
        compressedData.add(value);
      }
    }
    return compressedData;
  }
}

enum ImageFormat { png, jpg, gif, webp }

extension ImageFormatExtension on ImageFormat {
  String get value => ['png', 'jpg', 'gif', 'webp'][index];
}
