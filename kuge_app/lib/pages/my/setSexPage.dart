import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:provider/provider.dart';

class SetSexPage extends StatefulWidget {
  @override
  _SetSexPageState createState() => _SetSexPageState();
}

class _SetSexPageState extends State<SetSexPage> {
  late UserAccount _userInfo;
  int curVal = 0;

  @override
  void initState() {
    super.initState();

    _userInfo = context.read<UserAccount>();
    curVal = _userInfo.gender;
  }

  void submit() async {
    if (curVal != 1 && curVal != 2) {
      showToast("请选择性别", position: StyledToastPosition.center);
      return;
    }

    var resp = await _userInfo.updateGender(curVal);
    if (resp.data['code'] != 0) {
      showToast(resp.data['errmsg'], position: StyledToastPosition.center);
    } else {
      showToast("更新成功", position: StyledToastPosition.center);
      Navigator.pop(context);
    }
  }
  
  Widget _myRadio(int val, String title){
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: RadioListTile(
        activeColor: Colors.blue,
        title: Text(title, textAlign: TextAlign.left),
        groupValue: curVal,
        value: val,
        onChanged: (int? val){
          setState(() {
            curVal = val!;
          });           
        }
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('设置性别'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () => submit()),
          ],
        ),
        // backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            _myRadio(1, "男"),
            _myRadio(2, "女"),
          ]))
        );
  }
}
