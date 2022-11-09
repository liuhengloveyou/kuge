import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/service/user.service.dart';

class SetPWDQuestionPage extends StatefulWidget {
  @override
  _SetPWDQuestionPageState createState() => _SetPWDQuestionPageState();
}

class _SetPWDQuestionPageState extends State<SetPWDQuestionPage> {
  final controller = TextEditingController();
  final nController = TextEditingController();

   int currValue = 0;

  @override
  void initState() {
    super.initState();
  }

  void submit() async {
    if (currValue == 0) {
      showToast("请选择你想要的问题", position: StyledToastPosition.center);
      return;
    }
    if (controller.text.trim() == "") {
      showToast("请输入登录密码", position: StyledToastPosition.center);
      return;
    }
    if (nController.text.trim() == "") {
      showToast("请输入你的答案", position: StyledToastPosition.center);
      return;
    }

    var resp = await UsersService.setPWDQuestion(controller.text.trim(), currValue, nController.text.trim());
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
          title: const Text('设置密码保护问题'),
        ),
        // backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            DropdownButton(
            isExpanded: true,
            underline: Container(height: 0),
            hint:const Text('下拉选择你想要的问题'),
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
            controller: nController,
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
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              obscureText: true,
              controller: controller,
              maxLength: 45,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
              maxLines: 1,//最大行数
              textAlign: TextAlign.left,//文本对齐方式
              decoration: const InputDecoration(
                hintText: '请输入登录密码',
                focusColor: Colors.white,
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                border: InputBorder.none,
                enabledBorder: null,
                disabledBorder: null
              ),
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
