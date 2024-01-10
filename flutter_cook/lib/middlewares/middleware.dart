import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// 路由鉴权
class AppMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print("-------$route-------");
    // return null;  //不做任何操作

    //没有权限跳转到登录页面
    return const RouteSettings(name: "/login", arguments: {});
  }
}
