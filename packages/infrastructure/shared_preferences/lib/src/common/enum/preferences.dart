enum Preferences<T> {
  themeColor('COLOR_STYLE', 'dynamicColor'),
  uiStyle('UI_STYLE', 'system'),
  themeMode('THEME_MODE', 'system'),
  goodsViewLayout('GOODS_VIEW_LAYOUT', 'list');

  const Preferences(this.key, this.defaultValue);

  final String key;
  final T defaultValue;
}
