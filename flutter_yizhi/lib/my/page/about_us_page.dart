import 'package:flutter/material.dart';
import 'package:flutter_yizhi/res/colors.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            '关于我们',
            style: TextStyle(color: Color(0xff09090B)),
          ),
          elevation: 2,
          shadowColor: Colors.black26),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: const Column(children: [
            Text(
              '一枝，这是一个的开源作品，名字取自阅尽好花千万树，愿君记取此一枝。',
              style:
                  TextStyle(fontSize: 17, color: Colours.app_main, height: 1.5),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '本软件所有详细信息会跳转到分享的网页地址访问，不做任何转码类操作，正文内容不做任何抓取存储，如果侵犯您的权益，请与我们联系,我们会尽快处理。同时请注意原网站的观点不表示我们也认同，信息内容真实性请已辨别。',
              style:
                  TextStyle(fontSize: 17, color: Colours.app_main, height: 1.5),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '本软件不保证任何来自第三方网站的信内容或者广告宣传等信息(以下统称“信元息”)的真实、准确和完整性，对于因与第三方网站进行任何行为而发生的任何直接、间接、附带或衍生的损失和责任，本站一概不负担。请自行对信息甄别真伪，永远保持警惕。',
              style:
                  TextStyle(fontSize: 17, color: Colours.app_main, height: 1.5),
            )
          ]),
        ),
      ),
    );
  }
}
