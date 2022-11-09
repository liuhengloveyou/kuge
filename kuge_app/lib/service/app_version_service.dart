import 'package:flutter/cupertino.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/model/app_version_model.dart';

typedef OnSuccess<T> = Function(T onSuccess);
typedef OnFail = Function(String onFail);

class AppVersionService {
  Future appVersionService(BuildContext context, {Map<String, dynamic>? parameters,required OnSuccess onSuccess, required OnFail onFail}) async {
    try {
      var response = await HttpUtil.getInstance().get(Api.APP_VERSION_URL, parameters: parameters);
      if (response.data['code'] == 0) {
        AppVersionModel appVersionModel = AppVersionModel.fromJson(response.data['data']);
        onSuccess(appVersionModel);
      } else {
        onFail(response.data['message']);
      }
    } catch (e) {
      print('e==>$e');
    }
  }
}
