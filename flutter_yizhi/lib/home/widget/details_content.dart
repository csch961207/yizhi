import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/toast_utils.dart';

import '../../widget/load_image.dart';

class DetailsContent extends StatefulWidget {
  const DetailsContent(
      this.title, this.url, this.avatarUrl, this.author, this.urlTitle,
      {Key? key})
      : super(key: key);

  final String title;
  final String? url;
  final String avatarUrl;
  final String author;
  final String? urlTitle;

  @override
  DetailsContentState createState() {
    return DetailsContentState();
  }
}

class DetailsContentState extends State<DetailsContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getFaviconUrl(String url) {
    Uri uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}/favicon.ico';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4), topRight: Radius.circular(4)),
      ),
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(widget.title),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Text(
                widget.author,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Colours.app_main,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
              const SizedBox(
                width: 10,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: LoadImage(
                    widget.avatarUrl.isNotEmpty
                        ? widget.avatarUrl
                        : 'default-avatar',
                    height: 35.0,
                    width: 35.0,
                    fit: BoxFit.fill),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          widget.url != ''
              ? Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xffe4e4e7),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: LoadImage(getFaviconUrl(widget.url!),
                            height: 20.0, width: 20.0, fit: BoxFit.fill),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.urlTitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            widget.url!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color(0xff717179),
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ],
                      )),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          try {
                            Clipboard.setData(ClipboardData(text: widget.url!));
                            Toast.show('复制成功');
                          } catch (e) {
                            Toast.show(e.toString());
                          }
                        },
                        child: const Icon(Icons.content_copy),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }
}
