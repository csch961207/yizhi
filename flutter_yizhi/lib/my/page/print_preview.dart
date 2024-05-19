import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../util/toast_utils.dart';
import '../../widget/my_text_field.dart';

class PrintPreviewPage extends StatefulWidget {
  const PrintPreviewPage({super.key});

  @override
  State<PrintPreviewPage> createState() => _PrintPreviewPageState();
}

class _PrintPreviewPageState extends State<PrintPreviewPage> {
  final TextEditingController _printContentController = TextEditingController();
  final FocusNode _printNodeText = FocusNode();

  final ImagePicker _picker = ImagePicker();
  ImageProvider? _imageProvider;
  double imageHeight = 384 * 1.41;

  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // getImageSize();
  }

  @override
  void dispose() {
    super.dispose();
    _printContentController.dispose();
    _printNodeText.dispose();
  }

  // void getImageSize() {
  //   final ImageStream? stream =
  //       _imageProvider?.resolve(ImageConfiguration.empty);
  //   stream?.addListener((ImageInfo image, bool synchronousCall) {
  //     print('stream');
  //     setState(() {
  //       imageHeight = image.image.height.toDouble();
  //     });
  //   } as ImageStreamListener);
  // }

  // Future<Uint8List?> _captureImage() async {
  //   try {
  //     RenderRepaintBoundary boundary = _globalKey.currentContext
  //         ?.findRenderObject() as RenderRepaintBoundary;
  //     var image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //     return pngBytes;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> _saveImage(Uint8List imageBytes) async {
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   final imagePath = '$directory/flutter.png';

  //   File imageFile = File(imagePath);
  //   imageFile.writeAsBytesSync(imageBytes);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text(
              '打印预览',
              style: TextStyle(color: Color(0xff09090B)),
            ),
            elevation: 2,
            shadowColor: Colors.black26),
        body: Column(children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: MyTextField(
                      hintText: '打印内容',
                      minLines: 5,
                      maxLines: 5,
                      nodeText: _printNodeText,
                      controller: _printContentController,
                    ),
                  ),
                  // Container(
                  //             width: 384,
                  //             height: imageHeight,
                  //             decoration: BoxDecoration(
                  //               color: Colors.blue,
                  //               // 图片圆角展示
                  //               image: DecorationImage(
                  //                   image: _imageProvider!,
                  //                   fit: BoxFit.fitWidth,
                  //                   colorFilter: const ColorFilter.mode(
                  //                       Colors.grey, BlendMode.color)),
                  //             ),
                  //           )
                  // _imageProvider != null
                  //     ? Container(
                  //         padding: const EdgeInsets.all(5),
                  //         child: RepaintBoundary(
                  //           key: _globalKey,
                  //           child: Image(
                  //             width: 384,
                  //             image: _imageProvider!,
                  //             fit: BoxFit.fitWidth,
                  //             colorBlendMode: BlendMode.color,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // GestureDetector(
                  //     onTap: () {},
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width * 0.9,
                  //       padding: const EdgeInsets.all(15),
                  //       alignment: Alignment.center,
                  //       decoration: const BoxDecoration(
                  //           color: Color(0xffEFEFF0),
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(10))),
                  //       child: const Text(
                  //         '打印文本',
                  //         style: TextStyle(
                  //           color: Colours.app_main,
                  //           fontSize: 18,
                  //           decoration: TextDecoration.none,
                  //           fontFamily: "KaiTi",
                  //         ),
                  //       ),
                  //     )),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // GestureDetector(
                  //     onTap: () async {
                  //       XFile? file = await _picker.pickImage(
                  //           source: ImageSource.gallery);
                  //       if (file != null) {
                  //         setState(() {
                  //           _imageProvider = FileImage(File(file.path));
                  //         });

                  //         print('------------------------');
                  //         print(_imageProvider.toString());
                  //         print(file.path);
                  //         print('------------------------');
                  //       } else {
                  //         setState(() {
                  //           _imageProvider = null;
                  //         });
                  //       }
                  //     },
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width * 0.9,
                  //       padding: const EdgeInsets.all(15),
                  //       alignment: Alignment.center,
                  //       decoration: const BoxDecoration(
                  //           color: Color(0xffEFEFF0),
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(10))),
                  //       child: const Text(
                  //         '打印图片',
                  //         style: TextStyle(
                  //           color: Colours.app_main,
                  //           fontSize: 18,
                  //           decoration: TextDecoration.none,
                  //           fontFamily: "KaiTi",
                  //         ),
                  //       ),
                  //     )),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
            child: GestureDetector(
              onTap: () async {
                if (_printContentController.text.isEmpty) {
                  Toast.show('内容不能为空');
                  return;
                }
                // Uint8List? imageBytes = await _captureImage();
                // _saveImage(imageBytes!);
                OverlayEntry overlayEntry = Toast.showLoading(context);
                try {
                  await Provider.of<YizhiViewModel>(context, listen: false)
                      .startPrint(_printContentController.text);
                  if (mounted) {
                    await Provider.of<YizhiViewModel>(context, listen: false)
                        .finishPrint();
                  }
                  overlayEntry.remove();
                  Toast.show('下发完成');
                } catch (e) {
                  overlayEntry.remove();
                  Toast.show('请检查连接设备');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colours.app_main,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: const Text(
                  '打印',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    fontFamily: "KaiTi",
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}
