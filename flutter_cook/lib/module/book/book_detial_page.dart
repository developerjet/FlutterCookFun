import 'package:easy_refresh/easy_refresh.dart';
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
  late int pageIndex = 1;
  late BookDetailModel detailModel;
  late List<BookDishesListModel> dataList = [];

  @override
  void initState() {
    super.initState();

    detailModel = BookDetailModel();

    HudLoading.show('Loading...');

    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    final scene_id = Get.arguments['scene_id'];

    Map<String, dynamic>? params = {
      'methodName': 'SceneInfo',
      'version': '4.3.2',
      'scene_id': scene_id,
      'page': pageIndex,
      'size': '20',
    };

    final response = await DioClient.get('', queryParameters: params);
    HudLoading.dismiss();

    detailModel = BookDetailModel.fromJson(response.data);

    setState(() {
      if (detailModel.data!.dishesList!.length > 0) {
        if (pageIndex == 1) {
          dataList = detailModel.data!.dishesList!;
        } else {
          dataList.addAll(detailModel.data!.dishesList!);
        }
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
      body: EasyRefresh(
        // 下拉刷新回调
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            pageIndex = 1;
            _fetchDetailData();
          });
        },
        // 上拉加载回调
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            pageIndex++;
            _fetchDetailData();
          });
        },
        // 控制器
        controller: EasyRefreshController(),
        // 子部件
        child: CustomScrollView(
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
                          child: Text(detailModel.data?.sceneDesc ?? "",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        )
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
                      _showPlaySheetBottom(dataList[index]);
                    },
                  );
                },
                childCount: dataList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 播放视频
  _playCookVideo(BookDishesListModel data, int playIndex) {
    final List videoList = [data.materialVideo, data.processVideo];
    Get.toNamed("player", arguments: {'url': videoList[playIndex]});
  }

  _showPlaySheetBottom(BookDishesListModel data) {
    Get.bottomSheet(Container(
      color: CustomColors.bottomSheetColor(),
      height: 200,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text("选择视频",
                textAlign: TextAlign.center,
                style: TextStyle(color: CustomColors.textMainColor())),
          ),
          ListTile(
            leading: Icon(Icons.video_call_sharp,
                color: CustomColors.textMainColor()),
            title: Text("视频1",
                style: TextStyle(color: CustomColors.textMainColor())),
            onTap: () {
              Get.back();
              _playCookVideo(data, 0);
            },
          ),
          ListTile(
            leading: Icon(Icons.video_call_sharp,
                color: CustomColors.textMainColor()),
            title: Text("视频2",
                style: TextStyle(color: CustomColors.textMainColor())),
            onTap: () {
              Get.back();
              _playCookVideo(data, 1);
            },
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
