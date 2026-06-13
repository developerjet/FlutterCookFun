# FlutterCookFun — 厨艺乐 🍳

基于 Flutter 开发的美食烹饪 App，提供食材浏览、智能配菜、步骤教学、视频播放等一站式烹饪体验。

## 预览

| 首页 | 食材选择 | 做菜步骤 |
| -- | -- | -- |
|![首页](https://github.com/developerjet/FlutterCookFun/blob/main/ScreenShot/iPhone_01.png)|![食材](https://github.com/developerjet/FlutterCookFun/blob/main/ScreenShot/iPhone_03.png)|![步骤](https://github.com/developerjet/FlutterCookFun/blob/main/ScreenShot/iPhone_02.png)|

| 菜谱 | 我的 | 视频播放 |
| -- | -- | -- |
|![菜谱](https://github.com/developerjet/FlutterCookFun/blob/main/ScreenShot/iPhone_04.png)|![我的](https://github.com/developerjet/FlutterCookFun/blob/main/ScreenShot/iPhone_05.png)|![视频](https://github.com/developerjet/FlutterCookFun/blob/main/ScreenShot/iPhone_06.jpg)|

## 功能

### 首页
- Banner 智能推荐：跨模块提取美食图片，评分排序自动生成轮播
- 食材分类网格：24 个食材分类，三级联动

### 做菜
- 多选食材（最多 5 种），智能匹配合适菜谱
- 做菜步骤图文展示，支持步骤图片全屏浏览
- **图片长按/菜单保存到系统相册**
- 视频播放（食材处理视频 + 烹饪过程视频）
- 收藏菜谱到本地

### 菜谱
- 1460+ 菜谱场景卡片流，分页加载
- 场景详情页：背景大图 + 菜品列表
- 视频播放入口

### 搜索
- **实时搜索建议**：输入防抖 300ms，缩略图 + 菜谱数量提示
- **多维度结果**：食材匹配 + 课程推荐分组展示
- 搜索结果一键跳转配菜

### 我的
- 本地收藏管理
- 主题切换（亮色/暗色）
- 多语言（简体中文 / English）
- 版本信息

## 技术栈

| 分类 | 技术 |
|------|------|
| 框架 | Flutter (SDK >=3.2.3) |
| 状态管理 | **GetX** — Obx / GetBuilder / GetPage |
| 路由 | GetX 路由 + 中间件 |
| 网络 | **Dio** — 单例 DioClient，统一拦截器、重试机制 |
| 本地存储 | **sqflite**（收藏） + **shared_preferences**（主题/语言） |
| JSON | json_annotation + json_serializable + build_runner |
| UI 组件 | getwidget, carousel_slider, photo_view, easy_refresh |
| 视频 | flick_video_player + video_player |
| WebView | webview_flutter |
| 国际化 | GetX Translations（zh_CN 主语言，en_US 后备） |
| 相册保存 | gal |
| 文件路径 | path_provider |

## 项目结构

```
lib/
├── main.dart                   # 入口：GetMaterialApp + ThemeManager
├── base/                       # 公共基础组件
│   ├── tabs.dart              # 底部 Tab 导航
│   ├── web.dart               # WebView 页面
│   ├── image_viewer.dart       # 图片浏览器
│   └── empty_state_view.dart   # 统一空状态/加载/错误视图
├── binding/                    # GetX 全局依赖注入
├── routers/                    # 路由配置（iOS 风格过渡动画）
├── middlewares/                # 路由中间件
├── utils/                      # 工具类
│   ├── constants.dart          # API/Ui/业务常量
│   ├── theme.dart              # 主题管理（亮/暗色自动切换）
│   ├── networking/             # Dio 网络客户端（单例 + 重试）
│   ├── error_handler.dart      # 统一错误处理
│   ├── sqlite/                 # sqflite 数据库管理
│   ├── language/               # 多语言翻译文件
│   └── toast.dart              # Toast/SnackBar 封装
└── module/                     # 功能模块
    ├── home/                   # 首页（Banner推荐 + 食材分类）
    ├── cook/                   # 做菜（食材选择 → 配菜 → 步骤 → 收藏）
    ├── book/                   # 菜谱（场景列表 → 详情 → 视频）
    ├── search/                 # 搜索（实时建议 + 多维度结果）
    ├── player/                 # 视频播放器
    ├── mine/                   # 个人中心（收藏 + 设置）
    └── setting/                # 主题/语言设置
```

每个模块遵循统一结构：`controller/` → `model/` → `views/` → `repository/`

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/developerjet/FlutterCookFun.git
cd FlutterCookFun/flutter_cook

# 安装依赖
flutter pub get

# 代码生成（修改 model 后执行）
flutter pub run build_runner build --delete-conflicting-outputs

# 运行
flutter run

# 静态分析
flutter analyze
```

## 构建

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

> iOS 构建前需执行 `cd ios && pod install`

## 后端接口

基于 `api.izhangchu.com` 开放 API，已逆向分析的接口包括：

| 接口 | 数据量 | 用途 |
|------|--------|------|
| HomePage | 10 模块 | 首页 Banner + 推荐 |
| CategoryIndex | 24 分类 | 食材分类 |
| MaterialSubtype | 17 组 | 食材列表 |
| SceneList | 1460 场景 | 菜谱列表 |
| SceneDishes | 每场景 140 道 | 菜谱详情 |
| DishesView | 完整步骤 | 做菜步骤 + 视频 |
| SearchKeyword | 实时联想 | 搜索建议 |
| SearchHome | 多维匹配 | 搜索结果 |
| TopicList | 244 话题 | 美食话题（预留） |
| CommentList | 有限 | 评论（后端关停中） |

## License

MIT
