import 'package:fluro/fluro.dart';
import 'package:flutter_yizhi/my/page/about_us_page.dart';
import 'package:flutter_yizhi/my/page/account_security_page.dart';
import 'package:flutter_yizhi/my/page/change_nickname_page.dart';
import 'package:flutter_yizhi/my/page/create_or_edit_page.dart';
import 'package:flutter_yizhi/my/page/fans_page.dart';
import 'package:flutter_yizhi/my/page/favorite_page.dart';
import 'package:flutter_yizhi/my/page/follow_page.dart';
import 'package:flutter_yizhi/my/page/history_page.dart';
import 'package:flutter_yizhi/my/page/my_create_page.dart';
import 'package:flutter_yizhi/my/page/my_device_page.dart';
import 'package:flutter_yizhi/my/page/my_info_page.dart';
import 'package:flutter_yizhi/my/page/my_search_page.dart';
import 'package:flutter_yizhi/my/page/my_setting_page.dart';
import 'package:flutter_yizhi/routers/i_router.dart';

class MyRouter implements IRouterProvider {
  static String mySettingPage = '/mySettingPage';
  static String myCreatePagee = '/myCreatePagee';
  static String createOrEditPage = '/createOrEditPage';
  static String myDevicePage = '/myDevicePage';
  static String mySearchPage = '/mySearchPage';
  static String historyPage = '/historyPage';
  static String followPage = '/followPage';
  static String fansPage = '/fansPage';
  static String favoritePage = '/favoritePage';
  static String accountSecurityPage = '/accountSecurityPage';
  static String myInfoPage = '/myInfoPage';
  static String changeNicknamePage = '/changeNicknamePage';
  static String aboutUsPage = '/aboutUsPage';

  @override
  void initRouter(FluroRouter router) {
    router.define(mySettingPage,
        handler: Handler(handlerFunc: (_, __) => const MySettingPage()));
    router.define(myCreatePagee,
        handler: Handler(handlerFunc: (_, __) => const MyCreatePagee()));
    router.define(createOrEditPage, handler: Handler(handlerFunc: (_, params) {
      String? id = params['id']?.first;
      return CreateOrEditPage(id: id);
    }));
    router.define(myDevicePage,
        handler: Handler(handlerFunc: (_, __) => const MyDevicePage()));
    router.define(mySearchPage,
        handler: Handler(handlerFunc: (_, __) => const MySearchPage()));
    router.define(historyPage,
        handler: Handler(handlerFunc: (_, __) => const HistoryPage()));
    router.define(favoritePage,
        handler: Handler(handlerFunc: (_, __) => const FavoritePage()));
    router.define(followPage,
        handler: Handler(handlerFunc: (_, __) => const FollowPage()));
    router.define(fansPage,
        handler: Handler(handlerFunc: (_, __) => const FansPage()));
    router.define(accountSecurityPage,
        handler: Handler(handlerFunc: (_, __) => const AccountSecurityPage()));
    router.define(myInfoPage,
        handler: Handler(handlerFunc: (_, __) => const MyInfoPage()));
    router.define(changeNicknamePage,
        handler: Handler(handlerFunc: (_, __) => const ChangeNicknamePage()));
    router.define(aboutUsPage,
        handler: Handler(handlerFunc: (_, __) => const AboutUsPage()));
  }
}
