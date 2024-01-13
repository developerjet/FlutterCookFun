import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:flutter_cook/utils/hudLoading.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_cook/utils/language.dart';
import '../book/views/book_home_cell.dart';
import 'package:get/get.dart';
import 'model/book_home_model.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  //请求页码
  late int pageIndex = 1;

  late List<BookListModel> dataList = [];

  @override
  void initState() {
    super.initState();

    HudLoading.show('Loading...');
    _fetchBookDataList();
  }

  Future<void> _fetchBookDataList() async {
    Map<String, dynamic>? params = {
      'methodName': 'SceneList',
      'version': '4.3.2',
      'page': pageIndex,
      'size': '20'
    };

    final response = await DioClient.get('', queryParameters: params);

    List jsonList = response.data['data']['data'];
    HudLoading.dismiss();

    if (jsonList.length > 0) {
      if (pageIndex == 1) {
        dataList = [];
      }

      List<BookListModel> tempList = [];
      for (var data in jsonList) {
        BookListModel model = BookListModel.fromJson(data);
        tempList.add(model);
      }

      setState(() {
        dataList.addAll(tempList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tab_book_title'.tr),
        backgroundColor: CustomColors.themeColor,
      ),
      body: SafeArea(
        child: EasyRefresh(
          // 下拉刷新回调
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              pageIndex = 1;
              _fetchBookDataList();
            });
          },
          // 上拉加载回调
          onLoad: () async {
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              pageIndex++;
              _fetchBookDataList();
            });
          },
          // 控制器
          controller: EasyRefreshController(),
          // 子部件
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 设置每行显示的列数
              crossAxisSpacing: 0.5, // 列间距
              mainAxisSpacing: 0.5, // 行间距
            ),
            itemCount: dataList.length, // 项数
            itemBuilder: (context, index) {
              return BookHomeCell(
                  model: dataList[index],
                  onTap: () {
                    //跳转详情
                    Map<dynamic, dynamic> arguments = {
                      'scene_id': dataList[index].sceneId,
                      'title': dataList[index].sceneTitle
                    };
                    Get.toNamed('bookDetail', arguments: arguments);
                  });
            },
          ),
        ),
      ),
    );
  }
}
