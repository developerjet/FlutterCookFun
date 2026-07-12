import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/module/search/model/search_data_model.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _focusNode = FocusNode();
  final _searchController = TextEditingController();
  late final DioClient _client;

  /// 实时搜索建议（食材匹配）
  List<SearchTopData> _suggestions = [];

  /// SearchHome 食材匹配结果
  List<SearchTopData> _materialResults = [];

  /// 是否正在加载
  bool _isLoading = false;

  /// 错误信息
  String? _errorMessage;

  /// 是否显示搜索结果（用户提交搜索后）
  bool _showResults = false;

  /// 防抖 Timer
  Timer? _debounce;

  /// 请求序列号，丢弃过时响应
  int _requestSeq = 0;

  /// 搜索历史
  List<String> _searchHistory = [];
  static const _historyKey = 'search_history';
  static const _maxHistory = 10;

  @override
  void initState() {
    super.initState();
    _client = Get.find<DioClient>();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw != null) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        setState(() {
          _searchHistory = decoded.map((e) => e.toString()).toList();
        });
      }
    }
  }

  Future<void> _addToHistory(String keyword) async {
    _searchHistory.remove(keyword);
    _searchHistory.insert(0, keyword);
    if (_searchHistory.length > _maxHistory) {
      _searchHistory = _searchHistory.sublist(0, _maxHistory);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, jsonEncode(_searchHistory));
    if (mounted) setState(() {});
  }

  Future<void> _removeFromHistory(String keyword) async {
    _searchHistory.remove(keyword);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, jsonEncode(_searchHistory));
    if (mounted) setState(() {});
  }

  Future<void> _clearHistory() async {
    _searchHistory.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    if (mounted) setState(() {});
  }

  /// 实时搜索建议（防抖 300ms）
  Future<void> _fetchSuggestions(String keyword) async {
    _debounce?.cancel();
    if (_showResults) return;
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      await _doFetchSuggestions(keyword);
    });
  }

  Future<void> _doFetchSuggestions(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _suggestions = [];
        _showResults = false;
        _errorMessage = null;
      });
      return;
    }

    final seq = ++_requestSeq;
    final params = {
      'methodName': 'SearchKeyword',
      'version': '5.61',
      'keyword': keyword,
      'token': '0',
      'user_id': '0',
    };

    try {
      final response = await _client.get('', queryParameters: params);
      if (seq != _requestSeq || !mounted) return;

      final data = (response.data as Map?)?['data'];
      if (data == null) return;
      final model = SearchDataModel.fromJson(data as Map<String, dynamic>);

      if (!mounted) return;

      if (_showResults) return; // 搜索结果已展示，跳过建议更新
      setState(() {
        _suggestions = model.top?.data ?? [];
      });
    } catch (_) {
      if (seq != _requestSeq || !mounted) return;
      setState(() {
        _suggestions = [];
        _errorMessage = 'search_load_failed'.tr;
      });
    }
  }

  /// 提交搜索：获取 SearchHome 结果
  Future<void> _submitSearch(String keyword) async {
    if (keyword.isEmpty) return;

    FocusScope.of(context).unfocus();

    final seq = ++_requestSeq;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showResults = true;
      _materialResults = [];
    });

    final params = {
      'methodName': 'SearchHome',
      'version': '5.61',
      'keyword': keyword,
      'token': '0',
      'user_id': '0',
    };

    try {
      final response = await _client.get('', queryParameters: params);
      if (seq != _requestSeq || !mounted) return;

      final data = (response.data as Map?)?['data'] as Map<String, dynamic>?;
      if (data == null) {
        setState(() => _isLoading = false);
        return;
      }

      final materialRaw = data['material'] as Map<String, dynamic>?;
      final materialList = (materialRaw?['data'] as List<dynamic>?)
              ?.map((e) => SearchTopData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      if (!mounted) return;
      _addToHistory(keyword);
      setState(() {
        _materialResults = materialList;
        _isLoading = false;
      });
    } catch (_) {
      if (seq != _requestSeq || !mounted) return;
      setState(() {
        _materialResults = [];
        _isLoading = false;
        _errorMessage = 'search_failed'.tr;
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
    if (material.id == null) return;
    Get.toNamed(RouteNames.cookConfig, arguments: {
      'methodName': 'SearchMix',
      'version': '4.3.2',
      'material_ids': material.id,
    });
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
    return _SearchBarWidget(
      controller: _searchController,
      focusNode: _focusNode,
      onClear: () {
        setState(() {
          _showResults = false;
          _suggestions = [];
        });
      },
      onChanged: (value) => _fetchSuggestions(value.trim()),
      onSubmitted: (value) => _submitSearch(value.trim()),
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

    // 网络错误
    if (_errorMessage != null) {
      return EmptyState.error(
        title: 'search_failed'.tr,
        description: _errorMessage,
        onRetry: () => _fetchSuggestions(_searchController.text.trim()),
      );
    }

    // 已提交搜索 → 显示搜索结果
    if (_showResults) {
      return _buildSearchResults(context);
    }

    // 空输入 → 搜索历史
    if (_searchController.text.trim().isEmpty) {
      return _searchHistory.isNotEmpty
          ? _buildSearchHistory(context)
          : EmptyState.empty(
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
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];

        return _SearchListItem(
          imageUrl: suggestion.image,
          title: suggestion.title ?? '',
          subtitle: 'tap_to_search_ingredient'.tr,
          fallbackIcon: Icons.search,
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          onTap: () => _onSuggestionTap(suggestion),
        );
      },
    );
  }

  /// 搜索历史
  Widget _buildSearchHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text('搜索历史', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              GestureDetector(
                onTap: _clearHistory,
                child: Icon(Icons.delete_outline,
                    size: 18,
                    color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final keyword = _searchHistory[index];
              return ListTile(
                dense: true,
                leading: Icon(Icons.history,
                    size: 18,
                    color: Theme.of(context).textTheme.bodySmall?.color),
                title:
                    Text(keyword, style: Theme.of(context).textTheme.bodyLarge),
                trailing: IconButton(
                  icon: Icon(Icons.close,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color),
                  onPressed: () => _removeFromHistory(keyword),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                onTap: () {
                  _searchController.text = keyword;
                  _submitSearch(keyword);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// 搜索结果页
  Widget _buildSearchResults(BuildContext context) {
    if (_materialResults.isEmpty) {
      return EmptyState.empty(
        title: 'no_search_results'.tr,
        description: 'try_other_keywords'.tr,
      );
    }

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: _materialResults.length,
      itemBuilder: (context, index) {
        final material = _materialResults[index];
        return _SearchListItem(
          imageUrl: material.image,
          title: material.title ?? '',
          fallbackIcon: Icons.fastfood,
          trailing: const Image(
            image: AssetImage('assets/images/arrow_right.png'),
            width: 20,
            height: 18,
          ),
          onTap: () => _onMaterialTap(material),
        );
      },
    );
  }
}

class _SearchListItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final IconData fallbackIcon;
  final Widget trailing;
  final VoidCallback onTap;

  const _SearchListItem({
    required this.imageUrl,
    required this.title,
    required this.fallbackIcon,
    required this.trailing,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              children: [
                AppNetworkImage(
                  url: imageUrl,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(8),
                  fallbackIcon: fallbackIcon,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 搜索栏独立组件 — setState 仅重建自身，不影响父页面
class _SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _SearchBarWidget({
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  State<_SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<_SearchBarWidget> {
  bool get _hasText => widget.controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {}); // 仅重建搜索栏
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                autofocus: true,
                focusNode: widget.focusNode,
                controller: widget.controller,
                textInputAction: TextInputAction.search,
                onSubmitted: widget.onSubmitted,
                onTapOutside: (_) => widget.focusNode.unfocus(),
                decoration: InputDecoration(
                  hintText: 'search_hint'.tr,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  suffixIcon: _hasText
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              size: 18,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                          onPressed: () {
                            widget.controller.clear();
                            widget.onClear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 64),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(64, 40),
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
}
