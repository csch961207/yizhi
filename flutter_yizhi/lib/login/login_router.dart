import 'package:fluro/fluro.dart';
import 'package:flutter_yizhi/login/page/login_page.dart';
import 'package:flutter_yizhi/routers/i_router.dart';

class LoginRouter implements IRouterProvider {
  static String loginPage = '/login';

  @override
  void initRouter(FluroRouter router) {
    router.define(loginPage,
        handler: Handler(handlerFunc: (_, __) => const LoginPage()));
  }
}
