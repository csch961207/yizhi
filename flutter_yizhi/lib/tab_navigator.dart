import 'package:flutter/material.dart';
import 'package:flutter_yizhi/home/page/home_page.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/my/page/my_page.dart';
import 'package:flutter_yizhi/res/resources.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/event_bus.dart';
import 'package:flutter_yizhi/util/image_utils.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'login/login_router.dart';
import 'widget/home_menu.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _pageController = PageController();
  int _selectedIndex = 0;
  late DateTime _lastPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
        isDraggable: false,
        verticalScalePercent: 100,
        contentCornerRadius: 20,
        menu: const HomeMenu(), //抽屉区域布局
        screenSelectedBuilder: (position, controller) {
          return Scaffold(
            body: WillPopScope(
              onWillPop: () async {
                if (DateTime.now().difference(_lastPressed) >
                    const Duration(seconds: 1)) {
                  //两次点击间隔超过1秒则重新计时
                  _lastPressed = DateTime.now();
                  return false;
                }
                return true;
              },
              child: PageView.builder(
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return HomePage(controller: controller);
                  } else {
                    return const MyPage();
                  }
                },
                itemCount: 2,
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index == 0 ? 0 : 2;
                  });
                },
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colours.app_main,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image(
                    image: ImageUtils.getAssetImage('home'),
                    width: 24.0,
                    height: 24.0,
                    // color: Colors.grey,
                  ),
                  activeIcon: Image(
                    image: ImageUtils.getAssetImage('home-fill'),
                    width: 24.0,
                    height: 24.0,
                  ),
                  label: '首页',
                  tooltip: '首页',
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: ImageUtils.getAssetImage('add'),
                    width: 22.0,
                    height: 22.0,
                  ),
                  activeIcon: Image(
                    image: ImageUtils.getAssetImage('add'),
                    width: 22.0,
                    height: 22.0,
                  ),
                  label: '添加',
                  tooltip: '添加',
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: ImageUtils.getAssetImage('user'),
                    width: 24.0,
                    height: 24.0,
                    // color: Colors.grey,
                  ),
                  activeIcon: Image(
                    image: ImageUtils.getAssetImage('user-fill'),
                    width: 24.0,
                    height: 24.0,
                  ),
                  label: '我的',
                  tooltip: '我的',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index == 1) {
                  NavigatorUtils.push(context, MyRouter.createOrEditPage);
                } else {
                  _pageController.jumpToPage(index == 0 ? 0 : 1);
                }
              },
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    EventBus.instance.addListener(EventKeys.logout, () {
      // 移除事件监听
      EventBus.instance.removeListener(EventKeys.logout);
      // 跳转登录页面
      NavigatorUtils.push(context, LoginRouter.loginPage);
    });
  }

  @override
  void dispose() {
    // 移除事件监听
    EventBus.instance.removeListener(EventKeys.logout);
    super.dispose();
  }
}
