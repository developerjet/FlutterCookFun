import 'package:flutter/material.dart';

/// CookFun V6 设计系统 token。
///
/// 页面、组件和业务状态必须引用这里的语义 token，避免在页面中直接硬编码颜色、尺寸和圆角。
class CookTokens {
  const CookTokens._();

  /// 品牌主色，用于确认、进行中、选中等正向操作。
  static const Color primary = Color(0xFF13C89A);

  /// 深品牌色，用于高对比文字、图标和强调边框。
  static const Color primaryDeep = Color(0xFF087C63);

  /// 主色浅底，用于选中胶囊、轻量提示和低压力背景。
  static const Color primarySoft = Color(0xFFDDF8EE);

  /// 危险色，用于删除、失败、不可逆确认。
  static const Color danger = Color(0xFFF05249);

  /// 危险浅底，用于危险标签和错误态背景。
  static const Color dangerSoft = Color(0xFFFFE5E2);

  /// 暖色，用于食欲、提醒和补全建议。
  static const Color warm = Color(0xFFFF8A3D);

  /// 暖色浅底，用于缺料、提醒类 Chip。
  static const Color warmSoft = Color(0xFFFFEAD8);

  /// 信息色，用于视频、引导和说明。
  static const Color info = Color(0xFF6B5BF5);

  /// 页面底色，避免纯白导致层级发虚。
  static const Color page = Color(0xFFF7F6EE);

  /// 深色页面底色。
  static const Color pageDark = Color(0xFF101815);

  /// 卡片和弹层底色。
  static const Color surface = Color(0xFFFFFFFF);

  /// 深色卡片和弹层底色。
  static const Color surfaceDark = Color(0xFF17211D);

  /// 一级正文。
  static const Color textPrimary = Color(0xFF10231D);

  /// 二级正文。
  static const Color textSecondary = Color(0xFF66756E);

  /// 弱文字。
  static const Color textTertiary = Color(0xFF98A49E);

  /// 细边框。
  static const Color border = Color(0xFFE4E9E4);

  /// 蔬菜语义色。
  static const Color vegetable = Color(0xFF8BC34A);

  /// 蛋白语义色。
  static const Color protein = Color(0xFFF05249);

  /// 主食语义色。
  static const Color staple = Color(0xFFFFC24A);

  /// 调料语义色。
  static const Color seasoning = Color(0xFF6B5BF5);

  /// 页面左右安全边距。
  static const double pagePadding = 20;

  /// 导航栏交互内容与屏幕边缘的安全边距。
  static const double navContentInset = 16;

  /// 最高优先级按钮高度。
  static const double heroButtonHeight = 52;

  /// 上下文按钮高度。
  static const double contextButtonHeight = 44;

  /// 危险操作按钮高度。
  static const double dangerButtonHeight = 48;

  /// Chip 标准高度。
  static const double chipHeight = 36;

  /// 页面头部圆形工具按钮尺寸。
  static const double headerToolButtonSize = 44;

  /// 页面头部工具图标尺寸。
  static const double headerToolIconSize = 24;

  /// 浮动 TabBar 标准高度。
  static const double tabBarHeight = 72;

  /// 极小装饰和细拉手圆角。
  static const double radiusXs = 4;

  /// 小标记和局部裁剪圆角。
  static const double radiusSm = 6;

  /// 图片缩略图和内嵌小容器圆角。
  static const double radiusMd = 8;

  /// 首页主视觉等大尺寸媒体卡片圆角。
  static const double heroCardRadius = 16;

  /// 标准内容卡片圆角。
  static const double cardRadius = 12;

  /// 高密度列表卡片圆角。
  static const double listCardRadius = 10;

  /// 搜索框、输入框圆角。
  static const double inputRadius = 10;

  /// 普通按钮和图标底板圆角。
  static const double controlRadius = 10;

  /// 弹框圆角。
  static const double dialogRadius = 16;

  /// 浮动底部导航容器圆角。
  static const double navigationRadius = tabBarHeight / 2;

  /// Chip、筛选和状态标签的胶囊圆角。
  static const double pillRadius = 999;

  /// 列表卡片内间距。
  static const double cardPadding = 16;

  /// 标准动画时长。
  static const Duration motionNormal = Duration(milliseconds: 260);

  /// 卡片阴影。
  static List<BoxShadow> cardShadow(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.07),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ];
  }
}
