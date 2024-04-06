import 'package:fluro/fluro.dart';
import 'package:flutter_yizhi/home/page/author_page.dart';
import 'package:flutter_yizhi/home/page/details_page.dart';
import 'package:flutter_yizhi/home/page/label_page.dart';
import 'package:flutter_yizhi/home/page/search_page.dart';
import 'package:flutter_yizhi/routers/i_router.dart';

class HomeRouter implements IRouterProvider {
  static String labelPage = '/labelPage';
  static String searchPage = '/searchPage';
  static String detailsPage = '/detailsPage';
  static String authorPage = '/authorPage';

  @override
  void initRouter(FluroRouter router) {
    router.define(labelPage, handler: Handler(handlerFunc: (_, params) {
      String? tag = params['tag']?.first;
      return LabelPage(tag: tag!);
    }));
    router.define(authorPage, handler: Handler(handlerFunc: (_, params) {
      String? userId = params['userId']?.first;
      String? author = params['author']?.first;
      String? avatar = params['avatar']?.first;
      return AuthorPage(
        userId: int.parse(userId!),
        author: author!,
        avatar: avatar!,
      );
    }));
    router.define(searchPage,
        handler: Handler(handlerFunc: (_, __) => const SearchPage()));
    router.define(detailsPage, handler: Handler(handlerFunc: (_, params) {
      String? id = params['id']?.first;
      return DetailsPage(id: id!);
    }));
  }
}
