# CLAUDE.md — Flutter Cook Fun

> **沟通语言**：中文。代码标识符使用英文。

## 项目概述

Flutter Cook Fun（厨艺乐）— 美食烹饪 App，GetX 状态管理 + Dio 网络 + 主题/多语言。

## 技术栈

| 分类 | 技术 |
|------|------|
| 框架 | Flutter (SDK >=3.2.3 <4.0.0) |
| 状态管理 | GetX — Obx / GetPage / `.obs` |
| 网络 | Dio — DioClient 单例 + BaseRepository 重试 |
| 本地存储 | sqflite（收藏） + shared_preferences（设置/搜索历史） |
| JSON | json_annotation + json_serializable + build_runner |
| UI 组件 | getwidget, carousel_slider, photo_view, easy_refresh, **flutter_sticky_header** |
| 视频 | flick_video_player + video_player |
| 图片 | gal（相册保存）+ path_provider |
| 国际化 | GetX Translations（zh_CN 主，en_US 备） |

## 项目架构

```
lib/
├── main.dart                  # GetMaterialApp + ThemeManager
├── base/
│   ├── repository/base_repository.dart
│   ├── tabs.dart              # 底部 Tab
│   ├── web.dart               # WebView
│   ├── empty_state_view.dart   # 空/载/错统一占位
│   └── widgets/               # 通用 UI 组件
│       ├── app_network_image.dart  # 网络图片（loading/error 兜底）
│       ├── app_dialog.dart         # 统一弹窗（胶囊按钮）
│       └── app_bottom_sheet.dart   # 统一底部弹窗（安全区）
├── binding/                   # GetX 依赖注入
├── routers/                   # 路由配置（iOS 过渡动画）
├── utils/
│   ├── constants.dart         # API/UI/业务常量
│   ├── theme.dart             # 主题（亮/暗自动）
│   ├── networking/            # DioClient 单例
│   ├── error_handler.dart     # 统一错误处理
│   ├── sqlite/                # 数据库
│   ├── language/              # 多语言
│   └── toast.dart             # Toast/SnackBar
└── module/
    ├── home/                  # 首页（Banner推荐 + 分类）
    ├── cook/                  # 做菜（食材→配菜→步骤）
    ├── book/                  # 菜谱（场景→详情→做菜步骤）
    ├── search/                # 搜索（实时建议 + 历史）
    ├── player/                # 视频播放（切换 + 序号）
    ├── mine/                  # 收藏
    └── setting/               # 主题/语言
```

模块内部：`controller/` → `model/` → `views/` → `repository/`

## 核心开发规范

### 新页面必做三态

每个数据列表页面 **必须** 处理：**loading** / **empty** / **error**。使用 `EmptyState.loading()` / `.empty()` / `.error()`。

### 网络请求
- API 基础地址：`api.izhangchu.com`
- Repository 继承 `BaseRepository`，用 `execute()` 自动重试
- 分页数据 **必须** 跟踪 `hasMore`，返回数 < pageSize 时置 false
- 搜索输入 **必须** 防抖（`Timer` 300ms）+ 请求序列号丢弃过期响应

### 状态管理
- `Obx(() => ...)` 响应式绑定
- `late` 关键字慎用 — 优先声明时赋默认值，避免 `LateInitializationError`
- Controller 在页面 dispose 时 `Get.delete()`

### JSON 序列化
- 修改 model → `flutter pub run build_runner build --delete-conflicting-outputs`
- `.g.dart` 不要手动编辑

### 路由
- `RouteNames` 常量 → `AppRouter.routers` 注册
- `Get.toNamed(RouteNames.xxx, arguments: {...})` 传参
- 页面用 `CookStepsArguments.fromMap(Get.arguments)` 解析

### 国际化
- `language.dart` 的 `Messages` 类添加 key（中英需同步）
- 代码用 `.tr` / `.trArgs([])` 获取文案

### 主题
- `ThemeManager` 管理亮/暗切换
- **禁止硬编码颜色**（`Colors.white`、`Colors.grey` 等），用 `Theme.of(context).cardColor` / `colorScheme.primary` 等

### UI 组件规范
- 网络图片统一用 `AppNetworkImage(url: ...)`（内置 loading/error）
- 弹窗用 `AppDialog.show()` / `AppDialog.alert()`
- 底部弹窗用 `AppBottomSheet.show()` / `AppSheetAction`
- 图标触摸区 ≥44dp

## 常用命令

```bash
flutter run                    # 运行
flutter analyze                # 静态分析
flutter pub get                # 安装依赖
flutter pub add <pkg>          # 添加包
flutter pub run build_runner build --delete-conflicting-outputs  # 代码生成
flutter clean && flutter pub get  # 深度重置
cd ios && pod install && cd .. # iOS 依赖
```

## 可复用组件

| 组件 | 用法 |
|------|------|
| `AppNetworkImage` | 网络图片 — 内置 loading 动画 + error 占位，替代 `GFImageOverlay`/`Image.network` |
| `AppDialog.show()` | 双按钮确认弹窗 — 左右胶囊按钮，主题色填充 |
| `AppDialog.alert()` | 单按钮提示弹窗 |
| `AppBottomSheet.show()` | 底部弹窗 — 自动顶部圆角 + 安全区，替代 `Get.bottomSheet` |
| `AppSheetAction` | 弹窗操作项 — icon + label + trailing + isDestructive |
| `EmptyState` | 空/载/错占位 — `.loading()` `.empty()` `.error()` |

## 已知 API 特性

| 接口 | 注意 |
|------|------|
| `SceneInfo` | **不支持分页**，page 参数无效，`size: 200` 一次拉全量 |
| `SearchHome` | 返回 `{material, course, dishes}`，不能直接给 cookConfig 用 |
| `SearchKeyword` | 建议数据在 `top.data[]` 不是 `data[]` |

## 常见问题速查

| 问题 | 解决 |
|------|------|
| `LateInitializationError` | 不用 `late`，声明时赋默认值 |
| `A RenderFlex overflowed` | `Expanded`/`Flexible` 包裹 |
| `setState() after dispose()` | 异步后检查 `mounted` |
| EasyRefresh 上拉卡死 | 不要手动调 `finishLoad()` |
| BottomSheet 圆角不生效 | `Get.bottomSheet` 不读 theme shape；用 `AppBottomSheet` 替代 |
| 视频播放器卡死 | 不要给 `FlickManager` 的 controller 加 `setState` listener |
| GetX 路由同帧冲突 | `Get.back()` + `Future.delayed(300ms)` → 导航 |
| iOS 相册崩溃 | Info.plist 加 `NSPhotoLibraryUsageDescription` |
| 搜索结果被建议覆盖 | 建议回调中检查 `_showResults` 标志位 |
| 分组列表吸顶 | `SliverStickyHeader` + `SliverGrid`（不用 `shrinkWrap`） |
| 分组快速跳转 | `Scrollable.ensureVisible` + `GlobalKey` |
