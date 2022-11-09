import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:provider/provider.dart';

class SetNamePage extends StatefulWidget {
  @override
  _SetNamePageState createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  UserAccount? _userInfo;
  final controller = TextEditingController();

  void submit() async {
    String nickName = controller.text;
    if (nickName == "" || nickName.isEmpty || nickName.length > 45) {
      showToast("请正确输入用户名", position: StyledToastPosition.center);
      return;
    }

    var resp = await _userInfo!.updateNickName(nickName);
    if (resp.data['code'] != 0) {
      showToast(resp.data['errmsg'], position: StyledToastPosition.center);
    } else {
      showToast("更新成功", position: StyledToastPosition.center);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _userInfo = context.watch<UserAccount>();
    controller.value = TextEditingValue(text: _userInfo!.nickName!);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: const Text('设置名字'),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.done_all),onPressed: () => submit()),
          ],
        ),
        // backgroundColor: Colors.white,
      body: Container(alignment: Alignment.topCenter,
          child: TextField(
            controller: controller,
            maxLength: 45,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
            maxLines: 1,//最大行数
            autofocus: true,//是否自动对焦
            obscureText: false,//是否是密码
            textAlign: TextAlign.left,//文本对齐方式
            style: const TextStyle(fontSize: 30.0),//输入文本的样式
            decoration: const InputDecoration(
              focusColor: Colors.white,
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
              enabledBorder: null,
              disabledBorder: null
            ),
          )
      )
    );
  }
}