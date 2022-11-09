import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:provider/provider.dart';

class SetPWDPage extends StatefulWidget {
  @override
  _SetPWDPageState createState() => _SetPWDPageState();
}

class _SetPWDPageState extends State<SetPWDPage> {
  final controller = TextEditingController();
  final nController = TextEditingController();
  final nnController = TextEditingController();
  UserAccount? _userInfo;

  @override
  void initState() {
    super.initState();

    _userInfo = context.read<UserAccount>();
  }

  void submit() async {
    if (controller.text.trim() == "") {
      showToast("请输入旧密码", position: StyledToastPosition.center);
      return;
    }

    if (nController.text.trim() != nnController.text.trim()) {
      showToast("两次输入的新密码不一致", position: StyledToastPosition.center);
      return;
    }

    var resp = await _userInfo!.updatePWD(controller.text.trim(), nController.text.trim());
    if (resp.data['code'] != 0) {
      showToast(resp.data['errmsg'], position: StyledToastPosition.center);
    } else {
      showToast("更新成功", position: StyledToastPosition.center);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('修改密码'),
        ),
        // backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            TextField(
              autofocus: true,//是否自动对焦
              obscureText: true,
              controller: controller,
              maxLength: 45,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
              maxLines: 1,//最大行数
              textAlign: TextAlign.left,//文本对齐方式
              decoration: const InputDecoration(
                hintText: '请输入旧密码',
                focusColor: Colors.white,
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                border: InputBorder.none,
                enabledBorder: null,
                disabledBorder: null
              ),
            ),
          TextField(
            controller: nController,
            maxLines: 1,//最大行数
            obscureText: true,//是否是密码
            textAlign: TextAlign.left,//文本对齐方式
            decoration: const InputDecoration(
              hintText: '输入新密码',
              focusColor: Colors.white,
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
              enabledBorder: null,
              disabledBorder: null
            ),
          ),
          TextField(
            controller: nnController,
            maxLength: 45,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
            maxLines: 1,//最大行数
            obscureText: true,//是否是密码
            textAlign: TextAlign.left,//文本对齐方式
            decoration: const InputDecoration(
              hintText: '再次输入新密码',
              focusColor: Colors.white,
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
              enabledBorder: null,
              disabledBorder: null
            )),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
            child: MaterialButton(
              minWidth: double.infinity,
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).primaryColorDark,
              child: const Text('提 交'),
              onPressed: () => submit()
          ))
          ]))
        );
  }
}
