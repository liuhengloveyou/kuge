import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/pages/album/album_info_page.dart';
import 'package:kuge_app/pages/artists/artist_detail.page.dart';
import 'package:kuge_app/pages/find/find.dart';
import 'package:kuge_app/pages/my/downloadManager.page.dart';
import 'package:kuge_app/pages/my/feedback.page.dart';
import 'package:kuge_app/pages/my/login_page.dart';
import 'package:kuge_app/pages/my/play_history.page.dart';
import 'package:kuge_app/pages/my/register_page.dart';
import 'package:kuge_app/pages/my/settings/setting_theme_page.dart';
import 'package:kuge_app/pages/playing/playing_page.dart';
import 'package:kuge_app/pages/songlist/songlistPlaza.page.dart';
import 'package:kuge_app/pages/songlist_detail/songlistdetail.page.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:kuge_app/route/custom_route.dart';

class Routes {
  static const String theme_setting_page = 'theme_setting';
  static const String home_page = 'home_page';
  static const String root_page = 'root_page';
  static const String pageSearch = "search";
  static const String songListPage = "songListPage";
  static const String songListDetailPage = "songListDetailPage";
  static const String playerPage = "playerPage";
  static const String playHistoryPage = "playHistoryPage";
  static const String myCollectionPage = "myCollectionPage";
  static const String downLoadMangerPage = "downLoadMangerPage";
  static const String artistDetailPage = "ArtistDetailPage";
  static const String registerPage = "RegisterPage";
  static const String loginPage = "LoginPage";
  static const String albumInfoPage = "AlbumInfoPage";
  static const String feedbackPage = "FeedbackPage";

  static Route findRoute(RouteSettings settings) {
    String name = settings.name!;
    Object? arguments = settings.arguments;

    if (name == feedbackPage) {
      if (false ==  UserAccount.getInstance().isLogin) {
        showToast("请登录", position: StyledToastPosition.center, duration: const Duration(seconds: 2));
        name = loginPage;
      }
    }
    return CustomRouteFade(_findRoute(name, arguments));
  }

  static Widget _findRoute(String name, dynamic? arguments) {
    late Widget page;

    switch (name) {
      case home_page:
        page = FindPage();
        break;
      case songListPage:
        page = PlaylistPlaze();
        break;
      case songListDetailPage:
        page = PlaylistDetailPage(arguments);
        break;
      case theme_setting_page:
        page = SettingThemePage();
        break;
      case playerPage:
        page = PlayingPage();
        break;
      case playHistoryPage:
        page = PlayHistoryPage();
        break;
      // case myCollectionPage:
      //   page = MyCollectionPage();
      //   break;
      case downLoadMangerPage:
        page = DownLoadMangerPage();
        break;
      case artistDetailPage:
        page = ArtistDetailPage(arguments);
        break;
      case registerPage:
        page = RegisterPage();
        break;
      case loginPage:
        page = LoginPage();
        break;
      case albumInfoPage: 
        page = AlbumInfoPage(arguments);
        break;
      case feedbackPage:
      page = FeedbackPage();
      break;
    }

    return page;
  }
}
