// ignore_for_file: non_constant_identifier_names,library_prefixes
class Api {
  ///是否是发布版
  static bool IS_RELEASE = false;

  ///是否显示l悬浮log日志
  static bool isShowLog = false;

  ///api版本
  static String apiVersion = '';

  static String FILE_HOST = 'http://file.kuge.app/';

  ///基本路径
  // static String DEBUG_API_BASE_URL = 'http://10.0.2.2:10003';
  // static String DEBUG_USER_BASE_URL = 'http://10.0.2.2:10003/user';
    static String DEBUG_API_BASE_URL = 'http://localhost:10003';
  static String DEBUG_USER_BASE_URL = 'http://localhost:10003/user';
  
  static String RELEASE_API_BASE_URL = 'http://api.kuge.app/api';
  static String RELEASE_USER_BASE_URL = 'http://api.kuge.app/user';

  static String API_BASE_URL = IS_RELEASE ? RELEASE_API_BASE_URL : DEBUG_API_BASE_URL;
  static String USER_BASE_URL = IS_RELEASE ? RELEASE_USER_BASE_URL : DEBUG_USER_BASE_URL;

  // 系统
  static String APP_VERSION_URL = '$API_BASE_URL/system/app/version';

  /// 用户信息
  static String USER_PWDQUESTION_API_URL = "$API_BASE_URL/users/pwdquestion";
  static String USER_RESETPWD_API_URL = "$API_BASE_URL/users/resetpwd";
  static String USER_FEEDBACK_API_URL = "$API_BASE_URL/users/feedback";
  static String USER_UPDATE_API_URL = "$API_BASE_URL/users/update";
  static String USER_INFO_API_URL = "$API_BASE_URL/users/info";

  /// 搜索
  static String SEARCH_API_URL = "$API_BASE_URL/s";

  /// 私人推荐
  static String PERSONALIZED_PLAYLIST_API = "$API_BASE_URL/personalized/playlist";
  static String PERSONALIZED_SONG_API = "$API_BASE_URL/personalized/song";

  /// 歌单
  static String PLAYLIST_API_URL =  "$API_BASE_URL/playlist";
  static String PLAYLIST_DETAIL_API_URL =  "$API_BASE_URL/playlist/detail";

  /// 专辑
  static String ALBUM_API_URL = '$API_BASE_URL/album';
  static String ALBUM_DETAIL_API_URL = "$API_BASE_URL/album/detail";

  /// 歌手
  static String ARTIST_API_URL = "$API_BASE_URL/artist";
  static String ARTIST_DETAIL_API_URL = "$API_BASE_URL/artist/detail";

  /// 单曲
  static String SONGS_INFO_API_URL = "$API_BASE_URL/song/infos";
}
