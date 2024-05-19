import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_yizhi/home/model/data_entity.dart';
import 'package:flutter_yizhi/my/model/cloud_device.dart';
import 'package:flutter_yizhi/my/my_repository.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:flutter_yizhi/widget/empty_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../util/toast_utils.dart';
import '../../widget/my_text_field.dart';

class MutualPrintingSpacePage extends StatefulWidget {
  const MutualPrintingSpacePage({super.key});

  @override
  State<MutualPrintingSpacePage> createState() =>
      _MutualPrintingSpacePageState();
}

class _MutualPrintingSpacePageState extends State<MutualPrintingSpacePage> {
  int _page = 1;
  late EasyRefreshController _controller;
  late List<CloudDeviceEntity> list = [];

  @override
  void initState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            '互印空间',
            style: TextStyle(color: Color(0xff09090B)),
          ),
          elevation: 2,
          shadowColor: Colors.black26),
      body: EasyRefresh(
          controller: _controller,
          refreshOnStart: true,
          footer: const ClassicFooter(
            dragText: '上拉加载',
            armedText: '释放开始',
            readyText: '加载中...',
            processingText: '加载中...',
            processedText: '成功了',
            noMoreText: '没有更多了,仅展示180天的记录',
            failedText: '失败了',
            messageText: '最后更新于 %T',
          ),
          refreshOnStartHeader: BuilderHeader(
            triggerOffset: 70,
            clamping: true,
            position: IndicatorPosition.above,
            processedDuration: Duration.zero,
            builder: (ctx, state) {
              if (state.mode == IndicatorMode.inactive ||
                  state.mode == IndicatorMode.done) {
                return const SizedBox();
              }
              return Container(
                color: const Color(0xFFF9F9F9),
                padding: const EdgeInsets.only(bottom: 100),
                width: double.infinity,
                height: state.viewportDimension,
                alignment: Alignment.center,
                child: const SpinKitFadingCube(
                  size: 24,
                  color: Colours.app_main,
                ),
              );
            },
          ),
          onRefresh: () async {
            BaseEntity<CloudDevicePageEntity> res =
                await MyRepository.getCloudDevicePage(1, 10);
            if (res.code != 1000) {
              Toast.show(res.message);
              return;
            }
            if (!mounted) {
              return;
            }
            setState(() {
              list = res.data!.list;
              _page = 1;
            });
            _controller.finishRefresh();
            _controller.resetFooter();
          },
          onLoad: () async {
            _page++;
            BaseEntity<CloudDevicePageEntity> res =
                await MyRepository.getCloudDevicePage(_page, 10);
            if (res.code != 1000) {
              Toast.show(res.message);
              return;
            }
            if (!mounted) {
              return;
            }
            setState(() {
              list.addAll(res.data!.list);
            });
            _controller.finishLoad(list.length >= res.data!.pagination.total
                ? IndicatorResult.noMore
                : IndicatorResult.success);
          },
          child: list.isEmpty
              ? const EmptyWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: List.generate(list.length, (index) {
                      CloudDeviceEntity item = list[index];
                      return GestureDetector(
                        onTap: () {
                          NavigatorUtils.push(context,
                              '${MyRouter.cloudDevicePage}?deviceName=${item.deviceName}&nickName=${Uri.encodeComponent(item.nickName)}');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xffe4e4e7),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    item.title,
                                    maxLines: 11,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Color(0xff09090B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                        '${item.nickName}的设备',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Color(0xff717179),
                                            fontSize: 14),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFF52C41A),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                        ),
                                        // BFBFBF
                                        Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Text(
                                            '在线',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Color(0xff09090B),
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Provider.of<YizhiViewModel>(context, listen: false)
                  .writeCharacteristic !=
              null
          ? FloatingActionButton(
              backgroundColor: Colours.app_main,
              onPressed: () async {
                NavigatorUtils.push(context, MyRouter.cloudOnDevicePage);
              },
              tooltip: '设备上云', //蓝牙配网
              shape: const CircleBorder(),
              child: const Icon(
                Icons.cloud_upload,
                color: Colors.white,
              ),
            )
          : const SizedBox(),
    );
  }
}
