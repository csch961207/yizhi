import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yizhi/home/home_router.dart';
import 'package:flutter_yizhi/login/login_router.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/routers/i_router.dart';
import 'package:flutter_yizhi/routers/not_found_page.dart';
import 'package:flutter_yizhi/tab_navigator.dart';
import 'package:flutter_yizhi/webview_page.dart';

class Routes {
  static String home = "/home";

  static String webViewPage = '/webView';

  static final List<IRouterProvider> _listRouter = [];

  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      debugPrint('未找到目标页');
      return const NotFoundPage();
    });

    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      final String title = params['title']?.first ?? '';
      final String url = params['url']?.first ?? '';
      return WebViewPage(title: title, url: url);
    }));

    router.define(home, handler: Handler(handlerFunc: (_, params) {
      return const TabNavigator();
    }));

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化
    _listRouter.add(LoginRouter());
    _listRouter.add(HomeRouter());
    _listRouter.add(MyRouter());

    /// 初始化路由
    void initRouter(IRouterProvider routerProvider) {
      routerProvider.initRouter(router);
    }

    _listRouter.forEach(initRouter);
  }
}
