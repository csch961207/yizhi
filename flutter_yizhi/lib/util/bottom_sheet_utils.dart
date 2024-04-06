import 'package:flutter/material.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';

class BottomSheetUtils {
  static showBottomSheet(BuildContext context, Widget widget,
      {double height = 200}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,

      /// 使用true则高度不受16分之9的最高限制
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: height,
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget,
              InkWell(
                onTap: () {
                  NavigatorUtils.goBack(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(13),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Color.fromRGBO(240, 240, 240, 1),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '取消',
                        style: TextStyle(
                            fontSize: 17, color: Color.fromRGBO(93, 92, 92, 1)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
