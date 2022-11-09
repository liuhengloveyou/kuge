import 'package:flutter/material.dart';
import 'package:kuge_app/pages/settings/settings.dart';
import 'package:provider/provider.dart';

class SettingThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("主题设置")
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8, top: 16, bottom: 6),
            child: const Text("主题模式", style: TextStyle(color: Color.fromARGB(255, 175, 175, 175))),
          ),

          RadioListTile<ThemeMode>(
            onChanged: (mode) => context.read<Settings>().themeMode = mode!,
            groupValue: Provider.of<Settings>(context).themeMode,
            value: ThemeMode.system,
            title: const Text("跟随系统"),
          ),
          RadioListTile<ThemeMode>(
            onChanged: (mode) => context.read<Settings>()..themeMode = mode!,
            groupValue: Provider.of<Settings>(context).themeMode,
            value: ThemeMode.light,
            title: const Text("亮色主题"),
          ),
          RadioListTile<ThemeMode>(
            onChanged: (mode) => context.read<Settings>()..themeMode = mode!,
            groupValue: Provider.of<Settings>(context).themeMode,
            value: ThemeMode.dark,
            title: const Text("暗色主题"),
          ),
        ],
      ),
    );
  }
}

class _DarkThemeSwitchGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8, top: 16, bottom: 6),
            child: const Text("暗色颜色主题选择", style: TextStyle(color: Color.fromARGB(255, 175, 175, 175))),
          ),
          RadioListTile(
            onChanged: null,
            groupValue: null,
            value: null,
            selected: true,
            title: Container(
                color: Provider.of<Settings>(context).darkTheme.primaryColor,
                height: 20),
          )
        ]);
  }
}

// class _LightThemeSwitchGroup extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           child: Text("亮色主题颜色选择", style: TextStyle(color: const Color.fromARGB(255, 175, 175, 175))),
//           padding: const EdgeInsets.only(left: 8, top: 16, bottom: 6),
//         ),
//         ...quietThemes.map((theme) => _RadioLightThemeTile(themeData: theme))
//       ],
//     );
//   }
// }

class _RadioLightThemeTile extends StatelessWidget {
  final ThemeData themeData;

  const _RadioLightThemeTile({Key? key, required this.themeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var setting = context.watch<Settings>();

    return RadioListTile<ThemeData>(
      value: themeData,
      groupValue: setting.theme,
      onChanged: (theme) => setting.theme = theme!,
      activeColor: themeData.primaryColor,
      title: Container(color: themeData.primaryColor, height: 20),
    );
  }
}
