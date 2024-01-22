import 'package:flutter/material.dart';
import 'package:flutter_cook/module/search/model/search_data_model.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _focusNode = FocusNode();
  late List<SearchDataListModel> dataList = [];

  //历史搜素
  late List<String> _historyList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchSearchData(String keyword) async {
    if (keyword.length == 0) {
      setState(() {
        dataList = [];
      });
      return;
    }

    Map<String, dynamic>? params = {
      'devModel': 'iPhone',
      'sysVersion': '16.7.2',
      'appVersion': '5.61',
      'version': '5.61',
      'keyword': keyword,
      'methodName': 'SearchKeyword',
      'token': '0',
      'user_id': '0',
    };

    final response = await DioClient.get('', queryParameters: params);
    SearchDataModel model = SearchDataModel.fromJson(response.data['data']);

    if (model.data!.length > 0) {
      setState(() {
        dataList = model.data!;
      });
    }
  }

  _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _historyList = prefs.getStringList('search_history') ?? [];
    });
  }

  _saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('search_history', _historyList);
  }

  _addToHistory(String keyword) {
    setState(() {
      if (!_historyList.contains(keyword)) {
        _historyList.insert(0, keyword);
        _saveSearchHistory();
      }
    });
  }

  _clearHistory() {
    setState(() {
      _historyList.clear();
      _saveSearchHistory();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: 88,
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 40,
                          child: TextField(
                            autofocus: true, // 获取焦点，弹出键盘
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: '请输入食材名',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 15.0), // 设置垂直内边距
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // 设置圆角
                              ),
                            ),
                            onChanged: (value) {
                              // 处理搜索框文本变化事件
                              _fetchSearchData(value);
                            },
                          )),
                    ),
                    SizedBox(width: 8.0),
                    Container(
                      width: 60,
                      child: TextButton(
                        child: Text("取消",
                            style: TextStyle(
                                fontSize: 17.0,
                                color: ThemeManager.themeColor)),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    )
                  ],
                )),
            Expanded(
                child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(dataList[index].text ?? ""),
                      trailing: Image(
                        image: AssetImage('assets/images/arrow_right.png'),
                        width: 20,
                        height: 18,
                      ),
                      onTap: () {
                        _skipFoodConfig(dataList[index]);
                      },
                    ),
                    Divider(
                      height: 0.5,
                      color: ThemeManager.lineBoardColor(),
                    ),
                  ],
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  _skipFoodConfig(SearchDataListModel model) {
    Map<String, dynamic>? arguments = {
      'methodName': 'SearchHome',
      'version': '5.61',
      'keyword': model.text,
      'token': 0,
      'user_id': 0,
    };

    // 路由跳转传值
    Get.toNamed('/cookConfig', arguments: arguments);

    // 收起键盘
    FocusScope.of(context).unfocus();
  }
}
