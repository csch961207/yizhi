import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_yizhi/home/home_router.dart';
import 'package:flutter_yizhi/home/widget/home_crad.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:flutter_yizhi/widget/empty_widget.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

import '../../net/base_entity.dart';
import '../../util/event_bus.dart';
import '../../util/toast_utils.dart';
import '../../provider/yizhi_view_model.dart';
import '../home_repository.dart';
import '../model/data_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.controller});

  final SimpleHiddenDrawerController controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late EasyRefreshController _controller;
  int _page = 1;
  late List<DataEntity> list = [];

  ValueNotifier mode = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    EventBus.instance.addListener(EventKeys.switchMode, () {
      _controller.callRefresh(force: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    EventBus.instance.removeListener(EventKeys.switchMode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<YizhiViewModel>(builder: (context, yizhiViewModel, child) {
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: GestureDetector(
                onTap: () async {
                  await yizhiViewModel.getMyRecentTag();
                  widget.controller.toggle();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image(
                    image: ImageUtils.getAssetImage('home-setting'),
                    width: 24.0,
                    height: 24.0,
                    // color: Colors.grey,
                  ),
                ),
              ),
              leadingWidth: 40,
              title: Text(
                yizhiViewModel.modeStr,
                style: const TextStyle(
                    fontSize: 21,
                    color: Color(0xff09090B),
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.push(context, HomeRouter.searchPage);
                  },
                  child: Image(
                    image: ImageUtils.getAssetImage('search'),
                    width: 23.0,
                    height: 23.0,
                    // color: Colors.grey,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 15))
              ],
              elevation: 2,
              shadowColor: Colors.black26),
          body: EasyRefresh(
            controller: _controller,
            refreshOnStart: true,
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
              BaseEntity<DataPageEntity> res = await HomeRepository.getDataPage(
                  1, 10,
                  mode: yizhiViewModel.mode);
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
              BaseEntity<DataPageEntity> res = await HomeRepository.getDataPage(
                  _page, 10,
                  mode: yizhiViewModel.mode);
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
                      return HomeCard(
                        list[index].id,
                        list[index].title,
                        list[index].userName,
                        list[index].tagList,
                        list[index].isDeleted!,
                      );
                    },
                  ),
          ));
    });
  }
}
