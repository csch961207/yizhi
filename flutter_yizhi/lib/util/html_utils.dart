import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class HtmlUtils {
  // static Future<Map<String, String>> getTitleAndFavicon(String url) async {
  //   Dio dio = Dio();
  //   Response response = await dio.get(url);
  //   Document document = parse(response.data);
  //   String title = document.head!.querySelector('title')!.text;
  //
  //   final metaIcons = document.querySelectorAll('link');
  //   final iconLink =
  //       metaIcons.firstWhere((link) => link.attributes['rel'] == 'icon');
  //
  //   String? favicon = iconLink.attributes['href'];
  //
  //   return {'title': title, 'favicon': favicon!};
  // }
}
