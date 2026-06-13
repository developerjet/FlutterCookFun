# CLAUDE.md — Flutter Cook Fun

> **沟通语言**：开发者是中文用户，所有对话、注释、commit message 请使用**简体中文**。代码标识符（变量名、函数名、类名）仍使用英文。

## 项目概述

Flutter Cook Fun 是一个食谱类 Flutter 应用，使用 GetX 进行状态管理、路由和国际化。

## 技术栈

| 分类 | 技术 |
|------|------|
| 框架 | Flutter (SDK >=3.2.3 <4.0.0) |
| 状态管理 | **GetX** (`get: ^4.6.6`) — Obx, GetBuilder, GetPage |
| 网络请求 | **Dio** (`dio: ^5.4.0`) — 自定义 DioClient 单例 |
| 本地存储 | **sqflite** + **shared_preferences** |
| JSON 序列化 | **json_annotation** + **json_serializable** + **build_runner** |
| UI 组件 | **getwidget** (`^7.0.0`), carousel_slider, photo_view |
| 视频播放 | **flick_video_player** + **video_player** |
| WebView | **webview_flutter** |
| 国际化 | GetX Translations (zh_CN 主语言, en_US 后备) |
| 下拉刷新 | **easy_refresh** |

## 项目架构

```
lib/
├── main.dart                  # 入口：GetMaterialApp + ThemeManager + EasyLoading
├── base/                      # 公共基础组件
│   ├── repository/base_repository.dart  # Repository 基类（重试机制）
│   ├── tabs.dart             # 底部 Tab 导航
│   ├── web.dart              # WebView 页面
│   ├── image_viewer.dart     # 图片浏览器
│   └── empty_state_view.dart # 空状态视图
├── binding/                   # GetX Binding（全局/懒加载依赖注入）
├── routers/                   # GetX 路由配置
├── middlewares/               # 路由中间件
├── utils/                     # 工具类
│   ├── constants.dart        # API/Ui/业务常量
│   ├── theme.dart            # 主题管理（亮/暗模式）
│   ├── networking/           # Dio 网络客户端封装
│   ├── error_handler.dart    # 统一错误处理
│   ├── sqlite/               # sqflite 数据库管理
│   ├── language/             # 多语言管理
│   └── toast.dart            # Toast 工具
└── module/                    # 功能模块（按业务划分）
    ├── home/                  # 首页（Banner + 食材分类列表）
    ├── cook/                  # 做菜（步骤 + 配菜）
    ├── book/                  # 菜谱（列表 + 详情）
    ├── search/                # 搜索
    ├── player/                # 视频播放
    ├── mine/                  # 我的（收藏）
    └── setting/               # 设置
```

## 模块内部结构（每个 module 遵循相同模式）

```
module/<name>/
├── controller/    # GetX Controller（业务逻辑 + 状态）
├── model/         # 数据模型（.dart + .g.dart 自动生成）
├── views/         # 可复用 Widget/Cell
├── repository/    # 数据仓库（继承 BaseRepository）
├── binding/       # GetX Binding（可选，按需加载）
└── <name>_page.dart  # 页面入口
```

## 核心开发规范

### 网络请求
- 所有 API 请求通过 `DioClient` 静态方法发起（`DioClient.get/post/put/delete`）
- Repository 继承 `BaseRepository`，使用 `execute()` 方法获得自动重试
- API 基础地址：`http://api.izhangchu.com`
- 所有常量定义在 `utils/constants.dart`

### 状态管理
- 界面状态使用 `Obx(() => ...)` 响应式绑定
- Controller 中响应式变量使用 `.obs` 后缀
- 路由绑定使用 `GetPage(binding: ...)` 进行依赖注入

### JSON 序列化
- 修改 model 后执行：`flutter pub run build_runner build --delete-conflicting-outputs`
- Model 文件使用 `@JsonSerializable()` 注解
- `.g.dart` 文件自动生成，**不要手动编辑**

### 路由
- 路由名称常量定义在 `RouteNames` 类中
- 新页面在 `routers/routers.dart` 的 `AppRouter.routers` 中注册
- 默认使用 iOS 风格过渡动画 `Transition.cupertino`

### 国际化
- 文案定义在 `utils/language/language.dart` 的 `Messages` 类
- 使用 `.tr` 扩展方法获取翻译文本
- 主语言：简体中文（zh_CN），后备语言：英语（en_US）

### 主题
- 主题通过 `ThemeManager` 管理，支持亮色/暗色切换
- `ThemeManager.currentThemeMode` 是响应式变量

## 常用命令

```bash
# 代码生成
flutter pub run build_runner build --delete-conflicting-outputs

# 静态分析
flutter analyze

# 运行测试
flutter test

# 运行应用
flutter run

# 清理构建
flutter clean
```

## 已安装的 Claude Code 插件

| 插件 | 版本 | 用途 |
|------|------|------|
| **superpowers** | 5.1.0 | 核心工作流框架，强制执行 Plan→TDD→Review 工程纪律 |
| **flutter-slipstream** | 1.6.0 | 实时 Flutter 应用自省：截图、Widget 树检查、交互操作、错误捕获、包安全指南 |
| **claude-full-stack-2-0** | 0.2.0 | 全栈技能库，包含 Flutter 专用技能（导航、状态、设计系统、性能、脚手架） |
| **caveman** | latest | 输出极简模式，减少 Claude 输出 Token 65-75%，支持 `/caveman` 切换 |
| **claude-memory** | 0.8.110 | 跨会话记忆持久化，自动压缩摘要 + 语义搜索历史对话 |

### Superpowers 技能清单

| 分类 | 技能 | 说明 |
|------|------|------|
| 🧭 入口 | `using-superpowers` | 会话启动自动加载，分析任务并路由到正确技能 |
| 🧭 规划 | `brainstorming` | 苏格拉底式提问，澄清需求、输出 spec |
| 🧭 规划 | `writing-plans` | 将 spec 拆解为 2-5 分钟原子任务，标注文件路径 |
| 🔨 执行 | `executing-plans` | 按计划逐项实现，带检查点确认 |
| 🔨 执行 | `subagent-driven-development` | 每个任务用全新子代理执行，双重 review 门禁 |
| 🔨 执行 | `dispatching-parallel-agents` | 多个独立任务并行调度子代理 |
| 🔨 执行 | `test-driven-development` | 强制 RED-GREEN-REFACTOR，无失败测试不允许写实现 |
| ✅ 质量 | `verification-before-completion` | 声明完成前强制验证，不过关不准标记完成 |
| ✅ 质量 | `requesting-code-review` | 主动发起代码审查，输出带严重等级的结论 |
| ✅ 质量 | `receiving-code-review` | 逐条核验 review 建议，技术性反驳不合理项 |
| 🐛 调试 | `systematic-debugging` | 四阶段根因分析：调查→模式→假设→修复 |
| 🌿 Git | `using-git-worktrees` | 自动创建隔离 worktree 分支，防止污染主分支 |
| 🌿 Git | `finishing-a-development-branch` | merge/PR/保留/丢弃四种收尾选项 |
| 🛠️ 元 | `writing-skills` | 教你创建自定义 SKILL.md |
