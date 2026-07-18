import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defines interface asset paths', () {
    expect(CookAssets.appLogo, 'assets/images/app_logo.png');
    expect(CookAssets.tabHome, 'assets/images/tab_home.png');
    expect(CookAssets.tabHomeActive, 'assets/images/tab_home_active.png');
    expect(CookAssets.tabCook, 'assets/images/tab_cook.png');
    expect(CookAssets.tabCookActive, 'assets/images/tab_cook_active.png');
    expect(CookAssets.tabRecipe, 'assets/images/tab_recipe.png');
    expect(CookAssets.tabRecipeActive, 'assets/images/tab_recipe_active.png');
    expect(CookAssets.tabMine, 'assets/images/tab_mine.png');
    expect(CookAssets.tabMineActive, 'assets/images/tab_mine_active.png');
    expect(CookAssets.iconSearch, 'assets/images/icon_search.png');
    expect(CookAssets.iconDelete, 'assets/images/icon_delete.png');
    expect(CookAssets.iconArrowRight, 'assets/images/icon_arrow_right.png');
    expect(CookAssets.iconCheck, 'assets/images/icon_check.png');
    expect(CookAssets.iconUncheck, 'assets/images/icon_uncheck.png');
    expect(CookAssets.iconFavorite, 'assets/images/icon_favorite.png');
    expect(
      CookAssets.iconFavoriteActive,
      'assets/images/icon_favorite_active.png',
    );
    expect(CookAssets.iconVideoPlay, 'assets/images/icon_video_play.png');
    expect(CookAssets.bannerPlaceholder,
        'assets/images/bg_banner_placeholder.png');
    expect(
        CookAssets.imagePlaceholder, 'assets/images/bg_image_placeholder.png');
  });

  test('does not expose versioned asset names', () {
    const paths = <String>[
      CookAssets.appLogo,
      CookAssets.tabHome,
      CookAssets.tabHomeActive,
      CookAssets.tabCook,
      CookAssets.tabCookActive,
      CookAssets.tabRecipe,
      CookAssets.tabRecipeActive,
      CookAssets.tabMine,
      CookAssets.tabMineActive,
      CookAssets.iconSearch,
      CookAssets.iconDelete,
      CookAssets.iconArrowRight,
      CookAssets.iconCheck,
      CookAssets.iconUncheck,
      CookAssets.iconFavorite,
      CookAssets.iconFavoriteActive,
      CookAssets.iconVideoPlay,
      CookAssets.iconRefresh,
      CookAssets.iconSettings,
      CookAssets.iconShare,
      CookAssets.iconClose,
      CookAssets.iconSmart,
      CookAssets.bannerPlaceholder,
      CookAssets.imagePlaceholder,
    ];

    expect(paths, everyElement(isNot(contains('v6_'))));
  });
}
