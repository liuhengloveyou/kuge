import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/audio_player/audioPlayerBackgroundTask.dart';
import 'package:kuge_app/root_page.dart';
import 'package:provider/provider.dart';
import 'package:kuge_app/utils/general_util.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/pages/search/model_search_history.dart';
import 'package:kuge_app/pages/settings/settings.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:kuge_app/provider/current_index.dart';
import 'package:kuge_app/provider/new_dish.dart';
import 'package:kuge_app/provider/liked_song.provider.dart';
import 'package:kuge_app/provider/songListTag_provider.dart';
import 'package:kuge_app/provider/song_detail.dart';
import 'package:kuge_app/service/downloaderManager.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/global.dart';


Future<void>  main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
    debug: true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

  Global.audioHandler = await AudioService.init(
    builder: () => AudioPlayerBackgroundTask(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'kuge.channel.audio',
      androidNotificationChannelName: 'kugeAudioPlayback',
      androidNotificationOngoing: true,
    ),
  );

  Global.init(() => runApp(const MyApp()));

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //状态栏
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent, //Color(0xfff0f0f0), //虚拟按键背景色
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark, //虚拟按键图标色
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DownloaderManager.getInstance().prepare(context);
    UserAccount.getInstance().fetchUserInfo();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Settings()),
          ChangeNotifierProvider(create: (_) => NewDishProvider()),
          ChangeNotifierProvider(create: (_) => CurrentIndexProvider()),
          ChangeNotifierProvider(create: (_) => SongDetailProvider()),
          ChangeNotifierProvider(create: (_) => KugeAudioPlayer.getInstance()),
          ChangeNotifierProvider(create: (_) => SearchHistory()),
          ChangeNotifierProvider(create: (_) => LikeSong()),
          ChangeNotifierProvider(create: (_) => UserAccount.getInstance()),
          ChangeNotifierProvider(create: (_) => SongListTagProvider()),
        ],
        child: StyledToast(
            locale: const Locale('zh', 'CN'),
            child: Consumer<Settings>(builder: (context, setting, child) {
              return MaterialApp(
                title: '酷歌音乐',
                debugShowCheckedModeBanner: false,
                theme: setting.theme,
                darkTheme: setting.darkTheme,
                themeMode: setting.themeMode,
                navigatorKey: navGK,
                onGenerateRoute: (settings) => Routes.findRoute(settings),
                home:  EnterPage(), // const MyHomePage(title: 'test')
              );
            })));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class EnterPage extends StatefulWidget {
  @override
  _EnterPageState createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  @override
  void initState() {
    super.initState();

    // AudioService.start(
    //   backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
    //   androidNotificationChannelName: 'com.alokuge.app Audio-Service',
    //   androidNotificationColor: 0xFF2196f3,
    //   androidNotificationIcon: 'mipmap/launcher_icon',
    //   androidEnableQueue: true,
    // );

    // _getAppVersion(context);
  }

  @override
  Widget build(BuildContext context) {
    return const RootPage();
  }

  // _getAppVersion(BuildContext context) {
  //   String? savedVersion = SpUtil.getString(Global.APP_VERSION);
  //   PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
  //     await SpUtil.putString(Global.APP_VERSION, packageInfo.version);
  //     AppVersionProvider().appVersion(context, packageInfo.version);
  //   });
  // }
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
