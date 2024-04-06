import 'package:flutter/material.dart';
import 'package:flutter_yizhi/my/my_router.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/other_utils.dart';
import 'package:flutter_yizhi/widget/base_dialog.dart';

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
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
            '账号安全',
            style: TextStyle(color: Color(0xff09090B)),
          ),
          elevation: 2,
          shadowColor: Colors.black26),
      body: Column(
        children: <Widget>[
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  NavigatorUtils.push(context, MyRouter.myInfoPage);
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('个人信息'),
                      ],
                    )),
              ),
              const SizedBox(
                width: double.infinity,
                height: 0.6,
              ),
              GestureDetector(
                onTap: () {
                  showElasticDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return BaseDialog(
                          title: '提示',
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 28.0),
                            child:
                                Text("你确定要注销账户吗？", textAlign: TextAlign.center),
                          ),
                          onPressed: () async {
                            NavigatorUtils.goBack(context);
                          },
                        );
                      });
                },
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('注销账户'),
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
