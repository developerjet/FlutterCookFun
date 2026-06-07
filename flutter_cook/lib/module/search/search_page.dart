import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/search/model/search_data_model.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _focusNode = FocusNode();
  late List<SearchDataListModel> dataList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchSearchData(String keyword) async {
    if (keyword.isEmpty) {
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

    if (model.data!.isNotEmpty) {
      setState(() {
        dataList = model.data!;
      });
    }
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
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 40,
                          child: TextField(
                            autofocus: true, // 获取焦点，弹出键盘
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: 'search_hint'.tr,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0), // 设置垂直内边距
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
                    const SizedBox(width: 8.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 72),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(72, 40),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('cancel'.tr,
                            style: TextStyle(
                                fontSize: 17.0,
                                color: Theme.of(context).colorScheme.primary)),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    )
                  ],
                )),
            Expanded(
              child: dataList.isEmpty
                  ? EmptyState.empty(
                      title: 'no_search_results'.tr,
                      description: 'enter_keyword_to_search'.tr,
                      onRefresh: () {},
                    )
                  : ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(dataList[index].text ?? ""),
                              trailing: const Image(
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
                              color: Theme.of(context).dividerColor,
                            ),
                          ],
                        );
                      },
                    ),
            )
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
    Get.toNamed(RouteNames.cookConfig, arguments: arguments);

    // 收起键盘
    FocusScope.of(context).unfocus();
  }
}
