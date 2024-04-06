import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/home/widget/home_crad.dart';
import 'package:flutter_yizhi/my/my_repository.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/event_bus.dart';
import 'package:flutter_yizhi/util/other_utils.dart';
import 'package:flutter_yizhi/widget/base_dialog.dart';
import 'package:flutter_yizhi/widget/empty_widget.dart';

import '../../home/model/data_entity.dart';
import '../../net/base_entity.dart';
import '../../util/toast_utils.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _page = 1;
  late EasyRefreshController _controller;
  late List<DataEntity> list = [];

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    EventBus.instance.addListener(EventKeys.refresh, () {
      _controller.callRefresh(force: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    EventBus.instance.removeListener(EventKeys.refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            '我的收藏',
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
          BaseEntity<DataPageEntity> res =
              await MyRepository.getMyCollectPage(1, 10);
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
          BaseEntity<DataPageEntity> res =
              await MyRepository.getMyCollectPage(_page, 10);
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
            : MasonryGridView.count(
                padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                itemCount: list.length,
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onLongPress: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,

                          /// 使用true则高度不受16分之9的最高限制
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 115,
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        showElasticDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return BaseDialog(
                                                title: '提示',
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 28.0),
                                                  child: Text("你确定要取消收藏吗？",
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                onPressed: () async {
                                                  NavigatorUtils.goBack(
                                                      context);
                                                  OverlayEntry overlayEntry =
                                                      Toast.showLoading(
                                                          context);
                                                  try {
                                                    BaseEntity<bool> res =
                                                        await HomeRepository
                                                            .like(
                                                                list[index].id);
                                                    overlayEntry.remove();
                                                    if (res.code == 1000) {
                                                      Toast.show('取消成功');
                                                      _controller.callRefresh();
                                                    } else {
                                                      Toast.show(res.message);
                                                    }
                                                  } catch (e) {
                                                    overlayEntry.remove();
                                                    Toast.show('取消失败');
                                                  }
                                                },
                                              );
                                            });
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            alignment: Alignment.center,
                                            height: 55,
                                            child: const Text(
                                              '移除收藏',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16),
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    color: const Color(0xFFf5f5f5),
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            alignment: Alignment.center,
                                            height: 50,
                                            child: const Text(
                                              '取消',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: HomeCard(
                          list[index].id,
                          list[index].title,
                          list[index].userName,
                          list[index].tagList,
                          list[index].isDeleted!));
                },
              ),
      ),
    );
  }
}
