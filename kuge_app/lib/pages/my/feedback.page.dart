import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/service/user.service.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final controller = TextEditingController();

  int currValue = 0;
  List<String> feedbackTypes = ["意见或建议", "求歌", "其它"];

  @override
  void initState() {
    super.initState();
  }

  void submit() async {
    if (currValue < 0 || currValue >feedbackTypes.length) {
      showToast("请选择你反馈的问题类型", position: StyledToastPosition.center);
      return;
    }
    if (controller.text.trim() == "") {
      showToast("请输入你要反馈的内容", position: StyledToastPosition.center);
      return;
    }

    var resp = await UsersService.addFeedback(feedbackTypes[currValue], controller.text.trim());
    if (resp.data['code'] != 0) {
      showToast(resp.data['errmsg'], position: StyledToastPosition.center);
    } else {
      showToast("反馈成功", position: StyledToastPosition.center);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: const Text('意见&建议'),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            DropdownButton(
            isExpanded: true,
            underline: Container(height: 0),
            hint:const Text('下拉选择你反馈的问题类型'),
            value: currValue,
            items: feedbackTypes.asMap().entries.map((entry) => DropdownMenuItem(value:entry.key, child: Text(entry.value))).toList(), 
            onChanged: (value) {
              setState(() {
                currValue = value!;
              });
            }),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: controller,
              maxLength: 100,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
              maxLines: 5,//最大行数
              textAlign: TextAlign.left,//文本对齐方式
              decoration: InputDecoration(
                hintText: '输入你要反馈的内容...求多首歌可以用逗号分割',
                fillColor: Theme.of(context).primaryColorLight,
                filled: true,
                contentPadding: const EdgeInsets.all(10.0),
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
