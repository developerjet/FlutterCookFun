import 'package:flutter/material.dart';
import 'package:flutter_cook/module/home/controller/foodClassController.dart';
import 'package:flutter_cook/module/home/model/home_model.dart';
import 'package:flutter_cook/module/home/views/home_banner.dart';
import 'package:flutter_cook/module/home/views/home_data_cell.dart';
import 'package:flutter_cook/utils/hudLoading.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/colors.dart';
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
  final List<String> bannerImages = [
    'https://pic.616pic.com/bg_w1180/00/08/72/kcTHuBFZ8R.jpg',
    'https://img.zcool.cn/community/013505591d44a6a801216a3efba7c6.jpg@2o.jpg',
    'https://img.zcool.cn/community/01447259640944a8012193a36d5ccf.jpg@1280w_1l_2o_100sh.jpg',
    'https://img.zcool.cn/community/0129e85e817f33a80121651856f72a.jpg@1280w_1l_2o_100sh.jpg',
    'https://img2.baidu.com/it/u=1544755449,2173069913&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=300',
    'https://img.zcool.cn/community/01fd5e5cfb662da801213ec286b82c.jpg@2o.jpg',
    'https://img.zcool.cn/community/012728597852faa8012193a3559f9a.jpg@2o.jpg'
  ];

  @override
  void initState() {
    super.initState();

    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    HudLoading.show('Loading...');

    Map<String, dynamic>? params = {
      'methodName': 'CategoryIndex',
      'version': '4.3.2'
    };

    final response = await DioClient.get('', queryParameters: params);

    HomeDataModel model = HomeDataModel.fromJson(response.data['data']);
    HudLoading.dismiss();

    if (model.data.length > 0) {
      //print("HomeList===$dataList");

      setState(() {
        dataList = model.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tab_home_title'.tr),
        backgroundColor: CustomColors.themeColor,
      ),
      body: CustomScrollView(
        slivers: [
          // 顶部Banner
          SliverToBoxAdapter(
            child: Container(
                height: 190,
                color: Colors.white,
                child: HomeBannerView(images: bannerImages)),
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
                      color: CustomColors.lineBoardColor(),
                    ),
                  ],
                ),onTap: () {
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
