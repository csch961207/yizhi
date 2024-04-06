import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_yizhi/l10n/l10n.dart';
import 'package:flutter_yizhi/net/intercept.dart';
import 'package:flutter_yizhi/net/net.dart';
import 'package:flutter_yizhi/provider/app_provider.dart';
import 'package:flutter_yizhi/provider/yizhi_view_model.dart';
import 'package:flutter_yizhi/res/colors.dart';
import 'package:flutter_yizhi/res/constant.dart';
import 'package:flutter_yizhi/routers/routers.dart';
import 'package:flutter_yizhi/tab_navigator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_yizhi/util/device_utils.dart';
import 'package:flutter_yizhi/util/handle_error_utils.dart';
import 'package:flutter_yizhi/util/log_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

Future<void> main() async {
  /// 异常处理
  handleError(() async {
    /// 确保初始化完成
    WidgetsFlutterBinding.ensureInitialized();
    initialization(null);

    /// sp初始化
    await SpUtil.getInstance();

    /// 1.22 预览功能: 在输入频率与显示刷新率不匹配情况下提供平滑的滚动效果
    // GestureBinding.instance?.resamplingEnabled = true;
    runApp(MyApp());
  });
}

//启动图延时移除方法
void initialization(BuildContext? context) async {
  //延迟3秒
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    Log.init();
    initDio();
    Routes.initRoutes();
    Device.initDeviceInfo();
    EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
          dragText: '下拉刷新',
          armedText: '释放开始',
          readyText: '刷新中...',
          processingText: '刷新中...',
          processedText: '成功了',
          noMoreText: '没有更多',
          failedText: '失败了',
          messageText: '最后更新于 %T',
        );
    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
          dragText: '上拉加载',
          armedText: '释放开始',
          readyText: '加载中...',
          processingText: '加载中...',
          processedText: '成功了',
          noMoreText: '没有更多',
          failedText: '失败了',
          messageText: '最后更新于 %T',
        );
  }

  void initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    /// 刷新Token
    interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    // interceptors.add(AdapterInterceptor());
    configDio(
      baseUrl: Constant.baseUrl,
      interceptors: interceptors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget app = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => YizhiViewModel()),
      ],
      child: Consumer<AppProvider>(
        builder: (_, AppProvider provider, __) {
          return _buildMaterialApp();
        },
      ),
    );

    /// Toast 配置
    return OKToast(
        backgroundColor: Colours.app_main,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        radius: 4.0,
        position: ToastPosition.bottom,
        child: app);
  }

  Widget _buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '一枝',
      theme: ThemeData(
        fontFamily: "KaiTi",
        colorScheme: ColorScheme.fromSeed(
            primary: const Color(0xFF18181B),
            seedColor: Colors.white,
            background: const Color(0xFFF9F9F9)),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), //设置语言为中文
      ],
      locale: const Locale('zh', 'CN'),
      home: const TabNavigator(),
    );
  }
}
