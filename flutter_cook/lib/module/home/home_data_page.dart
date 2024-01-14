import 'package:flutter/material.dart';
import 'package:flutter_cook/module/home/controller/foodClassController.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/home/views/home_banner.dart';
import 'package:flutter_cook/module/home/views/home_data_cell.dart';
import 'package:flutter_cook/utils/hudLoading.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 数据
  late List<HomeFoodListData> dataList = [];

  // 实例化控制器
  FoodDataController classController = Get.find<FoodDataController>();

  // banner数据
  late List<String> bannerImages = [];
  late List<ModuleData>? moduleDataList = [];

  @override
  void initState() {
    super.initState();

    _handlerThemeMode();

    HudLoading.show('Loading...');
    _fetchBannerData();
    _fetchHomeListData();
  }

  Future<void> _handlerThemeMode() async {
    int lastTheme = await ThemeManager.fetchLastTheme() ?? 0;
    ThemeManager.saveTheme(lastTheme);
  }

  Future<void> _fetchHomeListData() async {
    Map<String, dynamic>? params = {
      'methodName': 'CategoryIndex',
      'version': '4.3.2'
    };

    final response = await DioClient.get('', queryParameters: params);

    HomeDataModel model = HomeDataModel.fromJson(response.data['data']);
    HudLoading.dismiss();

    if (model.data.length > 0) {
      setState(() {
        dataList = model.data;
      });
    }
  }

  Future<void> _fetchBannerData() async {
    Map<String, dynamic>? params = {
      'devModel': 'iPhone',
      'sysVersion': '16.7.2',
      'appVersion': '5.61',
      'version': '5.61',
      'methodName': 'HomePage',
      'token': '0',
      'user_id': '0',
      'page': '4'
    };

    final response = await DioClient.get('', queryParameters: params);

    HomeBannerModel model = HomeBannerModel.fromJson(response.data);
    HudLoading.dismiss();

    if (model.data!.moduleList!.length > 0) {
      moduleDataList = model.data!.moduleList![0].moduleData;

      Iterable<String> images =
          moduleDataList!.map((val) => val.bannerPicture.toString());

      setState(() {
        bannerImages.addAll(images);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tab_home_title'.tr),
        backgroundColor: ThemeManager.themeColor,
        actions: [
          IconButton(
            icon: Image.asset('assets/images/search_white.png',
                width: 25, height: 25),
            onPressed: () {
              //搜索页面
              Get.toNamed('/search');
            },
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 顶部Banner
          SliverToBoxAdapter(
            child: Container(
                height: 190,
                color: Colors.white,
                child: HomeBannerView(
                  images: bannerImages,
                  onTap: (index) {
                    ModuleData banner = moduleDataList![index];
                    // 跳转webView
                    Get.toNamed('webPage', arguments: {
                      'url': banner.bannerLink,
                      'title': banner.bannerTitle
                    });
                  },
                )),
          ),
          // 列表数据
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return InkWell(
                  child: Column(
                    children: [
                      HomeDataCell(model: dataList[index]),
                      Divider(
                        height: 0.5, // 分割线的高度
                        color: ThemeManager.lineBoardColor(),
                      ),
                    ],
                  ),
                  onTap: () {
                    _skipClassPage(dataList[index]);
                  },
                );
              },
              childCount: dataList.length,
            ),
          ),
        ],
      ),
    );
  }

  _skipClassPage(HomeFoodListData data) {
    classController.foodData = data;

    // 路由跳转
    Get.toNamed('/foodClass');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
