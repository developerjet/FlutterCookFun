import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/language.dart';
import '../book/views/book_home_cell.dart';
import 'package:get/get.dart';
import 'model/book_model.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late List<BookListModel> dataList = [];

  @override
  void initState() {
    super.initState();

    _fetchBookData();
  }

  Future<void> _fetchBookData() async {
    Map<String, dynamic>? params = {
      'methodName': 'SceneList',
      'version': '4.3.2',
      'page': '1',
      'size': '20'
    };

    final response = await DioClient.get('', queryParameters: params);

    List jsonList = response.data['data']['data'];

    if (jsonList.length > 0) {
      List<BookListModel> tempList = [];
      for (var data in jsonList) {
        BookListModel model = BookListModel.fromJson(data);
        tempList.add(model);
      }

      //print("BookList===$tempList");

      setState(() {
        dataList = tempList;
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
          child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 设置每行显示的列数
          crossAxisSpacing: 0.5, // 列间距
          mainAxisSpacing: 0.5, // 行间距
        ),
        itemCount: dataList.length, // 项数
        itemBuilder: (context, index) {
          return BookHomeCell(model: dataList[index]);
        },
      )),
    );
  }
}
