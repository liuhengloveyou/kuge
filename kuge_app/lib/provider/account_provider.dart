import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/service/services.dart';

///登录状态
class UserAccount with ChangeNotifier {
  Map? _user;

  static UserAccount? _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  UserAccount._internal();

  /// 获取单例内部方法
  static _getInstance() {
    // 只能有一个实例
    _instance = UserAccount._internal();

    return _instance;
  }

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory UserAccount.getInstance() => _getInstance();

  Map? get user => _user;

  ///当前是否已登录
  bool get isLogin {
    return (user != null) && (user!["uid"] > 0);
  }

  ///当前登录用户的id
  ///null if not login
  int? get userId {
    if (!isLogin) {
      return null;
    }

    return user!["uid"];
  }

  String? get nickName {
    if (!isLogin) {
      return null;
    }

    return user!["nickname"];
  }

  String? get cellphone {
    if (!isLogin) {
      return null;
    }

    return user!["cellphone"];
  }

  int get gender {
    if (!isLogin) {
      return 0;
    }

    return user!["gender"];
  }

  String get avatarUrl {
    if (!isLogin || user!["avatarUrl"] == null) {
      return "";
    }

    return user!["avatarUrl"];
  }

  static Future<Response> userRegister(String cellphone, String pwd) async {
    return await HttpUtil.getInstance().put(Api.USER_BASE_URL, headers: {"X-API": "register"}, data: {"cellphone": cellphone, "password": generateMd5(pwd)});
  }

  Future<Response> userLogin(String cellphone, String pwd) async {
      var resp = await HttpUtil.getInstance().post(Api.USER_BASE_URL, headers: {"X-API": "login"}, data: {"cellphone": cellphone, "password": generateMd5(pwd)});
      _user = resp.data["data"];

      notifyListeners();
      return resp;
  }

  Future<Response> userLogout() async {
    _user = null;

    try {
      var resp = await HttpUtil.getInstance().get(Api.USER_BASE_URL, headers: {"X-API": "logout"});
      notifyListeners();
      return resp;
    } catch (e) {
      notifyListeners();
      print("logout... $user");
    }

    return Future.error("null");
  }

  fetchUserInfo() {
    HttpUtil.getInstance().get(Api.USER_BASE_URL, headers: {"X-API": "info"}).then((resp) {
      if (resp.data["code"] == 0) {
        _user = resp.data["data"];
        
        notifyListeners();
      }
    }).catchError((e){
        _user = null;
        notifyListeners();
        print(">>>>>>fetchUserInfo logout>>> ${Api.USER_BASE_URL} $e");
    });
  }

  Future<Response> updateNickName(String nickName) async {
    var resp = await HttpUtil.getInstance().post(Api.USER_BASE_URL, headers: {"X-API": "modify"}, data: {"nickname": nickName});
    _user!["nickname"] = nickName;
    
    notifyListeners();
    return resp;
  }

  Future<Response> updateGender(int gender) async {
    var resp = await HttpUtil.getInstance().post(Api.USER_BASE_URL, headers: {"X-API": "modify"}, data: {"gender": gender});
    _user!["gender"] = gender;
    
    notifyListeners();
    return resp;
  }

  Future<Response> updatePWD(String o, String n) async {
    var resp = await HttpUtil.getInstance().post(Api.USER_BASE_URL, headers: {"X-API": "modify/password"}, data: {"o": generateMd5(o), "n": generateMd5(n)});
    if (resp.statusCode == 0) {
      userLogout();
    }
    
    return resp;
  }

  updateAvatar(List<int> imgData) async {
    var fileData = MultipartFile.fromBytes(imgData, filename: "file");
    FormData formData = FormData.fromMap({
      "type": "png",
      "file": fileData
    });

    return await HttpUtil.getInstance().post(Api.USER_BASE_URL, headers: {"X-API": "modify/avatarForm"}, data: formData);
  }
}
