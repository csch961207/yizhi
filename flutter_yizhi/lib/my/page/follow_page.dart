import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:flutter_yizhi/widget/empty_widget.dart';
import 'package:flutter_yizhi/widget/load_image.dart';

import '../../net/base_entity.dart';
import '../model/person_model.dart';
import '../my_repository.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  int _page = 1;
  late EasyRefreshController _controller;
  late List<Person> list = [];

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
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
            '我的关注',
            style: TextStyle(color: Color(0xff09090B)),
          ),
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
          BaseEntity<PersonPageEntity> res =
              await MyRepository.getFollowPage(1, 10);
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
          BaseEntity<PersonPageEntity> res =
              await MyRepository.getFollowPage(_page, 10);
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
            : SizedBox(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                          children: List.generate(list.length, (index) {
                        Person item = list[index];
                        return Column(children: [
                          GestureDetector(
                              onTap: () {
                                NavigatorUtils.goAuthor(
                                    context,
                                    item.id,
                                    item.nickName,
                                    item.avatarUrl != null
                                        ? item.avatarUrl!
                                        : '');
                              },
                              child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        child: LoadImage(
                                            item.avatarUrl != null &&
                                                    item.avatarUrl!.isNotEmpty
                                                ? item.avatarUrl!
                                                : 'default-avatar',
                                            height: 30.0,
                                            width: 30.0,
                                            fit: BoxFit.fill),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(item.nickName,
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ))),
                          const SizedBox(
                            height: 1,
                          ),
                        ]);
                      }))
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
