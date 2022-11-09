import 'dart:async';
import 'package:dio/dio.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/service/services.dart';


class UsersService {
  static Future<Response> fetchUserInfo() async {
    return await HttpUtil.getInstance().get(Api.USER_INFO_API_URL);
  }

  static Future<Response> addFeedback(String feedbackType, String feedbackContent) async {
    return await HttpUtil.getInstance().post(Api.USER_FEEDBACK_API_URL, data: {"feedbackType": feedbackType, "feedbackContent": feedbackContent});
  }
  
  static Future<Response> setPWDQuestion(String pwd, int question, String answer) async {
    return await HttpUtil.getInstance().post(Api.USER_PWDQUESTION_API_URL, data: {"pwd": generateMd5(pwd), "question": question, "answer": generateMd5(answer)});
  }

  static Future<Response> resetPWD(String cellphone, int question, String answer) async {
    return await HttpUtil.getInstance().post(Api.USER_RESETPWD_API_URL, data: {"cellphone": cellphone, "question": question, "answer": generateMd5(answer)});
  }

  static Future<Response> updateSongPlayHistory(List<int> songPlayHistory) async {
    return await HttpUtil.getInstance().post(Api.USER_UPDATE_API_URL, data: {"song_play_history": songPlayHistory});
  }

  static Future<Response> updateSongCollect(List<int> songCollect) async {
    return await HttpUtil.getInstance().post(Api.USER_UPDATE_API_URL, data: {"song_collect": songCollect});
  }
}
