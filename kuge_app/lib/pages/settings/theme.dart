part of 'settings.dart';

//网易红调色板
const _swatchNeteaseRed = MaterialColor(0xFFdd4237, {
  900: Color(0xFFae2a20),
  800: Color(0xFFbe332a),
  700: Color(0xFFcb3931),
  600: Color(0xFFdd4237),
  500: Color(0xFFec4b38),
  400: Color(0xFFe85951),
  300: Color(0xFFdf7674),
  200: Color(0xFFea9c9a),
  100: Color(0xFFfcced2),
  50: Color(0xFFfeebee),
});

//app主题
final kugeTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    dividerColor: const Color(0xfff5f5f5),
    iconTheme: const IconThemeData(color: Color(0xFFb3b3b3)),
    backgroundColor: Colors.white,
    primaryColorLight: Colors.grey[200],
    bottomAppBarColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.black,
    ),
  );
  

final kugeDarkTheme = ThemeData.dark().copyWith(bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(unselectedItemColor: Colors.grey[200]));