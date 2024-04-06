import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/home/model/data_entity.dart';
import 'package:flutter_yizhi/home/widget/home_crad.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:flutter_yizhi/widget/empty_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late EasyRefreshController _controller;
  int _page = 1;
  late List<DataEntity> list = [];

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNodeText = FocusNode();

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
    _searchController.dispose();
    _searchNodeText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: SizedBox(
            width: double.infinity,
            height: 38,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(50)),
                  child: TextField(
                    style: const TextStyle(
                      height: 1,
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 16,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colours.app_main,
                    focusNode: _searchNodeText,
                    controller: _searchController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 15),
                      hintText: '搜索内容、作者、标签',
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 25,
                ),
                GestureDetector(
                  onTap: () {
                    _controller.callRefresh();
                  },
                  child: const Text(
                    '搜索',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
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
          BaseEntity<DataPageEntity> res = await HomeRepository.getDataPage(
              1, 10,
              keyWord: _searchController.text);
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
              keyWord: _searchController.text);
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
                      list[index].isDeleted!);
                },
              ),
      ),
    );
  }
}
