import 'package:flutter/material.dart';
import 'package:flutter_yizhi/routers/fluro_navigator.dart';
import 'package:flutter_yizhi/util/device_utils.dart';

/// 自定义dialog的模板
class BaseDialog extends StatelessWidget {
  const BaseDialog(
      {super.key,
      this.title,
      this.onPressed,
      this.hiddenTitle = false,
      required this.child});

  final String? title;
  final VoidCallback? onPressed;
  final Widget child;
  final bool hiddenTitle;

  @override
  Widget build(BuildContext context) {
    final Widget dialogTitle = Visibility(
      visible: !hiddenTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          hiddenTitle ? '' : title ?? '',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );

    final Widget bottomButton = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () {
              NavigatorUtils.goBack(context);
            },
            child: const Text(
              '取消',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 48.0,
          width: 0.6,
          child: VerticalDivider(
            color: Color(0xffe4e4e7),
          ),
        ),
        Expanded(
            child: GestureDetector(
          onTap: () {
            onPressed!();
          },
          child: const Text(
            '确定',
            textAlign: TextAlign.center,
          ),
        )),
      ],
    );

    final Widget content = Material(
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          dialogTitle,
          Flexible(child: child),
          Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xffe4e4e7)))),
            child: bottomButton,
          ),
        ],
      ),
    );

    final Widget body = MediaQuery.removeViewInsets(
      removeLeft: true,
      removeTop: true,
      removeRight: true,
      removeBottom: true,
      context: context,
      child: Center(
        child: SizedBox(
          width: 270.0,
          child: content,
        ),
      ),
    );

    /// Android 11添加了键盘弹出动画，这与我添加的过渡动画冲突（原先iOS、Android 没有相关过渡动画，相关问题跟踪：https://github.com/flutter/flutter/issues/19279）。
    /// 因为在Android 11上，viewInsets的值在键盘弹出过程中是变化的（以前只有开始结束的值）。
    /// 所以解决方法就是在Android 11及以上系统中使用Padding代替AnimatedPadding。

    if (Device.getAndroidSdkInt() >= 30) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: body,
      );
    } else {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInCubic, // easeOutQuad
        child: body,
      );
    }
  }
}
