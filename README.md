# Cook Fun

Cook Fun 是一个 Flutter 菜谱与食材配菜应用。项目使用 GetX 管理路由、依赖注入、响应式状态与国际化，内置本地偏好与收藏能力，并提供一套面向菜谱场景的 V6 设计系统。

## 功能

- 首页推荐、分类入口、灵感卡片和下拉刷新。
- 食材配菜，最多选择 5 种食材生成可做菜谱。
- 菜谱库、专题详情、图文步骤和视频播放。
- 搜索建议、搜索历史、食材结果跳转配菜。
- 本地收藏、批量选择、批量删除。
- 浅色/深色主题与中文/英文切换。
- 图片加载兜底、图片浏览、相册保存。

## 截图

![Cook Fun 界面总览](ScreenShot/full-ui-board-product-depth.png)

## 技术栈

| 分类 | 技术 |
|------|------|
| Flutter | Dart SDK `>=3.2.3 <4.0.0`、Material 3 |
| 状态/路由 | GetX |
| 资源/媒体 | photo_view、video_player、flick_video_player、gal |
| UI | easy_refresh、carousel_slider、flutter_easyloading |
| 生成/测试 | json_serializable、build_runner、mocktail、flutter_test |

## 项目结构

```text
FlutterCookFun/
├─ README.md
├─ ScreenShot/                 # README 展示截图
└─ flutter_cook/
   ├─ android/                 # Android 工程
   ├─ ios/                     # iOS 工程
   ├─ linux/                   # Linux 工程
   ├─ macos/                   # macOS 工程
   ├─ windows/                 # Windows 工程
   ├─ web/                     # Web 工程
   ├─ assets/                  # 图片、字体、字幕
   ├─ lib/
   │  ├─ base/                 # 通用页面能力和基础组件
   │  ├─ binding/              # 全局依赖注入
   │  ├─ design_system/        # V6 设计系统
   │  ├─ module/               # 业务模块
   │  ├─ routers/              # GetX 路由表
   │  ├─ services/             # 跨模块业务服务
   │  └─ utils/                # 日志、主题、语言、通用工具
   ├─ scripts/                 # 运行、打包、资源生成脚本
   ├─ test/                    # 单元测试与 Widget 测试
   ├─ pubspec.yaml
   └─ pubspec.lock
```

已扫描的可提交主体包含 `flutter_cook/`、`ScreenShot/`、根级 README 与 `.gitignore`。`docs/`、`build/`、`.dart_tool/`、IDE 配置和本地缓存均不作为远程仓库内容维护。

## 架构

```text
Page / Widget
  -> Controller
    -> Service / Repository
      -> Infrastructure
```

- `lib/main.dart`：初始化依赖、主题、语言和 `GetMaterialApp`。
- `lib/binding/binding.dart`：注册全局基础设施、Repository、Service、Controller。
- `lib/routers/routers.dart`：维护页面路由和路由级依赖绑定。
- `lib/design_system/`：集中管理色彩、尺寸、主题、图标路径和标准组件。
- `lib/base/widgets/`：统一导航栏、刷新容器、弹窗、底部弹窗、图片组件。

## 模块

| 模块 | 路径 | 说明 |
|------|------|------|
| 首页 | `lib/module/home/` | Banner、分类、推荐与刷新 |
| 配菜 | `lib/module/cook/` | 食材选择、菜谱匹配、步骤详情 |
| 菜谱库 | `lib/module/book/` | 场景列表与专题菜谱 |
| 我的 | `lib/module/mine/` | 收藏和个人中心 |
| 搜索 | `lib/module/search/` | 建议、历史和食材结果 |
| 设置 | `lib/module/setting/` | 主题与语言 |
| 播放器 | `lib/module/player/` | 视频播放 |

## 开发

```bash
cd flutter_cook
flutter pub get
flutter run
```

指定设备：

```bash
flutter devices
flutter run -d <device-id>
```

生成 JSON 代码：

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

生成界面资源：

```bash
python3 -m pip install pillow
python3 scripts/generate_interface_assets.py
```

## 测试

```bash
cd flutter_cook
flutter analyze
flutter test
```

当前测试覆盖依赖注入、Controller、业务层、设计系统组件、核心页面结构、收藏、搜索布局、字体资源、图片资源与视觉规范等场景。

## 构建脚本

`flutter_cook/scripts/` 提供两类入口：

- `scripts/shell/*.sh`：适合终端、CI 或自动化流程执行。
- `scripts/macos/*.command`：适合 macOS Finder 双击执行，内部复用同名 shell 流程。

运行应用：

```bash
cd flutter_cook
./scripts/shell/run_flutter.sh
```

macOS 也可以双击：

```text
flutter_cook/scripts/macos/run_flutter.command
```

构建 Android APK：

```bash
./scripts/shell/build_android_apk.sh
MODE=release SPLIT_PER_ABI=true ./scripts/shell/build_android_apk.sh
```

macOS 双击入口：

```text
flutter_cook/scripts/macos/build_android_apk.command
```

构建 iOS IPA：

```bash
./scripts/shell/build_ios_ipa.sh
NO_CODESIGN=true ./scripts/shell/build_ios_ipa.sh
```

macOS 双击入口：

```text
flutter_cook/scripts/macos/build_ios_ipa.command
```

常用环境变量：

```bash
MODE=debug|profile|release
DEVICE_ID=<device-id>
TARGET=lib/main.dart
FLAVOR=<flavor-name>
DART_DEFINES="KEY1=VALUE1;KEY2=VALUE2"
PUB_GET=true|false
CLEAN=true|false
```

## Git 边界

提交：

- `lib/`、`test/`、`assets/`、`scripts/`、`pubspec.yaml`、`pubspec.lock`。
- Flutter 多平台工程源文件与配置。
- `ScreenShot/` 中用于 README 展示的截图。

不提交：

- `docs/` 本地设计过程产物。
- `.dart_tool/`、`build/`、`.gradle/`、`.kotlin/`、`.pub-cache/`。
- `.idea/`、`.vscode/`、`*.iml`、`.DS_Store`、日志、临时文件。
- `.env*`、证书、签名文件、Provisioning Profile。
- `*.apk`、`*.aab`、`*.ipa`、`*.xcarchive`、`*.dSYM*`。

已被 Git 跟踪的文件不会因新增 `.gitignore` 自动停止跟踪，需要执行：

```bash
git rm --cached <path>
```

## 开发约定

- Page 保持被动，业务流程放入 Controller / Repository / Service。
- 新页面必须处理 loading、empty、error，并提供 retry 或 refresh。
- UI 优先使用 `CookTokens`、`CookTheme` 和设计系统组件。
- 外部输入与异步响应必须做类型校验，避免直接强转。
- `Obx` 中同时读取响应式列表长度和元素时，先 `toList()` 快照。
- `Get.arguments` 必须先做空值与类型检查。
