# flutter_cook

## 项目简介

`flutter_cook` 是基于 Flutter 和 GetX 构建的一款菜谱/美食类应用，涵盖首页推荐、食材配菜、菜谱浏览、图书模块和个人中心。

本项目已支持：
- 深色/浅色主题切换
- 国际化文本（中英文切换）
- 网络数据请求与分页加载
- 空状态、加载状态和错误状态统一占位显示
- 模块化路由与控制器管理

## 目录结构

```
flutter_cook/
├─ android/                  # Android 原生工程
├─ ios/                      # iOS 原生工程
├─ lib/                      # Flutter 代码主目录
│  ├─ base/                  # 共享组件与基础控件
│  ├─ binding/               # 全局绑定与控制器注册
│  ├─ middlewares/           # 路由中间件
│  ├─ module/                # 应用模块目录
│  │  ├─ book/               # 书籍/菜谱模块
│  │  ├─ cook/               # 配菜与菜谱模块
│  │  ├─ home/               # 首页模块
│  │  ├─ mine/               # 个人中心模块
│  │  ├─ player/             # 播放器模块
│  │  ├─ search/             # 搜索模块
│  │  ├─ setting/            # 设置模块
│  │  └─ routers/            # 路由定义
│  ├─ utils/                 # 工具类、主题、常量、语言等
│  └─ main.dart              # 应用入口
├─ assets/                   # 资源文件
├─ test/                     # 自动化测试
├─ pubspec.yaml              # 依赖与包配置
└─ README.md                 # 项目说明文档
```

## 主要功能模块

- `home`：首页推荐与分类列表，支持轮播图和数据列表展示。
- `cook`：配菜推荐、菜谱详情、步骤浏览与选择食材功能。
- `book`：书籍/菜谱卡片列表与详情页面。
- `mine`：用户收藏、个人设置、主题与语言配置。
- `search`：关键字搜索页面。
- `player`：视频/播放页面（如有引入视频播放逻辑）。

## 关键实现点

- 主题管理：`lib/utils/theme.dart`
  - 使用 `ThemeManager` 统一管理浅色/深色主题配置
  - `GetMaterialApp` 通过 `Obx` 监听 `ThemeManager.currentThemeMode` 实时切换

- 路由与状态管理：GetX
  - 控制器通过 `Get.put` / `Get.find` 注册与查找
  - 页面通过 `Get.toNamed` 进行模块化路由跳转

- 空状态组件：`lib/base/empty_state_view.dart`
  - 统一处理空数据、加载中、错误三种占位视图
  - 支持文本、图标、按钮和自定义内容

## 运行方式

1. 安装依赖：
   ```bash
   flutter pub get
   ```

2. 运行应用：
   ```bash
   flutter run
   ```

3. iOS 真机/模拟器运行：
   ```bash
   flutter run --flavor development
   ```

4. 发布前建议执行：
   ```bash
   flutter analyze
   flutter test
   ```

## 开发约定

- 主题色建议优先使用 `Theme.of(context)` 或 `ThemeManager` 提供的主题色；避免硬编码颜色。
- 页面 UI 样式应尽量复用基础组件与 `textTheme` 配置。
- 网络请求与业务逻辑应由模块控制器管理，页面负责渲染与交互。
- 资源文件放在 `assets/`，字体与图片需要在 `pubspec.yaml` 注册。

## 注意事项

- 本项目使用 GetX 进行状态管理与路由导航。
- 某些页面使用 `EasyRefresh` 进行下拉刷新与分页加载。
- 需要确保 `assets/images` 中的静态图片路径与代码引用一致。

## 贡献与维护

如果需要扩展功能，请优先按模块分离：
- 新增页面置于对应模块目录
- 视图组件放在模块内的 `views/`
- 控制器放在模块内的 `controller/`
- 模型放在模块内的 `model/`

欢迎根据功能点继续补充文档说明。