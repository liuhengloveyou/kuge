import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

part 'theme.dart';

const _prefix = 'settings:';
const _key_theme = "$_prefix:theme";
const _key_theme_mode = "$_prefix:themeMode";
const _key_copyright = "$_prefix:copyright";
const _key_skip_welcome_page = '$_prefix:skipWelcomePage';

class Settings with ChangeNotifier {
  ThemeData? _theme;

  Settings() {
    _themeMode = ThemeMode
        .values[SpUtil.getInt(_key_theme_mode) ?? 0]; /* default is system */
    _theme = _themeMode == ThemeMode.dark ? kugeDarkTheme : kugeTheme;
    _showCopyrightOverlay = SpUtil.getBool(_key_copyright)!;
    _skipWelcomePage = SpUtil.getBool(_key_skip_welcome_page) ?? false;
  }

  ThemeData get theme => _theme!;

  set theme(ThemeData theme) {
    _theme = theme;
    // final index = quietThemes.indexOf(theme);
    // SpUtil.putInt(_key_theme, index);
    notifyListeners();
  }

  ThemeData get darkTheme => kugeDarkTheme;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    SpUtil.putInt(_key_theme_mode, themeMode.index);
    notifyListeners();
  }

  bool _showCopyrightOverlay = false;
  bool get showCopyrightOverlay => _showCopyrightOverlay;

  set showCopyrightOverlay(bool show) {
    _showCopyrightOverlay = show;
    SpUtil.putBool(_key_copyright, show);
    notifyListeners();
  }

  bool _skipWelcomePage = false;
  bool get skipWelcomePage => _skipWelcomePage;

  void setSkipWelcomePage() {
    _skipWelcomePage = true;
    SpUtil.putBool(_key_skip_welcome_page, true);
    notifyListeners();
  }
}
