import 'package:flutter/material.dart';
import 'package:flutter_yizhi/home/home_router.dart';
import 'package:flutter_yizhi/res/resources.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';

import '../home/home_repository.dart';
import '../net/base_entity.dart';
import '../provider/yizhi_view_model.dart';
import '../util/event_bus.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YizhiViewModel>(builder: (context, yizhiViewModel, child) {
      return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: const Color(0xffF9F9F9),
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 35, bottom: 20),
                    child: Text(
                      '选择模式',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                        fontFamily: "KaiTi",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      yizhiViewModel.setMode(0);
                      SimpleHiddenDrawerController.of(context).toggle();
                      EventBus.instance.commit(EventKeys.switchMode);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: yizhiViewModel.mode == 0
                              ? Colours.app_main
                              : const Color(0xffEFEFF0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        '海棠依旧',
                        style: TextStyle(
                          color: yizhiViewModel.mode == 0
                              ? Colors.white
                              : Colours.app_main,
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          fontFamily: "KaiTi",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        yizhiViewModel.setMode(1);
                        SimpleHiddenDrawerController.of(context).toggle();
                        EventBus.instance.commit(EventKeys.switchMode);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: yizhiViewModel.mode == 1
                                ? Colours.app_main
                                : const Color(0xffEFEFF0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          '平生未识',
                          style: TextStyle(
                            color: yizhiViewModel.mode == 1
                                ? Colors.white
                                : Colours.app_main,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                            fontFamily: "KaiTi",
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        yizhiViewModel.setMode(2);
                        SimpleHiddenDrawerController.of(context).toggle();
                        EventBus.instance.commit(EventKeys.switchMode);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: yizhiViewModel.mode == 2
                                ? Colours.app_main
                                : const Color(0xffEFEFF0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          '时刻驻足',
                          style: TextStyle(
                            color: yizhiViewModel.mode == 2
                                ? Colors.white
                                : Colours.app_main,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                            fontFamily: "KaiTi",
                          ),
                        ),
                      )),
                  const Padding(
                    padding: EdgeInsets.only(top: 35, bottom: 15),
                    child: Text(
                      '最近看过的标签',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                        fontFamily: "KaiTi",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: List.generate(
                          yizhiViewModel.myRecentTag.length,
                          (index) => GestureDetector(
                              onTap: () {
                                NavigatorUtils.push(context,
                                    '${HomeRouter.labelPage}?tag=${Uri.encodeComponent(yizhiViewModel.myRecentTag[index])}');
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '#${yizhiViewModel.myRecentTag[index]}',
                                  style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Color(0xff3A48D1),
                                      fontSize: 15),
                                ),
                              ))),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
