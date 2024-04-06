import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_yizhi/home/home_repository.dart';
import 'package:flutter_yizhi/home/model/data_entity.dart';
import 'package:flutter_yizhi/home/widget/home_crad.dart';
import 'package:flutter_yizhi/net/base_entity.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';
import 'package:flutter_yizhi/widget/empty_widget.dart';

class LabelPage extends StatefulWidget {
  const LabelPage({super.key, required this.tag});
  final String tag;

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  int _hotPage = 1;
  late List<DataEntity> hotList = [];
  int _newPage = 1;
  late List<DataEntity> newList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _init();
  }

  void _init() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await onHotListRefresh();
      await onNewListRefresh();
      setState(() {
        _isLoading = false;
      });
    } catch (e, s) {
      print(e);
      print(s);
      setState(() {
        _isLoading = false;
      });
    }
  }

  onHotListRefresh() async {
    BaseEntity<DataPageEntity> res =
        await HomeRepository.getTagPage(1, 10, sort: 0, tag: widget.tag);
    if (res.code != 1000) {
      Toast.show(res.message);
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      hotList = res.data!.list;
      _hotPage = 1;
    });
  }

  onNewListRefresh() async {
    BaseEntity<DataPageEntity> res =
        await HomeRepository.getTagPage(1, 10, sort: 1, tag: widget.tag);
    if (res.code != 1000) {
      Toast.show(res.message);
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      newList = res.data!.list;
      _newPage = 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Container(
              color: const Color(0xFFF9F9F9),
              padding: const EdgeInsets.only(bottom: 100),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: const SpinKitFadingCube(
                size: 24,
                color: Colours.app_main,
              ),
            )
          : ExtendedNestedScrollView(
              onlyOneScrollInBody: true,
              pinnedHeaderSliverHeightBuilder: () {
                return MediaQuery.of(context).padding.top + kToolbarHeight;
              },
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    iconTheme: const IconThemeData(color: Colours.app_main),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    expandedHeight: 120,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        widget.tag,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleLarge?.color),
                      ),
                      centerTitle: false,
                    ),
                  ),
                ];
              },
              body: Column(
                children: <Widget>[
                  TabBar(
                    controller: _tabController,
                    labelColor: themeData.colorScheme.primary,
                    indicatorColor: themeData.colorScheme.primary,
                    onTap: (index) {
                      setState(() {
                        _tabIndex = index;
                      });
                    },
                    tabs: const <Widget>[
                      Tab(
                        text: '最热',
                      ),
                      Tab(
                        text: '最新',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        EasyRefresh(
                          child: !_isLoading && hotList.isEmpty
                              ? const EmptyWidget()
                              : MasonryGridView.count(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 5, right: 5),
                                  itemCount: hotList.length,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  itemBuilder: (context, index) {
                                    return HomeCard(
                                      hotList[index].id,
                                      hotList[index].title,
                                      hotList[index].userName,
                                      hotList[index].tagList,
                                      hotList[index].isDeleted!,
                                    );
                                  },
                                ),
                          onRefresh: () async {
                            onHotListRefresh();
                          },
                          onLoad: () async {
                            _hotPage++;
                            BaseEntity<DataPageEntity> res =
                                await HomeRepository.getTagPage(_hotPage, 10,
                                    sort: 0, tag: widget.tag);
                            if (res.code != 1000) {
                              Toast.show(res.message);
                              return;
                            }
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              hotList.addAll(res.data!.list);
                            });
                          },
                        ),
                        EasyRefresh(
                          child: !_isLoading && newList.isEmpty
                              ? const EmptyWidget()
                              : MasonryGridView.count(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 5, right: 5),
                                  itemCount: newList.length,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  itemBuilder: (context, index) {
                                    return HomeCard(
                                      newList[index].id,
                                      newList[index].title,
                                      newList[index].userName,
                                      newList[index].tagList,
                                      newList[index].isDeleted!,
                                    );
                                  },
                                ),
                          onRefresh: () async {
                            onNewListRefresh();
                          },
                          onLoad: () async {
                            _newPage++;
                            BaseEntity<DataPageEntity> res =
                                await HomeRepository.getTagPage(_newPage, 10,
                                    sort: 1, tag: widget.tag);
                            if (res.code != 1000) {
                              Toast.show(res.message);
                              return;
                            }
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              newList.addAll(res.data!.list);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
