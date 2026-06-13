import 'dart:async';
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
  final _searchController = TextEditingController();

  /// 实时搜索建议（食材匹配）
  List<SearchTopData> _suggestions = [];

  /// 课程匹配信息
  SearchSecond? _courseInfo;

  /// SearchHome 食材匹配结果
  List<SearchTopData> _materialResults = [];

  /// SearchHome 课程匹配信息
  SearchSecond? _searchCourseInfo;

  /// 是否正在加载
  bool _isLoading = false;

  /// 是否显示搜索结果（用户提交搜索后）
  bool _showResults = false;

  /// 防抖 Timer
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  /// 实时搜索建议（防抖 300ms）
  Future<void> _fetchSuggestions(String keyword) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      await _doFetchSuggestions(keyword);
    });
  }

  Future<void> _doFetchSuggestions(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _suggestions = [];
        _courseInfo = null;
        _showResults = false;
      });
      return;
    }

    final params = {
      'methodName': 'SearchKeyword',
      'version': '5.61',
      'keyword': keyword,
      'token': '0',
      'user_id': '0',
    };

    try {
      final response = await DioClient.get('', queryParameters: params);
      final model = SearchDataModel.fromJson(response.data['data']);

      if (!mounted) return;

      setState(() {
        // 核心修复：读取 top.data 而非 data
        _suggestions = model.top?.data ?? [];
        _courseInfo = model.second;
        _showResults = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suggestions = [];
        _courseInfo = null;
      });
    }
  }

  /// 提交搜索：获取 SearchHome 结果
  Future<void> _submitSearch(String keyword) async {
    if (keyword.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _showResults = true;
      _materialResults = [];
      _searchCourseInfo = null;
    });

    final params = {
      'methodName': 'SearchHome',
      'version': '5.61',
      'keyword': keyword,
      'token': '0',
      'user_id': '0',
    };

    try {
      final response = await DioClient.get('', queryParameters: params);
      final data = response.data['data'] as Map<String, dynamic>?;

      if (!mounted) return;

      final materialRaw = data?['material'] as Map<String, dynamic>?;
      final courseRaw = data?['course'] as Map<String, dynamic>?;

      final materialList = (materialRaw?['data'] as List<dynamic>?)
              ?.map((e) => SearchTopData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      final courseInfo = courseRaw != null
          ? SearchSecond(
              total: courseRaw['total']?.toString(),
              courseName: courseRaw['course_name']?.toString(),
            )
          : null;

      setState(() {
        _materialResults = materialList;
        _searchCourseInfo = courseInfo;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _materialResults = [];
        _searchCourseInfo = null;
        _isLoading = false;
      });
    }
  }

  /// 点击建议项 → 以建议标题为关键词提交搜索
  void _onSuggestionTap(SearchTopData suggestion) {
    final keyword = suggestion.title ?? '';
    _searchController.text = keyword;
    _submitSearch(keyword);
  }

  /// 点击食材结果 → 跳转配菜页
  void _onMaterialTap(SearchTopData material) {
    final arguments = {
      'methodName': 'SearchHome',
      'version': '5.61',
      'keyword': material.title,
      'token': 0,
      'user_id': 0,
    };
    Get.toNamed(RouteNames.cookConfig, arguments: arguments);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 搜索栏
            _buildSearchBar(context),
            // 主内容区
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                autofocus: true,
                focusNode: _focusNode,
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => _submitSearch(value.trim()),
                decoration: InputDecoration(
                  hintText: 'search_hint'.tr,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15.0),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              size: 18,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                          onPressed: () {
                            _searchController.clear();
                            _fetchSuggestions('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // 刷新清除按钮
                  _fetchSuggestions(value.trim());
                },
              ),
            ),
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
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // 加载中
    if (_isLoading) {
      return EmptyState.loading(
        title: 'searching'.tr,
        description: 'loading'.tr,
      );
    }

    // 已提交搜索 → 显示搜索结果
    if (_showResults) {
      return _buildSearchResults(context);
    }

    // 空输入 → 引导提示
    if (_searchController.text.trim().isEmpty) {
      return EmptyState.empty(
        title: 'no_search_results'.tr,
        description: 'enter_keyword_to_search'.tr,
      );
    }

    // 无建议
    if (_suggestions.isEmpty) {
      return EmptyState.empty(
        title: 'no_search_results'.tr,
        description: 'try_other_keywords'.tr,
      );
    }

    // 显示实时建议
    return _buildSuggestions(context);
  }

  /// 实时建议列表
  Widget _buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: _suggestions.length + (_courseInfo != null ? 1 : 0),
      itemBuilder: (context, index) {
        // 课程提示条
        if (index == 0 && _courseInfo != null) {
          return _buildCourseHint(context);
        }

        final suggestionIndex = _courseInfo != null ? index - 1 : index;
        final suggestion = _suggestions[suggestionIndex];

        return Column(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  suggestion.image ?? '',
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 44,
                    height: 44,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.search,
                        size: 24,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color),
                  ),
                ),
              ),
              title: Text(
                suggestion.title ?? '',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              subtitle: Text(
                'tap_to_search_ingredient'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              onTap: () => _onSuggestionTap(suggestion),
            ),
            Divider(
              height: 0.5,
              color: Theme.of(context).dividerColor,
            ),
          ],
        );
      },
    );
  }

  /// 课程匹配提示条
  Widget _buildCourseHint(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
      child: Row(
        children: [
          Icon(Icons.menu_book,
              size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${'related_courses'.trArgs([_courseInfo?.total ?? '0'])}：${_courseInfo?.courseName ?? ''}',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 搜索结果页
  Widget _buildSearchResults(BuildContext context) {
    final hasMaterial = _materialResults.isNotEmpty;
    final hasCourse = _searchCourseInfo != null;

    // 无任何结果
    if (!hasMaterial && !hasCourse) {
      return SingleChildScrollView(
        child: EmptyState.empty(
          title: 'no_search_results'.tr,
          description: 'try_other_keywords'.tr,
        ),
      );
    }

    return ListView(
      children: [
        // 课程匹配
        if (hasCourse) _buildSearchCourseSection(context),

        // 食材匹配
        if (hasMaterial) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '${'ingredient_matches'.tr}（${_materialResults.length}）',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          ..._materialResults.map((material) => Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        material.image ?? '',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 44,
                          height: 44,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.fastfood,
                              size: 24,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                        ),
                      ),
                    ),
                    title: Text(
                      material.title ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    subtitle: Text(
                      'view_matching_recipes'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color,
                      ),
                    ),
                    trailing: const Image(
                      image: AssetImage('assets/images/arrow_right.png'),
                      width: 20,
                      height: 18,
                    ),
                    onTap: () => _onMaterialTap(material),
                  ),
                  Divider(
                    height: 0.5,
                    color: Theme.of(context).dividerColor,
                  ),
                ],
              )),
        ],
      ],
    );
  }

  /// 搜索结果 — 课程匹配区域
  Widget _buildSearchCourseSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_rounded,
              size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _searchCourseInfo?.courseName ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'total_related_courses'.trArgs([_searchCourseInfo?.total ?? '0']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
