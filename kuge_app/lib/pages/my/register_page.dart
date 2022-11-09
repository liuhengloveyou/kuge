import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/provider/account_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text("欢迎注册酷歌音乐"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(80),
            right: ScreenUtil().setWidth(80),
            top: ScreenUtil().setWidth(100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png',
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setWidth(120),
              ),
              _LoginAnimatedWidget(
                animation: _animation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatefulWidget {
  @override
  __LoginWidgetState createState() => __LoginWidgetState();
}

class __LoginWidgetState extends State<_LoginWidget> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.red),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
            child: const Text('酷歌音乐',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(3), bottom: ScreenUtil().setWidth(30)),
            child: const Text('让音乐陪伴生活',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              )),
          ),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            decoration: const InputDecoration(
                hintText: '手机号码',
                prefixIcon: Icon(
                  Icons.phone_iphone,
                  color: Colors.grey,
                )),
          ),
          TextField(
            obscureText: true,
            controller: _pwdController,
            decoration: const InputDecoration(
                hintText: '密码',
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                )),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          MaterialButton(
            minWidth: double.infinity,
            color: Theme.of(context).primaryColor,
            child: const Text('提交注册'),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              String phone = _phoneController.text;
              String pwd = _pwdController.text;
              if (phone.isEmpty || pwd.isEmpty) {
                showToast("请正确输入账号和密码", position: StyledToastPosition.center);
                return;
              }

              var resp = await UserAccount.userRegister(phone, pwd);
              if (resp.data['code'] != 0) {
                showToast(resp.data['errmsg'], position: StyledToastPosition.center);
              } else {
                showToast("注册成功", position: StyledToastPosition.center);
                 Navigator.pop(context);
              }
            })
        ],
      ),
    );
  }
}

class _LoginAnimatedWidget extends AnimatedWidget {
  final Tween<double> _opacityTween = Tween(begin: 0, end: 1);
  final Tween<double> _offsetTween = Tween(begin: 40, end: 0);
  final Animation<double> animation;

  _LoginAnimatedWidget({required this.animation}) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.only(top: _offsetTween.evaluate(animation)),
        child: _LoginWidget(),
      ),
    );
  }
}
