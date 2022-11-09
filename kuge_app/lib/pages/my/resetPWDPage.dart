import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/service/user.service.dart';


class ReSetPWDQuestionPage extends StatefulWidget {
  @override
  _ReSetPWDQuestionPageState createState() => _ReSetPWDQuestionPageState();
}

class _ReSetPWDQuestionPageState extends State<ReSetPWDQuestionPage> {
  final controller = TextEditingController();
  final _phoneController= TextEditingController();

  int currValue = 0;

  @override
  void initState() {
    super.initState();
  }

  _openAlertDialog() async  {
    await showDialog(
      context: context,
      barrierDismissible: false,//// user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('警告'),
            content: const Text('密码已经成功重置成 123456 ! 请马上登录修改密码.'),
            actions: <Widget>[
              TextButton(child: const Text('确认'),onPressed: () =>Navigator.of(context).pop()),
            ],
        );
    });
  }

  void submit() async {
    if (currValue == 0) {
      showToast("请选择你的密码保护问题", position: StyledToastPosition.center);
      return;
    }
    if (controller.text.trim() == "") {
      showToast("请输入你的答案", position: StyledToastPosition.center);
      return;
    }
    if (_phoneController.text.trim() == "") {
      showToast("请输入你的注册手机号", position: StyledToastPosition.center);
      return;
    }

    var resp = await UsersService.resetPWD(_phoneController.text.trim(), currValue, controller.text.trim());
    if (resp.data['code'] != 0) {
      showToast(resp.data['errmsg'], position: StyledToastPosition.center);
    } else {
      await _openAlertDialog();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('通过密码保护问题重置密码'),
        ),
        // backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            DropdownButton(
            isExpanded: true,
            underline: Container(height: 0),
            hint:const Text('下拉选择你的密码保护问题'),
            value: currValue,
            items: const [
              DropdownMenuItem(value: 1, child: Text('你爸爸的名字是什么?')),
              DropdownMenuItem(value: 2, child: Text('你小学在哪读的?')),
              DropdownMenuItem(value: 3, child: Text('一个你喜欢的电影名?'))
            ], 
            onChanged: (value) {
              setState(() {
                currValue = value!;
              });
            }),
          TextField(
            controller: controller,
            maxLines: 1,//最大行数
            maxLength: 100,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
            textAlign: TextAlign.left,//文本对齐方式
            decoration: const InputDecoration(
              hintText: '请输入你的答案',
              focusColor: Colors.white,
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
              enabledBorder: null,
              disabledBorder: null
            )
          ),
          TextField(
            controller: _phoneController,
            maxLines: 1,//最大行数
            maxLength: 11,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
            textAlign: TextAlign.left,//文本对齐方式
            decoration: const InputDecoration(
              hintText: '请输入你的注册手机号',
              focusColor: Colors.white,
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
              enabledBorder: null,
              disabledBorder: null
            )
          ),
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
