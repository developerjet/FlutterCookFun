# flutter_cook

## 项目简介

`flutter_cook` 是基于 Flutter 和 GetX 构建的一款菜谱/美食类应用，涵盖首页推荐、食材配菜、菜谱浏览、图书模块和个人中心。

本项目已支持：
- 深色/浅色主题切换（ThemeData 缓存，切换流畅）
- 国际化文本（中英文切换）
- 网络数据请求与分页加载（Dio + BaseRepository 重试）
- 空状态、加载状态和错误状态统一占位显示
- 模块化路由与控制器管理
- PageView 滑动切换食材分类
- 视频播放（全屏/竖屏，视频切换）
- 全局 Crash 防御（RxList 快照、空安全加固、类型安全）

## 目录结构

```
flutter_cook/
├─ android/                  # Android 原生工程
├─ ios/                      # iOS 原生工程
├─ lib/                      # Flutter 代码主目录
│  ├─ base/                  # 共享组件与基础控件
│  │  ├─ repository/         # 网络请求基类（重试/错误处理）
│  │  └─ widgets/            # 通用 UI 组件
│  ├─ binding/               # 全局绑定与控制器注册
│  ├─ module/                # 应用模块目录
│  │  ├─ book/               # 书籍/菜谱模块
│  │  ├─ cook/               # 配菜与菜谱模块
│  │  ├─ home/               # 首页模块
│  │  ├─ mine/               # 个人中心模块
│  │  ├─ player/             # 播放器模块
│  │  ├─ search/             # 搜索模块
│  │  └─ setting/            # 设置模块
│  ├─ routers/               # 路由定义
│  ├─ utils/                 # 工具类（日志、主题、常量、语言、错误处理等）
│  └─ main.dart              # 应用入口
├─ assets/                   # 资源文件
├─ test/                     # 自动化测试
├─ pubspec.yaml              # 依赖与包配置
└─ README.md                 # 项目说明文档
```

## 主要功能模块

- `home`：首页推荐与分类列表，支持轮播图和数据列表展示。
- `cook`：食材选择（PageView 滑动分类）、配菜推荐、菜谱步骤浏览。
- `book`：书籍/菜谱卡片列表与详情页面，场景背景 + slogan 展示。
- `mine`：用户收藏、个人设置、主题与语言配置。
- `search`：关键字搜索，实时建议（防抖 300ms），搜索历史持久化。
- `player`：视频播放，支持全屏/竖屏切换，多视频切换。

## 关键实现点

### 主题管理：`lib/utils/theme.dart`
- 使用 `ThemeManager` 统一管理浅色/深色主题配置
- `_buildTheme(Brightness)` 统一构建，首次构建后缓存，切换不重建
- `GetMaterialApp` 通过 `Obx` 监听 `ThemeManager.currentThemeMode` 实时切换

### 路由与状态管理：GetX
- 控制器通过 `Get.put` / `Get.find` 注册与查找
- 页面通过 `Get.toNamed` + `RouteNames` 常量进行模块化路由跳转
- `lib/routers/routers.dart` 统一注册所有路由

### 网络层：`lib/utils/networking/`
- `DioClient` 单例管理 HTTP 请求（GET/POST/PUT/DELETE）
- `BaseRepository` 提供统一重试机制（指数退避）
- 错误分类：`lib/utils/error_handler.dart` — `NetworkException` / `DataException` / `BusinessException`
- 日志管理：`lib/utils/logger.dart` — 独立日志模块，支持 debug/info/warning/error 分级

### 搜索优化
- 输入防抖 300ms + 请求序列号丢弃过期响应

### 空状态组件：`lib/base/empty_state_view.dart`
- 统一处理空数据、加载中、错误三种占位视图
- 支持文本、图标、按钮和自定义内容

### 通用 UI 组件：`lib/base/widgets/`
| 组件 | 用途 |
|------|------|
| `AppNetworkImage` | 网络图片，内置 loading/error 占位 |
| `AppDialog.show()` | 双按钮确认弹窗 |
| `AppDialog.alert()` | 单按钮提示弹窗 |
| `AppBottomSheet.show()` | 底部弹窗，自动圆角 + 安全区 |
| `AppSheetAction` | 底部弹窗操作项 |

## 开发约定

### 代码规范
- 主题色优先使用 `Theme.of(context)` 或 `ThemeManager`；**禁止硬编码颜色**。
- 网络请求与业务逻辑由模块 Controller 管理，Page 负责渲染与交互。
- 新页面必须处理 **loading / empty / error** 三态。
- JSON Model 修改后运行 `flutter pub run build_runner build --delete-conflicting-outputs`。

### 防 Crash 规范
- **RxList 快照**：`Obx` builder 内，若 `itemCount`/`childCount` 和 `itemBuilder` 都读同一个 `.obs` 列表，入口处必须 `toList()` 快照。否则异步回调修改列表会导致 `RangeError`。
- **空安全**：`Get.arguments` 必须 `as Map<String, dynamic>?` 空判断后再取值。
- **类型安全**：优先用 `is` 类型守卫代替 `as` 强转，防止 API 返回异常数据时 `TypeError`。
- **late 慎用**：优先声明时赋默认值；必须用 `late` 的场景确保 `initState` 中赋值。

### 模块目录规范
```
module/<name>/
├─ controller/    # GetX Controller
├─ model/         # 数据模型 + .g.dart
├─ views/         # UI 组件（Cell、Header 等）
├─ repository/    # 网络请求层
└─ <name>_page.dart  # 主页面
```

## 运行方式

1. 安装依赖：
   ```bash
   flutter pub get
   ```

2. 运行应用：
   ```bash
   flutter run
   ```

3. 发布前检查：
   ```bash
   flutter analyze
   flutter test
   ```

## 技术栈

| 分类 | 技术 |
|------|------|
| 框架 | Flutter (SDK >=3.2.3 <4.0.0) |
| 状态管理 | GetX — `Obx` / `GetPage` / `.obs` |
| 网络 | Dio — `DioClient` 单例 + `BaseRepository` 重试 |
| 本地存储 | sqflite（收藏） + shared_preferences（设置/搜索历史） |
| JSON | json_annotation + json_serializable + build_runner |
| UI 组件 | carousel_slider, photo_view, easy_refresh |
| 视频 | flick_video_player + video_player |
| 图片 | gal（相册保存）+ path_provider |
| 国际化 | GetX Translations（zh_CN 主，en_US 备） |

## 已知 API 特性

| 接口 | 注意 |
|------|------|
| `SceneInfo` | 不支持分页，page 参数无效，`size: 200` 一次拉全量 |
| `SearchHome` | 返回 `{material, course, dishes}`，不能直接给 cookConfig 用 |
| `SearchKeyword` | 建议数据在 `top.data[]` 不是 `data[]` |
| `CategoryIndex` | 首页列表不支持分页，每次返回全量数据 |

## 常见问题速查

| 问题 | 解决 |
|------|------|
| `LateInitializationError` | 不用 `late`，声明时赋默认值 |
| `A RenderFlex overflowed` | `Expanded`/`Flexible` 包裹 |
| `setState() after dispose()` | 异步后检查 `mounted` |
| EasyRefresh 上拉卡死 | 不要手动调 `finishLoad()` |
| BottomSheet 圆角不生效 | `Get.bottomSheet` 不读 theme shape；用 `AppBottomSheet` |
| 视频播放器卡死 | 不要给 `FlickManager` 的 controller 加 `setState` listener |
| GetX 路由同帧冲突 | `Get.back()` + `Future.delayed(300ms)` → 导航 |
| iOS 相册崩溃 | Info.plist 加 `NSPhotoLibraryUsageDescription` |
| 搜索结果被建议覆盖 | 建议回调中检查 `_showResults` 标志位 |
| 列表构建时 RangeError | Obx 内对 .obs 列表做 `toList()` 快照后再传 itemCount |

## 贡献与维护

扩展功能请按模块分离，遵循上述目录规范。每个模块独立 controller/model/views/repository，保持低耦合。
