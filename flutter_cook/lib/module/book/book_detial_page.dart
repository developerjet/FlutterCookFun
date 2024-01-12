import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/module/book/views/book_detial_cell.dart';
import 'package:flutter_cook/utils/hudLoading.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({Key? key}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late BookDetailModel detailModel;
  late List<BookDishesListModel> dataList = [];

  @override
  void initState() {
    super.initState();

    detailModel = BookDetailModel();

    HudLoading.show('Loading...');

    _fetchDetialData();
  }

  Future<void> _fetchDetialData() async {
    final scene_id = Get.arguments['scene_id'];

    Map<String, dynamic>? params = {
      'methodName': 'SceneInfo',
      'version': '4.3.2',
      'scene_id': scene_id,
      'page': '1',
      'size': '50',
    };

    final response = await DioClient.get('', queryParameters: params);
    HudLoading.dismiss();

    setState(() {
      detailModel = BookDetailModel.fromJson(response.data);

      if (detailModel.data!.dishesList!.length > 0) {
        dataList = detailModel.data!.dishesList!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments['title']),
        backgroundColor: CustomColors.themeColor,
      ),
      body: CustomScrollView(
        slivers: [
          // 顶部Banner
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: Column(
                children: [
                  Stack(
                    children: [
                      GFImageOverlay(
                        height: 200,
                        image: NetworkImage(
                            detailModel.data?.sceneBackground ?? ''),
                        boxFit: BoxFit.fill, //填充模式
                      ),
                      Center(
                          heightFactor: 5,
                          child: Text(
                            detailModel.data?.sceneTitle ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 21),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
          // 列表数据
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return InkWell(
                  child: Column(
                    children: [
                      BookDetialCell(model: dataList[index]),
                      Divider(
                        height: 0.5, // 分割线的高度
                        color: CustomColors.lineBoardColor(),
                      ),
                    ],
                  ),
                  onTap: () {
                    _playCookVideo(dataList[index]);
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

  // 播放视频
  _playCookVideo(BookDishesListModel data) {
    Map<String, dynamic>? arguments = {
      'materialVideo': data.materialVideo,
      'processVideo': data.processVideo
    };

    Get.toNamed("player", arguments: arguments);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
