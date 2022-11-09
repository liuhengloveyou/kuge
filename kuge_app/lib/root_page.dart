import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/pages/artists/singers.dart';
import 'package:kuge_app/pages/find/find.dart';
import 'package:kuge_app/pages/my/my.dart';
import 'package:kuge_app/pages/songlist/songlistPlaza.page.dart';
import 'package:kuge_app/route/routes.dart';
import 'audio_player/bottomPlayerIcon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RootPage extends StatefulWidget {
  final int index;

  const RootPage({super.key, this.index = 0});

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  List<BottomNavigationBarItem> bottomTabs = [];
  PageController? _pageController;

  final List<Widget> tabBodies = [
    FindPage(),
    // SongListPage("SongListPage"),
    PlaylistPlaze(),
    // AlbumPlaze(),
    Container(),
    // FriendPage(),
    SingersPage(),
    MyPage(),
    // AccountPage(),
  ];

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);

    // if(Api.isShowLog){
    //   ///display overlay button 显示悬浮按钮
    //   showDebugBtn(context);

    //   ///cancel overlay button 取消悬浮按钮
    //   dismissDebugBtn();
    // }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));

    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        curveSize: 50,
        backgroundColor: Theme.of(context).primaryColor,
        color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        activeColor: Colors.red,
        style: TabStyle.fixedCircle,
        top: -10,
        items: [
          TabItem(title: '发现',
            icon: Image.asset('assets/images/bottom/find.png', color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
            activeIcon: Image.asset('assets/images/bottom/find_selected.png')),
          TabItem(
            title: '歌单',
            icon: Image.asset('assets/images/bottom/my.png', color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
            activeIcon: Image.asset('assets/images/bottom/my_selected.png'),
          ),
          const TabItem(
            icon: BottomNavigationIcon(),
            activeIcon: BottomNavigationIcon(),
          ),
          TabItem(
            title: '歌手',
            icon: Image.asset('assets/images/bottom/friend.png', color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
            activeIcon: Image.asset('assets/images/bottom/friend_selected.png'),
          ),
          TabItem(
            title: '我的',
            icon: Image.asset('assets/images/bottom/account.png', color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor),
            activeIcon: Image.asset('assets/images/bottom/account_selected.png'),
          ),
        ],
        initialActiveIndex: 0,
        onTap: (int index) {
          if (index == 2) {
            Navigator.pushNamed(context, Routes.playerPage);
            return;
          }
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        }
      ),

      // BottomNavigationBar(
      //   onTap: (index) {
      //     if (index == 2) {
      //       Navigator.pushNamed(context, Routes.playerPage);
      //       return false;
      //     }
      //     setState(() => _currentIndex = index);
      //     _pageController.jumpToPage(index);
      //   },
      //   currentIndex: _currentIndex,
      //   elevation: 0,
      //   type: BottomNavigationBarType.fixed,
      //   // backgroundColor: Colors.white,
      //   selectedLabelStyle: TextStyle(fontSize: 24.sp),
      //   unselectedLabelStyle: TextStyle(fontSize: 24.sp),
      //   selectedItemColor: Colors.red,
      //   unselectedItemColor: Theme.of(context).bottomAppBarColor,
      //   items: [
      //     BottomNavigationBarItem(
      //       label: '发现',
      //       icon: Image.asset(
      //         'assets/images/bottom/find.png',
      //         width: 64.w,
      //         height: 42.h,
      //       ),
      //       activeIcon: Image.asset(
      //         'assets/images/bottom/find_selected.png',
      //         width: 64.w,
      //         height: 42.h,
      //       ),
      //       backgroundColor: Colors.white,
      //     ),
      //     BottomNavigationBarItem(
      //       label: '歌单',
      //       icon: Image.asset(
      //         'assets/images/bottom/my.png',
      //         width: 48.w,
      //         height: 34.h,
      //       ),
      //       activeIcon: Image.asset(
      //         'assets/images/bottom/my_selected.png',
      //         width: 64.w,
      //         height: 42.h,
      //       ),
      //     ),
      //     // BottomNavigationBarItem(
      //     //   label: '专辑',
      //     //   icon: Image.asset(
      //     //     'assets/images/bottom/video.png',
      //     //     width: 64.w,
      //     //     height: 42.h,
      //     //   ),
      //     //   activeIcon: Image.asset(
      //     //     'assets/images/bottom/video_selected.png',
      //     //     width: 64.w,
      //     //     height: 42.h,
      //     //   ),
      //     // ),
      //     BottomNavigationBarItem(
      //       label: '',
      //       icon: BottomNavigationIcon(),
      //       activeIcon: BottomNavigationIcon(),
      //     ),
      //     BottomNavigationBarItem(
      //       label: '歌手',
      //       icon: Image.asset(
      //         'assets/images/bottom/friend.png',
      //         width: 64.w,
      //         height: 42.h,
      //       ),
      //       activeIcon: Image.asset(
      //         'assets/images/bottom/friend_selected.png',
      //         width: 64.w,
      //         height: 42.h,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: '我的',
      //       icon: Image.asset(
      //         'assets/images/bottom/account.png',
      //         width: 64.w,
      //         height: 42.h,
      //       ),
      //       activeIcon: Image.asset(
      //         'assets/images/bottom/account_selected.png',
      //         width: 64.w,
      //         height: 42.h,
      //       ),
      //     ),
      //   ],
      // ),
      
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: tabBodies,
      ),
    );
  }
}
