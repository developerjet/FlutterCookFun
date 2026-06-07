import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/home/controller/home_controller.dart';
import 'package:flutter_cook/module/home/views/home_banner.dart';
import 'package:flutter_cook/module/home/views/home_data_cell.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tab_home_title'.tr),
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return EmptyState.loading(title: 'loading'.tr);
        }

        if (controller.errorMessage.value != null) {
          return EmptyState.error(
            title: 'load_failed'.tr,
            description: controller.errorMessage.value,
            onRetry: () => controller.retryLoadData(),
          );
        }

        final bannerData = controller.bannerData.value;
        final rawBannerList = bannerData?.data?.moduleList?.isNotEmpty == true
            ? bannerData!.data!.moduleList![0].moduleData ?? []
            : <ModuleData>[];
        final bannerList = rawBannerList.where((val) {
          final picture = val.bannerPicture?.trim();
          return picture != null && picture.isNotEmpty && picture != 'null';
        }).toList();
        final bannerImages = bannerList
            .map((val) => val.bannerPicture!.toString())
            .toList();
        final dataList = controller.listData.value?.data ?? [];

        if (dataList.isEmpty) {
          return EmptyState.empty(
            title: 'no_recipes'.tr,
            description: 'no_recipe_data'.tr,
            onRefresh: () => controller.refreshData(),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 180,
                color: Colors.white,
                child: bannerImages.isNotEmpty
                    ? CusotmCarouselSlider(
                        imageList: bannerImages,
                        onTap: (index) {
                          final banner = bannerList[index];
                          Get.toNamed('webPage', arguments: {
                            'url': banner.bannerLink,
                            'title': banner.bannerTitle,
                          });
                        },
                      )
                    : Image.asset(
                        'assets/images/banner_placeholder.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkWell(
                    child: Column(
                      children: [
                        HomeDataCell(model: dataList[index]),
                        Divider(
                          height: 0.5,
                          color: Theme.of(context).dividerColor,
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
        );
      }),
    );
  }

  _skipClassPage(HomeFoodListData data) {
    Get.toNamed('/foodClass', arguments: data);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
